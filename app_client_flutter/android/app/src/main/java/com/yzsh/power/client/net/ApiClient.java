package com.yzsh.power.client.net;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import androidx.annotation.NonNull;

import com.blankj.utilcode.util.SPUtils;
import com.blankj.utilcode.util.Utils;

import java.io.IOException;
import java.net.Proxy;
import java.util.concurrent.TimeUnit;

import com.yzsh.power.client.MyApplication;
import com.yzsh.power.client.utils.EmptyUtils;
import com.yzsh.power.client.utils.RSAUtil;
import com.yzsh.power.client.utils.SPConstant;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.logging.HttpLoggingInterceptor;


public class ApiClient {

    private static final int CONNECT_TIME_OUT = 15; // 连接时间
    private static final int READ_TIME_OUT = 15; // 读取时间
    private static final int WRITE_TIME_OUT = 15; // 写入时间
    private static String isTest = "1";      // 99默认为测试,1
    private static String VERSION = "1.0";      // 接口版本号
    private static String ff = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKElEBrpz7lY7ADUqDKusCKWLr\n" +
            "YHYmRNX5EM1tW8fyu3oRQHiNQqCzviI9W89e5k+v/48oGfA/wr5xlnXjr8ZEgZ4B\n" +
            "XQU5qpGP1qzsX9S6MU/wHM2GFadkkXLwx2d/cP4Wvg35pOQmkXCIT+B2LaFBIx07\n" +
            "0B19XmY9NhIvly9VTwIDAQAB";
    private static String appType = "1";//0是云智充app;1是云智充合伙人app

    static OkHttpClient getOkHttpClient() {
        // 添加日志拦截器
//        HttpLoggingInterceptor loggingInterceptor = new NHttpLoggingInterceptor();
//        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .connectTimeout(CONNECT_TIME_OUT, TimeUnit.SECONDS)
                .readTimeout(READ_TIME_OUT, TimeUnit.SECONDS)
                .writeTimeout(WRITE_TIME_OUT, TimeUnit.SECONDS)
                .proxy(Proxy.NO_PROXY)
//                .addInterceptor(loggingInterceptor)
                .retryOnConnectionFailure(true);//设置防止第三方抓包
        // 添加统一的head
        addInterceptor(builder);
        return builder.build();
    }

    private static void addInterceptor(OkHttpClient.Builder builder) {
        builder.addInterceptor(new Interceptor() {
            @NonNull
            @Override
            public Response intercept(@NonNull Chain chain) throws IOException {
                long currentTimeMillis = System.currentTimeMillis();
                Request.Builder addHeader = chain.request()
                        .newBuilder()
                        .addHeader("Content-type", "application/json")
                        .addHeader("appType", appType)
                        .addHeader("appVersion", getAppInfo().versionName + "")
                        .addHeader("certType", "1")
                        .addHeader("certification", RSAUtil.encryptDataByPublicKey((currentTimeMillis +
                                "502880496058fbb7016068fc201e0019").getBytes(), RSAUtil.keyStrToPublicKey
                                (ff)).trim())
                        .addHeader("channel", "yzc-baidu")
                        .addHeader("deviceToken", getMacAddress())
                        .addHeader("isTest", isTest)
                        .addHeader("osInformation", Build.MODEL + ":" + Build.VERSION.RELEASE)
                        .addHeader("plat", "android")
                        .addHeader("timestamp", currentTimeMillis + "")
                        .addHeader("version", VERSION);
                SPUtils sp = SPUtils.getInstance();
                if (!EmptyUtils.isEmpty(sp.getString(SPConstant.LATITUDE)))
                    addHeader.addHeader("latitude", sp.getString(SPConstant.LATITUDE));
                if (!EmptyUtils.isEmpty(sp.getString(SPConstant.LONGITUDE)))
                    addHeader.addHeader("longitude", sp.getString(SPConstant.LONGITUDE));
                if (!EmptyUtils.isEmpty(sp.getString(SPConstant.YZC_USRE_ID)))
                    addHeader.addHeader("userId", sp.getString(SPConstant.YZC_USRE_ID));
                Request request = addHeader.build();
                return chain.proceed(request);
            }
        });
    }

    public static PackageInfo getAppInfo() {
        PackageInfo packageInfo = null;
        try {
            packageInfo = MyApplication.getInstance().getPackageManager()
                    .getPackageInfo(MyApplication.getInstance().getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        //获取APP版本信息
        return packageInfo;
    }


    private static String getMacAddress() {

        try {
            String macAddress = null;
            WifiManager wifiManager =
                    (WifiManager) MyApplication.getInstance().getApplicationContext().getSystemService
                            (Context.WIFI_SERVICE);
            WifiInfo info = (null == wifiManager ? null : wifiManager.getConnectionInfo());
            if (null != info) {
                macAddress = info.getMacAddress();
            }
            if (macAddress == null)
                return "02:00:00:00:00:00";
            return macAddress;
        } catch (Exception e) {
            return "02:00:00:00:00:00";
        }
    }
}
