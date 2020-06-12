package com.yzsh.power.client.share;

import android.Manifest;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.core.content.ContextCompat;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by StoneHui on 2018/12/12.
 * <p>
 * 微信多图分享辅助类。
 */
public class WXShareMultiImageHelper {

    private static final String WX_PACKAGE_NAME = "com.tencent.mm";
    private static final String LAUNCHER_UI = "com.tencent.mm.ui.LauncherUI";
    private static final String SHARE_IMG_UI = "com.tencent.mm.ui.tools.ShareImgUI";
    private static final String SHARE_TO_TIMELINE_UI = "com.tencent.mm.ui.tools.ShareToTimeLineUI";

    // 微信 v6.7.3 版本的 versionCode 。
    private static final int WX_V673 = 1360;
    // 微信 v7.0.0 版本的 versionCode 。
    private static final int WX_V700 = 1380;

    /**
     * 是否安装了微信。
     */
    public static boolean isWXInstalled(Context context) {
        List<PackageInfo> packageInfoList = context.getPackageManager().getInstalledPackages(0);
        for (PackageInfo info : packageInfoList) {
            if (info.packageName.equalsIgnoreCase(WX_PACKAGE_NAME)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 获取微信的版本号。
     */

    public static int getWXVersionCode(Context context) {
        List<PackageInfo> packageInfoList = context.getPackageManager().getInstalledPackages(0);
        for (PackageInfo info : packageInfoList) {
            if (info.packageName.equalsIgnoreCase(WX_PACKAGE_NAME)) {
                return info.versionCode;
            }
        }
        return 0;
    }

    /**
     * 是否有存储权限。
     */
    public static boolean hasStoragePermission(Context context) {
        return ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }

    // 检查是否可以分享。
    private static boolean checkShareEnable(Context context) {
        if (!hasStoragePermission(context)) {
            Toast.makeText(context, "没有存储权限，无法分享", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (!isWXInstalled(context)) {
            Toast.makeText(context, "未安装微信", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    // 打开分享界面。
    private static void openShareUI(Context context, String text, List<Uri> uriList, String ui) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND_MULTIPLE);
        intent.setComponent(new ComponentName(WX_PACKAGE_NAME, ui));
        intent.setType("image/*");
        intent.putStringArrayListExtra(Intent.EXTRA_TEXT, new ArrayList<String>());
        intent.putExtra("Kdescription", text);
        intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, new ArrayList<>(uriList));
        context.startActivity(intent);
    }

    // 打开分享朋友圈界面。
    private static void openShareLineUI(Context context, List<Uri> uriList, String ui) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND_MULTIPLE);
        intent.setComponent(new ComponentName(WX_PACKAGE_NAME, ui));
        intent.setType("image/*");
        intent.putStringArrayListExtra(Intent.EXTRA_TEXT, new ArrayList<String>());
        intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, new ArrayList<>(uriList));
        context.startActivity(intent);
    }

    private static void openShareLineUI(Context context, Uri uri, String ui) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND);
        intent.setComponent(new ComponentName(WX_PACKAGE_NAME, ui));
        intent.setType("image/*");
        intent.putExtra(Intent.EXTRA_STREAM, uri);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    /**
     * 分享到好友会话。
     *
     * @param activity  [Context]
     * @param imageList 图片列表。
     */
    public static void shareToSession(Activity activity, List<Bitmap> imageList) {
        shareToSession(activity, imageList, "");
    }

    /**
     * 分享到好友会话。
     *
     * @param activity  [Context]
     * @param imageList 图片列表。
     * @param text      分享文本。
     */
    public static void shareToSession(final Activity activity, final List<Bitmap> imageList, final String text) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ShareInfo.setAuto(false);
                if (checkShareEnable(activity)) {
                    if (!TextUtils.isEmpty(text)) {
                        ClipboardUtil.setPrimaryClip(activity, "", text);
                        Toast.makeText(activity, "文字已复制到剪切板", Toast.LENGTH_LONG).show();
                    }
                    clearTmpFile(activity);
                    String dir = getTmpFileDir(activity);
                    List<Uri> uriList = new ArrayList<>();
                    for (Bitmap bitmap : imageList) {
                        uriList.add(Uri.fromFile(new File(saveBitmap(dir, bitmap))));
                    }
                    openShareUI(activity, text, uriList, SHARE_IMG_UI);
                }
            }
        });
    }

    public static void shareToSession(final Activity activity, Bitmap bitmap) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ShareInfo.setAuto(false);
                if (checkShareEnable(activity)) {
                    clearTmpFile(activity);
                    String dir = getTmpFileDir(activity);
                    List<Uri> uriList = new ArrayList<>();
                    uriList.add(Uri.fromFile(new File(saveBitmap(dir, bitmap))));
                    openShareUI(activity, "", uriList, SHARE_IMG_UI);
                }
            }
        });
    }

    /**
     * 分享到朋友圈。
     *
     * @param activity  [Context]
     * @param imageList 图片列表。
     */
    public static void shareToTimeline(Activity activity, List<Bitmap> imageList) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ShareInfo.setAuto(false);
                if (checkShareEnable(activity)) {
                    clearTmpFile(activity);
                    String dir = getTmpFileDir(activity);
                    List<Uri> uriList = new ArrayList<>();
                    for (Bitmap bitmap : imageList) {
                        uriList.add(Uri.fromFile(new File(saveBitmap(dir, bitmap))));
                    }
                    openShareLineUI(activity, uriList, SHARE_TO_TIMELINE_UI);
                }
            }
        });
    }

    public static void shareToTimeline(Activity activity, Bitmap bitmap) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ShareInfo.setAuto(false);
                if (checkShareEnable(activity)) {
                    clearTmpFile(activity);
                    String dir = getTmpFileDir(activity);
                    Uri uri = Uri.fromFile(new File(saveBitmap(dir, bitmap)));
                    openShareLineUI(activity, uri, SHARE_TO_TIMELINE_UI);
                }
            }
        });
    }

    // 打开分享界面
    private static void internalShareToTimeline(Context context, String text, List<Uri> uriList, boolean isAuto) {
        int wxCode = getWXVersionCode(context);
        if (wxCode < WX_V673) {
            shareToTimelineUIV673Lower(context, text, uriList);
        } else if (wxCode < WX_V700) {
            shareToTimelineUIV673(context, text, uriList, isAuto);
        } else {
            shareToTimelineUIV700(context, text, uriList, isAuto);
        }
    }

    // 分享到微信 v6.7.3 以下 。
    private static void shareToTimelineUIV673Lower(Context context, String text, List<Uri> uriList) {
        if (!TextUtils.isEmpty(text)) {
            ClipboardUtil.setPrimaryClip(context, "", text);
            Toast.makeText(context, "文字已复制到剪切板", Toast.LENGTH_LONG).show();
        }
        openShareUI(context, text, uriList, SHARE_TO_TIMELINE_UI);
    }

    // 分享到微信 v6.7.3 。
    private static void shareToTimelineUIV673(Context context, String text, List<Uri> uriList, boolean isAuto) {

        if (!TextUtils.isEmpty(text)) {
            ClipboardUtil.setPrimaryClip(context, "", text);
            if (!isAuto) {
                Toast.makeText(context, "长按粘贴文字\n点击加号添加剩余图片", Toast.LENGTH_LONG).show();
            }
        } else {
            if (!isAuto) {
                Toast.makeText(context, "点击加号添加剩余图片", Toast.LENGTH_LONG).show();
            }
        }

        ShareInfo.setAuto(isAuto);
        ShareInfo.setText(text);
        ShareInfo.setImageCount(1, uriList.size() - 1);

        openShareUI(context, text, uriList.subList(0, 1), SHARE_TO_TIMELINE_UI);
    }

    // 分享到微信 v7.0.0 。
    private static void shareToTimelineUIV700(Context context, String text, List<Uri> uriList, boolean isAuto) {

        if (!TextUtils.isEmpty(text)) {
            ClipboardUtil.setPrimaryClip(context, "", text);
            if (!isAuto) {
                Toast.makeText(context, "文字已复制到剪切板\n图片已保存至相册\n打开朋友圈即可分享", Toast.LENGTH_LONG).show();
            }
        } else {
            if (!isAuto) {
                Toast.makeText(context, "图片已保存至相册，打开朋友圈即可分享", Toast.LENGTH_LONG).show();
            }
        }

        ShareInfo.setAuto(isAuto);
        ShareInfo.setText(text);
        ShareInfo.setImageCount(0, uriList.size());

        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.setAction(Intent.ACTION_MAIN);
        intent.setComponent(new ComponentName(WX_PACKAGE_NAME, LAUNCHER_UI));
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    // 文件临时保存目录。
    private static String getTmpFileDir(Context context) {
        File parent = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        String child = String.format("%s%sshareTmp", context.getPackageName(), File.separator);
        File file = new File(parent, child);
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    /**
     * 清理临时文件。可在分享完成后调用该函数。
     */
    public static void clearTmpFile(Context context) {

        File fileDir = new File(getTmpFileDir(context));

        // 通知相册删除图片。
        for (File file : fileDir.listFiles()) {
            context.getContentResolver().delete(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    MediaStore.Images.Media.DATA + "=?",
                    new String[]{file.getAbsolutePath()});
        }

        // 删除图片文件。
        FileUtil.clearDir(fileDir);
    }

    // 保存图片并返回 Uri 。
    private static String saveBitmap(String dir, Bitmap bitmap) {
        String path = String.format("%s%s%s.jpg", dir, File.separator, System.currentTimeMillis());
        try {
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, new FileOutputStream(path));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return path;
    }

}