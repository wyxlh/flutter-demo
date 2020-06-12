package com.yzsh.power.client.channel;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import com.blankj.utilcode.util.SPUtils;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import com.yzsh.power.client.listener.WorkEvent;
import com.yzsh.power.client.share.ShareUtil;
import com.yzsh.power.client.utils.EmptyUtils;
import com.yzsh.power.client.utils.RSAUtil;
import com.yzsh.power.client.utils.SPConstant;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterMethodChannel implements MethodChannel.MethodCallHandler {
    private static String ff = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKElEBrpz7lY7ADUqDKusCKWLr\n" +
            "YHYmRNX5EM1tW8fyu3oRQHiNQqCzviI9W89e5k+v/48oGfA/wr5xlnXjr8ZEgZ4B\n" +
            "XQU5qpGP1qzsX9S6MU/wHM2GFadkkXLwx2d/cP4Wvg35pOQmkXCIT+B2LaFBIx07\n" +
            "0B19XmY9NhIvly9VTwIDAQAB";

    private static final String CHANNEL = "yzc_method_channel";

    public static FlutterMethodChannel instance = null;

    static MethodChannel _channel;
    private FlutterActivity _activity;

    //private HashMap<String, Result> _results = new HashMap<String, Result>();
    private Result _curResult = null;

    public static String longitude = ""; //经度信息
    public static String latitude = ""; //纬度信息
    public static String userId = ""; //用户ID

    public FlutterMethodChannel(FlutterActivity activity) {
        _activity = activity;
    }

    public static void registerWith(FlutterActivity activity, FlutterEngine engine) {
        _channel = new MethodChannel(engine.getDartExecutor(), CHANNEL);
        instance = new FlutterMethodChannel(activity);
        _channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {
        String method = methodCall.method;
        Log.i("FlutterMethodChannel", "onMethodCall: " + methodCall.method + "," + methodCall.arguments);
        if (method.equals("getHttpHeaders")) {
            HashMap<String, String> headers = new HashMap<String, String>();
            long currentTimeMillis = System.currentTimeMillis();

            try {
                JSONObject jsonObj = new JSONObject();
                PackageInfo packageInfo = getAppInfo();
                if (packageInfo != null) {
                    jsonObj.put("appVersion", packageInfo.versionName);
                }
                jsonObj.put("certification", RSAUtil.encryptDataByPublicKey((currentTimeMillis +
                        "502880496058fbb7016068fc201e0019").getBytes(), RSAUtil.keyStrToPublicKey
                        (ff)).trim());
                jsonObj.put("deviceToken", getMacAddress());
                jsonObj.put("osInformation", Build.MODEL + ":" + Build.VERSION.RELEASE);
                jsonObj.put("plat", "android");
                jsonObj.put("timestamp", String.valueOf(currentTimeMillis));

                if ((longitude.length() > 0) && (latitude.length() > 0)) {
                    jsonObj.put("longitude", longitude);
                    jsonObj.put("latitude", latitude);
                }

                result.success(jsonObj.toString());
            } catch (JSONException e) {
                e.printStackTrace();
                result.error("{}", null, null);
            }
        } else if (method.equals("updateUUID")) {
            userId = (String)methodCall.arguments;
            result.success("OK");
        } else if (method.equals("getHeadImage")) { //上传头像点击拍照
            _curResult = result;
            EventBus.getDefault().post(new WorkEvent(WorkEvent.UPDATE_HEAD_PORTRAIT_PHOTOGRAPH));
        } else if (method.equals("upLoadHeadImage")) { //从相册选择
            _curResult = result;
            EventBus.getDefault().post(new WorkEvent(WorkEvent.UPDATE_HEAD_PORTRAIT_ALBUM));
        } else if (method.equals("downLoadApp")) { //版本更新页面 点击下载最新版本
            EventBus.getDefault().post(new WorkEvent(WorkEvent.DOWN_LOAD_APP));
            result.success("OK");
        } else if (method.equals("placeOrder")) { //支付
            _curResult = result;
            EventBus.getDefault().post(new WorkEvent(WorkEvent.PAY_PARAMETER, methodCall.arguments));
            //result.success("OK");
        } else if (method.equals("shareWeixin")) { //分享图片到微信好友
            EventBus.getDefault().post(new WorkEvent(WorkEvent.SHARE_WEIXIN, methodCall.arguments));
            result.success("OK");
        } else if (method.equals("shareCircle")) { //分享图片到朋友圈
            EventBus.getDefault().post(new WorkEvent(WorkEvent.SHARE_CIRCLE, methodCall.arguments));
            result.success("OK");
        } else if (method.equals("copyUrl")) { //复制链接
            //获取剪贴板管理器：
            ClipboardManager cm = (ClipboardManager) _activity.getSystemService(Context.CLIPBOARD_SERVICE);
// 创建普通字符型ClipData
            ClipData mClipData = ClipData.newPlainText("Label", (String) methodCall.arguments);
// 将ClipData内容放到系统剪贴板里。
            cm.setPrimaryClip(mClipData);
            Toast.makeText(_activity, "已复制", Toast.LENGTH_SHORT).show();
            result.success("OK");
        } else if (method.equals("saveImg")) { //下载图片
            EventBus.getDefault().post(new WorkEvent(WorkEvent.JS_SAVE_IMG, methodCall.arguments));
            result.success("OK");
        } else if (method.equals("shareWeixinUrl")) { //分享url到微信好友
            ShareUtil.shareWebToWX(_activity, (String)  methodCall.arguments, SendMessageToWX.Req.WXSceneSession);
            result.success("OK");
        } else if (method.equals("phoneCilck")) { //联系客服
            EventBus.getDefault().post(new WorkEvent(WorkEvent.CALL_PHONE, methodCall.arguments));
            result.success("OK");
        } else if (method.equals("getAppInfo")) { //获取App 信息
            try {
                ApplicationInfo appInfo = _activity.getPackageManager().getApplicationInfo(_activity.getPackageName(), PackageManager.GET_META_DATA);
                int baseVersion = appInfo.metaData.getInt("updateBaseVersion");
                JSONObject jsonObj = new JSONObject();
                jsonObj.put("updateBaseVersion", baseVersion);
                //Log.i("getAppInfo", jsonObj.toString());
                result.success(jsonObj.toString());
                return;
            } catch (JSONException e) {
                e.printStackTrace();
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            result.error("{}", null, null);
        } else if (method.equals("reboot")) { //重启应用
            result.success("OK");
            EventBus.getDefault().post(new WorkEvent(WorkEvent.APP_REBOOT, methodCall.arguments));
        } else {
            result.notImplemented();
        }
    }

    public void processResult(boolean success, String result) {
        if (_curResult != null) {
            if (success) _curResult.success(result);
            else _curResult.error(result, null, null);
            _curResult = null;
        }
    }

    //private
    public PackageInfo getAppInfo() {
        PackageInfo packageInfo = null;
        try {
            packageInfo = _activity.getApplication().getPackageManager().getPackageInfo(_activity.getApplication().getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        //获取APP版本信息
        return packageInfo;
    }

    private String getMacAddress() {
        try {
            String macAddress = null;
            WifiManager wifiManager = (WifiManager) _activity.getApplication().getApplicationContext().getSystemService(Context.WIFI_SERVICE);
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

//class MD5Util {
//    private static final char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
//
//    /**
//     * Get MD5 of a file (lower case)
//     * @return empty string if I/O error when get MD5
//     */
//    @NonNull
//    public static String getFileMD5(@NonNull File file) {
//        FileInputStream in = null;
//        try {
//            in = new FileInputStream(file);
//            FileChannel ch = in.getChannel();
//            return MD5(ch.map(FileChannel.MapMode.READ_ONLY, 0, file.length()));
//        } catch (FileNotFoundException e) {
//            return "";
//        } catch (IOException e) {
//            return "";
//        } finally {
//            if (in != null) {
//                try {
//                    in.close();
//                } catch (IOException e) {
//                    // 关闭流产生的错误一般都可以忽略
//                }
//            }
//        }
//    }
//
//    /**
//     * MD5校验字符串
//     * @param s String to be MD5
//     * @return 'null' if cannot get MessageDigest
//     */
//    @NonNull
//    private static String getStringMD5(@NonNull String s) {
//        MessageDigest mdInst;
//        try {
//            // 获得MD5摘要算法的 MessageDigest 对象
//            mdInst = MessageDigest.getInstance("MD5");
//        } catch (NoSuchAlgorithmException e) {
//            e.printStackTrace();
//            return "";
//        }
//
//        byte[] btInput = s.getBytes();
//        // 使用指定的字节更新摘要
//        mdInst.update(btInput);
//        // 获得密文
//        byte[] md = mdInst.digest();
//        // 把密文转换成十六进制的字符串形式
//        int length = md.length;
//        char str[] = new char[length * 2];
//        int k = 0;
//        for (byte b : md) {
//            str[k++] = hexDigits[b >>> 4 & 0xf];
//            str[k++] = hexDigits[b & 0xf];
//        }
//        return new String(str);
//    }
//
//    @NonNull
//    private static String getSubStr(@NonNull String str, int subNu, char replace) {
//        int length = str.length();
//        if (length > subNu) {
//            str = str.substring(length - subNu, length);
//        } else if (length < subNu) {
//            // NOTE: padding字符填充在字符串的右侧，和服务器的算法是一致的
//            str += createPaddingString(subNu - length, replace);
//        }
//        return str;
//    }
//
//    @NonNull
//    private static String createPaddingString(int n, char pad) {
//        if (n <= 0) {
//            return "";
//        }
//
//        char[] paddingArray = new char[n];
//        Arrays.fill(paddingArray, pad);
//        return new String(paddingArray);
//    }
//
//    /**
//     * 计算MD5校验
//     * @param buffer
//     * @return 空串，如果无法获得 MessageDigest实例
//     */
//    @NonNull
//    private static String MD5(ByteBuffer buffer) {
//        String s = "";
//        try {
//            MessageDigest md = MessageDigest.getInstance("MD5");
//            md.update(buffer);
//            byte tmp[] = md.digest(); // MD5 的计算结果是一个 128 位的长整数，
//            // 用字节表示就是 16 个字节
//            char str[] = new char[16 * 2]; // 每个字节用 16 进制表示的话，使用两个字符，
//            // 所以表示成 16 进制需要 32 个字符
//            int k = 0; // 表示转换结果中对应的字符位置
//            for (int i = 0; i < 16; i++) { // 从第一个字节开始，对 MD5 的每一个字节
//                // 转换成 16 进制字符的转换
//                byte byte0 = tmp[i]; // 取第 i 个字节
//                str[k++] = hexDigits[byte0 >>> 4 & 0xf]; // 取字节中高 4 位的数字转换, >>>,
//                // 逻辑右移，将符号位一起右移
//                str[k++] = hexDigits[byte0 & 0xf]; // 取字节中低 4 位的数字转换
//            }
//            s = new String(str); // 换后的结果转换为字符串
//
//        } catch (NoSuchAlgorithmException e) {
//            e.printStackTrace();
//        }
//        return s;
//    }
//}
