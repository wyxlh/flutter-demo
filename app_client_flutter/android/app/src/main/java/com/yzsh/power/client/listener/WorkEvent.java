package com.yzsh.power.client.listener;

public class WorkEvent {
    public static final int LOCATION_FINISH = 1;
    public static final int OPEN_CAMERA = 5;//打开相册
    public static final int CALL_PHONE = 6;//拨打电话
    public static final int PHOTOGRAPH = 7;//拍照
    public static final int DOWN_LOAD_APP = 8;//版本更新
    public static final int UPDATE_HEAD_PORTRAIT_PHOTOGRAPH = 11;//通过拍照上传头像
    public static final int UPDATE_HEAD_PORTRAIT_ALBUM = 12;//通过相册上传头像
    public static final int WX_PAY_SUCESS = 15;//微信支付成功
    public static final int WX_AUTHO_SUC = 16;//微信授权成功
    public static final int PAY_PARAMETER = 17;//运费支付的参数
    public static final int SHARE_WEIXIN = 18;//分享到微信好友
    public static final int SHARE_CIRCLE = 19;//分享到微信朋友圈
    public static final int JS_SAVE_IMG = 20;//保存图片
    public static final int WX_PAY_FAILED = 21;//微信支付失败
    public static final int APP_REBOOT = 99;//重启应用

    private int what;
    private Object obj;
    private Object obj2;

    public WorkEvent() {
    }

    public WorkEvent(int what, Object obj) {
        this.what = what;
        this.obj = obj;
    }

    public WorkEvent(int what, Object obj, Object obj2) {
        this.what = what;
        this.obj = obj;
        this.obj2 = obj2;
    }

    public Object getObj2() {
        return obj2;
    }

    public WorkEvent(int what) {
        this.what = what;
    }

    public int getWhat() {
        return what;
    }

    public void setWhat(int what) {
        this.what = what;
    }

    public Object getObj() {
        return obj;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }
}
