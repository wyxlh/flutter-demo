package com.yzsh.power.client;

import android.app.AlarmManager;
import android.app.Application;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.multidex.MultiDex;

import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.blankj.utilcode.util.Utils;
import com.hss01248.notifyutil.NotifyUtil;
import com.tencent.bugly.crashreport.CrashReport;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import com.yzsh.power.client.service.LocationService;
import com.yzsh.power.client.share.FileUtil;
import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.util.PathUtils;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.x;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.nio.Buffer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MyApplication extends FlutterApplication {
    private static MyApplication instance;
    private IWXAPI wxApi;
    private AMapLocationClient sLocationClient = null;
    private static AMapLocationClientOption mOption;

    @Override
    public void onCreate() {
        String srcPath = this.getFilesDir().getAbsolutePath() + File.separator + "cache" + File.separator;
        String dstPath = PathUtils.getDataDirectory(this) + File.separator + "flutter_assets" + File.separator;
        boolean enable = isEnablePatch(srcPath, dstPath);
        if (!enable) flutterDepatch(srcPath, dstPath);
        super.onCreate();
        if (enable) flutterPatch(srcPath, dstPath);
        instance = this;
        regToWx();
        x.Ext.init(this);
        NotifyUtil.init(this);
        CrashReport.initCrashReport(getApplicationContext(), "21f28b4b0b", true);//建议在测试阶段建议设置成true，发布时设置为false。
        Utils.init(this);

        int period = getIntMetaData("locationPeriod");
        if (period < 1000) period = 1000;
        LocationService.periodTime = period;
        Intent intent = new Intent(this, LocationService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    private static final String WX_APP_ID = "wx43029953df89d2ac";

    private void regToWx() {
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        //wxApi = WXAPIFactory.createWXAPI(this, WX_APP_ID, true);
        wxApi = WXAPIFactory.createWXAPI(this,null);
        // 将应用的appId注册到微信
        wxApi.registerApp(WX_APP_ID);
    }

    public IWXAPI getWXApi() {
        return wxApi;
    }

    public static MyApplication getInstance() {
        return instance;
    }

    public void flutterDepatch(String srcPath, String dstPath) {
        deleteFlutterPatch(srcPath + "isolate_snapshot_data", dstPath + "isolate_snapshot_data");
        deleteFlutterPatch(srcPath + "kernel_blob.bin", dstPath + "kernel_blob.bin");
        deleteFlutterPatch(srcPath + "vm_snapshot_data", dstPath + "vm_snapshot_data");
        deletePath(srcPath);
    }

    public void flutterPatch(String srcPath, String dstPath) {
        if (is64BitImpl()) {
            hookFlutterPatch(srcPath + "arm64/libapp.so", "aotSharedLibraryName");
        } else {
            hookFlutterPatch(srcPath + "armeabi/libapp.so", "aotSharedLibraryName");
        }

        copyFlutterPatch(srcPath + "isolate_snapshot_data", dstPath + "isolate_snapshot_data");
        copyFlutterPatch(srcPath + "kernel_blob.bin", dstPath + "kernel_blob.bin");
        copyFlutterPatch(srcPath + "vm_snapshot_data", dstPath + "vm_snapshot_data");
    }

    private String getFileMD5(String path) {
        BigInteger bi = null;
        try {
            byte[] buffer = new byte[8192];
            int len = 0;
            MessageDigest md = MessageDigest.getInstance("MD5");
            File f = new File(path);
            FileInputStream fis = new FileInputStream(f);
            while ((len = fis.read(buffer)) != -1) {
                md.update(buffer, 0, len);
            }
            fis.close();
            byte[] b = md.digest();
            bi = new BigInteger(1, b);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return bi.toString(16);
    }

    private boolean isEnablePatch(String srcPath, String dstPath) {
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(new File(srcPath + "version.json"))));
            String str = reader.readLine();
            JSONObject json = new JSONObject(str);
            int version = json.getInt("version");
            ApplicationInfo appInfo = getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            int baseVersion = appInfo.metaData.getInt("updateBaseVersion");
            Log.i("isEnablePatch", "baseVersion:"+baseVersion+",patch version:"+version);
            return baseVersion < version;
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void hookFlutterPatch(String path, String fieldName) {
        try {
            File f = new File(path);
            if (f.exists()) {
                //Log.i("hook flutter pack", "path:"+path+", field:"+fieldName+",absolutepath:"+f.getAbsolutePath());
                Field field = FlutterLoader.class.getDeclaredField(fieldName);
                if (field != null) {
                    field.setAccessible(true);
                    field.set(FlutterLoader.getInstance(), f.getAbsolutePath());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void copyFlutterPatch(String fromPath, String toPath) {
        try {
            File fSrc = new File(fromPath);
            File fDst = new File(toPath);
            if (fSrc.exists() && fDst.exists() && ((fSrc.length() != fDst.length()) || (getFileMD5(fromPath) != getFileMD5(toPath)))) {
                InputStream in = new FileInputStream(fromPath);
                OutputStream out = new FileOutputStream(toPath);
                byte buf[] = new byte [1024];
                int c;
                while ((c = in.read(buf)) > 0) {
                    out.write(buf, 0, c);
                }
                in.close();
                out.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteFlutterPatch(String fromPath, String toPath) {
        try {
            File fSrc = new File(fromPath);
            File fDst = new File(toPath);
            if (fSrc.exists() && fDst.exists() && (fSrc.length() == fDst.length()) && (getFileMD5(fromPath) == getFileMD5(toPath))) {
                fDst.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static boolean is64BitImpl() {
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                // Android API 21之前不支持64位CPU
                return false;
            }

            Class<?> clzVMRuntime = Class.forName("dalvik.system.VMRuntime");
            if (clzVMRuntime == null) {
                return false;
            }
            Method mthVMRuntimeGet = clzVMRuntime.getDeclaredMethod("getRuntime");
            if (mthVMRuntimeGet == null) {
                return false;
            }
            Object objVMRuntime = mthVMRuntimeGet.invoke(null);
            if (objVMRuntime == null) {
                return false;
            }
            Method sVMRuntimeIs64BitMethod = clzVMRuntime.getDeclaredMethod("is64Bit");
            if (sVMRuntimeIs64BitMethod == null) {
                return false;
            }
            Object objIs64Bit = sVMRuntimeIs64BitMethod.invoke(objVMRuntime);
            if (objIs64Bit instanceof Boolean) {
                return (boolean) objIs64Bit;
            }
        } catch (Throwable e) {
            //if (BuildConfig.DEBUG) {
                e.printStackTrace();
            //}
        }
        return false;
    }

    public void deletePath(String path) {
        try {
            File f = new File(path);
            if (f.exists()) {
                if (f.isDirectory()) {
                    File[] files = f.listFiles();
                    for (File file : files) {
                        deletePath(file.getAbsolutePath());
                    }
                }
                f.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getIntMetaData(String key) {
        try {
            ApplicationInfo appInfo = getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            return appInfo.metaData.getInt(key);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String getStringMetaData(String key) {
        try {
            ApplicationInfo appInfo = getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            return appInfo.metaData.getString(key);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }

    public void restartApp() {
        Intent i = getBaseContext().getPackageManager().getLaunchIntentForPackage(getBaseContext().getPackageName());
        PendingIntent pi = PendingIntent.getActivity(getApplicationContext(), 0, i, PendingIntent.FLAG_ONE_SHOT);
        AlarmManager mgr = (AlarmManager)getSystemService(Context.ALARM_SERVICE);
        mgr.set(AlarmManager.RTC, System.currentTimeMillis() + 1000, pi); //restart in 1s
        System.exit(0);
    }
}
