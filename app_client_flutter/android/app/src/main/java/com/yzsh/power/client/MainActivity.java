package com.yzsh.power.client;

import android.Manifest;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.alipay.sdk.app.PayTask;
import com.blankj.utilcode.util.AppUtils;
import com.blankj.utilcode.util.ConvertUtils;
import com.blankj.utilcode.util.FileUtils;
import com.blankj.utilcode.util.ImageUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.tools.PictureFileUtils;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;
import java.util.Map;

import com.yzsh.power.client.area.alipay.PayResult;
import com.yzsh.power.client.base.BaseHandler;
import com.yzsh.power.client.channel.FlutterEventChannel;
import com.yzsh.power.client.channel.FlutterMethodChannel;
import com.yzsh.power.client.listener.WorkEvent;
import com.yzsh.power.client.share.ShareUtil;
import com.yzsh.power.client.share.WXShareMultiImageHelper;
import com.yzsh.power.client.utils.AppUpdateUtil;
import com.yzsh.power.client.utils.EmptyUtils;
import com.yzsh.power.client.view.ProgressCommonDialog;
import com.yzsh.power.client.web.WebDefaultControl;
import com.yzsh.power.client.web.WebDefaultPresenter;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;

public class MainActivity extends FlutterActivity  implements WebDefaultControl.View, BaseHandler.BaseHandlerCallBack {
  private static final int UPLOAD_HEAD_PORTRAIT = 211;
  public static final int PURCHASE_VIP_REQUEST_CODE = 302;

  private WebDefaultControl.Presenter _presenter;
  private RxPermissions _rxPermissions;
  private Handler mHandler = new BaseHandler<>(this);

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    new WebDefaultPresenter(this);
    EventBus.getDefault().register(this);
    _rxPermissions = new RxPermissions(this);
    _rxPermissions.request(Manifest.permission.WRITE_EXTERNAL_STORAGE,
      Manifest.permission.READ_PHONE_STATE,
      Manifest.permission.ACCESS_FINE_LOCATION,
      Manifest.permission.ACCESS_COARSE_LOCATION)
      .subscribe(granted -> {
          if (granted) {
          }
      });
  }

  @Override
  protected void onDestroy() {
    EventBus.getDefault().unregister(this);
    super.onDestroy();
  }

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    FlutterMethodChannel.registerWith(this, flutterEngine);
    FlutterEventChannel.registerWith(this, flutterEngine);
  }

  private String getPath(String time) {
    String path = Environment.getExternalStorageDirectory() + "/yzc_client/image/" + time;
    File file = new File(path);
    if (file.mkdirs()) {
      return path;
    }
    return path;
  }

  @Subscribe(threadMode = ThreadMode.MAIN)
  public void onMessageEvent(WorkEvent event) {
    switch (event.getWhat()) {
//      case WorkEvent.LOCATION_FINISH:
//        AMapLocation aMapLocation = (AMapLocation) event.getObj();
//
//        if (aMapLocation.getErrorCode() == 0) {
//          try {
//            JSONObject jsonObj = new JSONObject();
//            jsonObj.put("method", "updateLocation");
//            jsonObj.put("longitude", String.valueOf(aMapLocation.getLongitude()));
//            jsonObj.put("latitude", String.valueOf(aMapLocation.getLatitude()));
//              jsonObj.put("address", String.valueOf(aMapLocation.getAddress()));
//
//            FlutterEventChannel.instance.send(true, jsonObj.toString());
//          } catch (JSONException e) {
//            e.printStackTrace();
//            FlutterEventChannel.instance.send(false, "{\"method\":\"updateLocation\"}");
//          }
//        } else {
//          if (aMapLocation.getLocationDetail().contains("#")) {
//              Toast.makeText(this, aMapLocation.getLocationDetail().split("#")[0], Toast.LENGTH_SHORT).show();
//          } else {
//              Toast.makeText(this, aMapLocation.getLocationDetail(), Toast.LENGTH_SHORT).show();
//          }
//        }
//        break;
      case WorkEvent.OPEN_CAMERA:
        _rxPermissions.request(Manifest.permission.CAMERA)
                .subscribe(granted -> {
                  if (granted) {
                    PictureSelector.create(this)
                            .openGallery(PictureMimeType.ofImage())
                            .selectionMode(PictureConfig.SINGLE)
                            .compress(true)
                            .compressSavePath(getPath(System.currentTimeMillis() + ""))//压缩图片保存地址
                            .forResult(PictureConfig.CHOOSE_REQUEST);
                  } else {
                    Toast.makeText(MainActivity.this, "请打开相机权限", Toast.LENGTH_SHORT).show();
                  }
                });
        break;
      case WorkEvent.CALL_PHONE:
        _rxPermissions.request(Manifest.permission.CALL_PHONE)
                .subscribe(granted -> {
                  if (granted) {
                    Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + (String) event.getObj()));
                    startActivity(intent);
                  } else {
                    Toast.makeText(MainActivity.this, "请允许拨号权限后再试", Toast.LENGTH_SHORT).show();
                  }
                });
        break;
      case WorkEvent.PHOTOGRAPH:
        _rxPermissions.request(Manifest.permission.CAMERA)
                .subscribe(granted -> {
                  if (granted) {
                    PictureSelector.create(this)
                            .openCamera(PictureMimeType.ofImage())
                            .compress(true)
                            .compressSavePath(getPath(System.currentTimeMillis() + ""))//压缩图片保存地址
                            .forResult(PictureConfig.CHOOSE_REQUEST);
                  } else {
                    Toast.makeText(MainActivity.this, "请打开相机权限", Toast.LENGTH_SHORT).show();
                  }
                });
        break;
      case WorkEvent.UPDATE_HEAD_PORTRAIT_PHOTOGRAPH:
        _rxPermissions.request(Manifest.permission.CAMERA)
                .subscribe(granted -> {
                  if (granted) {
                    PictureSelector.create(this)
                            .openCamera(PictureMimeType.ofImage())
                            .compress(true)
                            .compressSavePath(getPath(System.currentTimeMillis() + ""))//压缩图片保存地址
                            .forResult(UPLOAD_HEAD_PORTRAIT);
                  } else {
                    FlutterMethodChannel.instance.processResult(false, "没有打开相机权限");
                    Toast.makeText(MainActivity.this, "请打开相机权限", Toast.LENGTH_SHORT).show();
                  }
                });
        break;
        case WorkEvent.UPDATE_HEAD_PORTRAIT_ALBUM://只是打开相册上传头像
            _rxPermissions.request(Manifest.permission.CAMERA)
                    .subscribe(granted -> {
                        if (granted) {
                            PictureSelector.create(this)
                                    .openGallery(PictureMimeType.ofImage())
                                    .selectionMode(PictureConfig.SINGLE)
                                    .compress(true)
                                    .compressSavePath(getPath(System.currentTimeMillis() + ""))//压缩图片保存地址
                                    .forResult(UPLOAD_HEAD_PORTRAIT);
                        } else {
                            FlutterMethodChannel.instance.processResult(false, "没有打开相机权限");
                            Toast.makeText(MainActivity.this, "请打开相机权限", Toast.LENGTH_SHORT).show();
                        }
                    });
            break;
        case WorkEvent.DOWN_LOAD_APP:
            AppUpdateUtil.checkUpdate(this);
            break;
        case WorkEvent.PAY_PARAMETER:
            Map data = (Map)event.getObj();
            if (data.containsKey("payMethod")) {
                switch ((int)data.get("payMethod")) {
                    case 0: //支付宝
                        // 必须异步调用
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                PayTask alipay = new PayTask(MainActivity.this);
                                Map<String, String> result = alipay.payV2(data.get("aliPay").toString(), true);
                                Message msg = new Message();
                                msg.obj = result;
                                mHandler.sendMessage(msg);
                            }
                        }).start();
                        break;
                    case 1: { //微信
                        if (!WXShareMultiImageHelper.isWXInstalled(MainActivity.this)) {
                            Toast.makeText(MainActivity.this, "请检查是否安装微信", Toast.LENGTH_SHORT).show();
                        }
                        IWXAPI msgApi = MyApplication.getInstance().getWXApi();
                        PayReq request = new PayReq();
                        request.appId = data.get("appid").toString();
                        request.partnerId = data.get("partnerid").toString();
                        request.prepayId = data.get("prepayid").toString();
                        request.packageValue = data.get("package").toString();
                        request.nonceStr = data.get("noncestr").toString();
                        request.timeStamp = data.get("timestamp").toString();
                        request.sign = data.get("sign").toString();
                        msgApi.sendReq(request);
                    }
                        break;
                }
            }
            break;
        case WorkEvent.WX_PAY_SUCESS:
            //微信支付成功
            //FlutterEventChannel.instance.send(true, "{\"method\":\"wxPaySuccess\"}");
            FlutterMethodChannel.instance.processResult(true, "微信支付成功");
            //mActivity.finish();
            break;
        case WorkEvent.WX_PAY_FAILED:
            FlutterMethodChannel.instance.processResult(false, "微信支付失败");
            break;
        case WorkEvent.SHARE_WEIXIN:
            ShareUtil.shareImageToWx(this, (String) event.getObj(), SendMessageToWX.Req.WXSceneSession);
            break;
        case WorkEvent.SHARE_CIRCLE:
            ShareUtil.shareImageToWx(this, (String) event.getObj(), SendMessageToWX.Req.WXSceneTimeline);
            break;
        case WorkEvent.JS_SAVE_IMG:
            if (EmptyUtils.isEmpty(event.getObj())) {
                Toast.makeText(MainActivity.this, "图片不合法", Toast.LENGTH_SHORT).show();
                return;
            }
            Glide.with(this).load((String) event.getObj()).into(new SimpleTarget<Drawable>() {
                @Override
                public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                    Bitmap bitmap = ImageUtils.drawable2Bitmap(resource);
                    if (EmptyUtils.isEmpty(bitmap))
                        return;
                    ProgressCommonDialog commonDialog = new ProgressCommonDialog(MainActivity.this, "保存中...");
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            Uri.parse(MediaStore.Images.Media.insertImage(MainActivity.this.getContentResolver(), bitmap, null, null));
                            (MainActivity.this).runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    commonDialog.cancelConnect();
                                    Toast.makeText(MainActivity.this, "保存成功", Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    }).start();
                }
            });
            break;
        case WorkEvent.APP_REBOOT:
            MyApplication.getInstance().restartApp();
            break;
        default:
            break;
    }
  }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != RESULT_OK) {
            switch (requestCode) {
                case PictureConfig.CHOOSE_REQUEST:
                    FlutterMethodChannel.instance.processResult(false, "选择图片失败");
                    break;
                case UPLOAD_HEAD_PORTRAIT:
                    FlutterMethodChannel.instance.processResult(false, "选择头像失败");
                    break;
            }
            return;
        }
        switch (requestCode) {
            case PictureConfig.CHOOSE_REQUEST:
                // 图片、视频、音频选择结果回调
                List<LocalMedia> selectList = PictureSelector.obtainMultipleResult(data);
                String compressPath = selectList.get(0).getCompressPath();
                RequestBody requestFile =
                        RequestBody.create(MediaType.parse("multipart/form-data"), FileUtils.getFileByPath(compressPath));
                MultipartBody.Part filePart = MultipartBody.Part.createFormData("uploadfile", "yzc" + System.currentTimeMillis(), requestFile);
                _presenter.upLoadPic(filePart);

                FlutterMethodChannel.instance.processResult(true, "选择图片成功");
                break;
            case UPLOAD_HEAD_PORTRAIT:
                // 图片、视频、音频选择结果回调
                List<LocalMedia> selectListHead = PictureSelector.obtainMultipleResult(data);
                String pathHead = selectListHead.get(0).getCompressPath();
                Glide.with(this).load(pathHead).into(new SimpleTarget<Drawable>(ConvertUtils.dp2px(80), ConvertUtils.dp2px(80)) {
                    @Override
                    public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                ByteArrayOutputStream baos = new ByteArrayOutputStream();// outputstream
                                ImageUtils.drawable2Bitmap(resource).compress(Bitmap.CompressFormat.JPEG, 10, baos);
                                byte[] bytes = baos.toByteArray();// 转为byte数组
                                String encode = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT);
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        _presenter.upLoadHeadPortrait(encode);
                                    }
                                });
                            }
                        }).start();
                    }
                });

                FlutterMethodChannel.instance.processResult(true, "选择头像成功");
                break;
            case PURCHASE_VIP_REQUEST_CODE:
                //dwebView.reload();
                break;
        }
    }

    @Override
    public void callBack(Message msg) {
        PayResult payResult = new PayResult((Map<String, String>) msg.obj);

//                    // 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
//                    String resultInfo = payResult.getResult();

        String resultStatus = payResult.getResultStatus();

        // 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
        if (TextUtils.equals(resultStatus, "9000")) {
            //FlutterEventChannel.instance.send(true, "{\"method\":\"aliPaySuccess\"}");
            FlutterMethodChannel.instance.processResult(true, "支付宝支付成功");
            //finish();
            Toast.makeText(MainActivity.this, "支付成功！", Toast.LENGTH_SHORT).show();
        } else {
            // 判断resultStatus 为非“9000”则代表可能支付失败
            // “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
            if (TextUtils.equals(resultStatus, "8000")) {
                Toast.makeText(MainActivity.this, "支付结果确认中！", Toast.LENGTH_SHORT).show();
            } else {
                // 其他值就可以判断为支付失败，包括用户主动取消支付(6001)，或者系统返回的错误
                Toast.makeText(MainActivity.this, "支付未成功！", Toast.LENGTH_SHORT).show();
            }
            FlutterMethodChannel.instance.processResult(false, "支付宝支付失败");
        }
    }

    @Override
    public void reqFail(String msg) {
        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void upLoadPicSuc(String url) {
        PictureFileUtils.deleteCacheDirFile(this);
        FlutterMethodChannel.instance.processResult(true, url);
    }

    @Override
    public void upLoadHeadPortrait(String url) {
        FlutterMethodChannel.instance.processResult(true, url);
    }

    @Override
    public void noNetwork(String msg) {
        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void setPresenter(WebDefaultControl.Presenter presenter) {
        _presenter = presenter;
    }

  private long exitTime = 0;
  @Override
  public void onBackPressed() {
    long timeMillis = System.currentTimeMillis();
    if (timeMillis - exitTime >= 4000) {
        Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_LONG).show();
        exitTime = timeMillis;
    } else {
        AppUtils.exitApp();
    }
  }
}
