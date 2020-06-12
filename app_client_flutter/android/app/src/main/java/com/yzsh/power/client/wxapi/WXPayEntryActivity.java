package com.yzsh.power.client.wxapi;

import android.content.Intent;
import android.util.Log;

import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;

import org.greenrobot.eventbus.EventBus;

import com.yzsh.power.client.MyApplication;
import com.yzsh.power.client.base.BaseActivity;
import com.yzsh.power.client.listener.WorkEvent;

public class WXPayEntryActivity extends BaseActivity implements IWXAPIEventHandler {

    private static final String TAG = "MicroMsg.SDKSample.WXPayEntryActivity";
    private IWXAPI mWxapi;

    public WXPayEntryActivity() {
    }

    @Override
    protected void setContentView() {

    }

    @Override
    protected void initData() {
        mWxapi = MyApplication.getInstance().getWXApi();
        mWxapi.handleIntent(this.getIntent(), this);
    }

    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        this.setIntent(intent);
        mWxapi.handleIntent(intent, this);
    }

    // 微信发送请求到第三方应用时，会回调到该方法
    public void onReq(BaseReq req) {
        Log.d("weixin", "aaa" + req.getType());
    }

    public void onResp(BaseResp resp) {
        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            Log.d("weixinpay", resp.errCode + ":" + resp.errStr);
            if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                toastShow("支付成功");
                EventBus.getDefault().post(new WorkEvent(WorkEvent.WX_PAY_SUCESS));
            } else {
                EventBus.getDefault().post(new WorkEvent(WorkEvent.WX_PAY_FAILED));
            }
        }
        this.finish();
    }
}