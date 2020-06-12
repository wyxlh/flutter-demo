package com.yzsh.power.client.share;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.blankj.utilcode.util.ImageUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.yzsh.power.client.MyApplication;
import com.yzsh.power.client.R;
import com.yzsh.power.client.web.ShareType;
import io.reactivex.annotations.NonNull;

public class ShareUtil {
    public static final String PACKAGE_WECHAT = "com.tencent.mm";//微信
    public static final String PACKAGE_MOBILE_QQ = "com.tencent.mobileqq";//qq

    /**
     * 分享多张图片到朋友圈
     *
     * @param context context
     * @param files   图片集合
     */
    public static void shareMultiplePictureToTimeLine(Context context, List<File> files) {
        try {
            Intent intent = new Intent();
            ComponentName comp = new ComponentName(PACKAGE_WECHAT, "com.tencent.mm.ui.tools.ShareToTimeLineUI");
            intent.setComponent(comp);
            intent.setAction(Intent.ACTION_SEND_MULTIPLE);
            intent.setType("image/*");

            ArrayList<Uri> imageUris = new ArrayList<>();
            for (File f : files) {
                imageUris.add(Uri.fromFile(f));
            }
            intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, imageUris);
            intent.putExtra("Kdescription", "shareMultiplePictureToTimeLine");
            context.startActivity(intent);
        } catch (Exception e) {
            Toast.makeText(context, "请先安装微信客户端", Toast.LENGTH_SHORT).show();
        }
    }

    private static void shareTextToWx(String text, int type) {
        //初始化一个 WXTextObject 对象，填写分享的文本内容
        WXTextObject textObj = new WXTextObject();
        textObj.text = text;

//用 WXTextObject 对象初始化一个 WXMediaMessage 对象
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = textObj;
        msg.description = text;

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("text");
        req.message = msg;
        // 分享到对话:
        // SendMessageToWX.Req.WXSceneSession
        //  分享到朋友圈:
        //  SendMessageToWX.Req.WXSceneTimeline ;
        req.scene = type;
//调用api接口，发送数据到微信
        MyApplication.getInstance().getWXApi().sendReq(req);
    }

    public static void shareWebToWX(Context context, String url, int type) {
//初始化一个WXWebpageObject，填写url
        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = url;

//用 WXWebpageObject 对象初始化一个 WXMediaMessage 对象
        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = "云智充";
        msg.description = "发放充电卷";
        Bitmap thumbBmp = BitmapFactory.decodeResource(context.getResources(), R.mipmap.logo);
        msg.thumbData = bmpToByteArray(thumbBmp, true);
//构造一个Req
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("webpage");
        req.message = msg;
        req.scene = type;
        MyApplication.getInstance().getWXApi().sendReq(req);
    }

    public static void shareImageToWx(Context context, String url, int type) {
        Glide.with(context).load(url).into(new SimpleTarget<Drawable>() {
            @Override
            public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                Bitmap bitmap = ImageUtils.drawable2Bitmap(resource);
                WXImageObject imgObj = new WXImageObject(bitmap);
                WXMediaMessage msg = new WXMediaMessage();
                msg.mediaObject = imgObj;
                //设置缩略图
                Bitmap thumbBmp = Bitmap.createScaledBitmap(bitmap, 100, 150, true);
                bitmap.recycle();//如果回收，下次glide的缓存机制，会导致找不到bitmap;不回收会怎样?不断的创建对象，会导致内存溢出
                msg.thumbData = bmpToByteArray(thumbBmp, true);
                //构造一个Req
                SendMessageToWX.Req req = new SendMessageToWX.Req();
                req.transaction = buildTransaction("img");
                req.message = msg;
                req.scene = type;
                //调用api接口，发送数据到微信
                MyApplication.getInstance().getWXApi().sendReq(req);
            }
        });
    }

    public static void shareViewToWx(Context context, ArrayList<Uri> views, ShareType type) {
        Intent intent = new Intent();
        ComponentName comp = null;
        switch (type) {
            case WX://微信好友
                comp = new ComponentName("com.tencent.mm",
                        "com.tencent.mm.ui.tools.ShareImgUI");
                break;
            case CIRCLE://朋友圈
//                comp = new ComponentName("com.tencent.mm",
//                        "com.tencent.mm.ui.tools.ShareToTimeLineUI");
                intent.setClassName("com.tencent.mm",
                        "com.tencent.mm.ui.tools.ShareToTimeLineUI");
                break;

        }
        // intent.setComponent(comp);

        intent.setAction(Intent.ACTION_SEND_MULTIPLE);
        intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, views);
        intent.setType("image/*");
        context.startActivity(intent);
    }

    private static String buildTransaction(String type) {
        return type == null ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }

    private static byte[] bmpToByteArray(Bitmap bmp, boolean needRecycle) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG, 100, output);
        if (needRecycle) {
            bmp.recycle();
        }

        byte[] result = output.toByteArray();

        try {
            output.close();
        } catch (Exception var5) {
            var5.printStackTrace();
        }

        return result;
    }
}
