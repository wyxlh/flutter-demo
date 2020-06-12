package com.yzsh.power.client.net;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;

import com.yzsh.power.client.MyApplication;
import com.yzsh.power.client.R;
import com.yzsh.power.client.utils.EmptyUtils;

public abstract class ProgressSubscriber<T> extends BaseSubscriber<T> {
    private Dialog mDialog;
    private Context mContext;

    public ProgressSubscriber(BaseView baseView) {
        Context context;
        if (EmptyUtils.isEmpty(baseView)) {
            return;
        }
        if (baseView instanceof Activity) {
            context = (Activity) baseView;
        } else {
            context = MyApplication.getInstance().getApplicationContext();
        }
        mContext = context;

        LayoutInflater inflater = LayoutInflater.from(context);
        View view;
        view = inflater.inflate(R.layout.loading, null);
        assert context != null;
        mDialog = new Dialog(context, R.style.SubscribeDialog);
        mDialog.setContentView(view);
        Animation animation = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        animation.setRepeatCount(Animation.INFINITE);//动画的重复次数
        animation.setRepeatMode(Animation.RESTART);
        LinearInterpolator lir = new LinearInterpolator();
        animation.setInterpolator(lir);
        animation.setDuration(500);
        View loadCycle = view.findViewById(R.id.iv_load_cycle);
        loadCycle.startAnimation(animation);
        if (mDialog.getWindow() != null)
            mDialog.getWindow().setDimAmount(0);
        if (EmptyUtils.isEmpty(mDialog))
            return;
        mDialog.setCanceledOnTouchOutside(false);
        if (context instanceof Activity)
            mDialog.show();
    }

    public ProgressSubscriber(Context context) {
        if (EmptyUtils.isEmpty(context)) {
            return;
        }
        mContext = context;
        LayoutInflater inflater = LayoutInflater.from(context);
        View view;
        view = inflater.inflate(R.layout.loading, null);
        mDialog = new Dialog(context, R.style.SubscribeDialog);
        mDialog.setContentView(view);
        Animation animation = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        animation.setRepeatCount(Animation.INFINITE);//动画的重复次数
        animation.setRepeatMode(Animation.RESTART);
        LinearInterpolator lir = new LinearInterpolator();
        animation.setInterpolator(lir);
        animation.setDuration(500);
        View loadCycle = view.findViewById(R.id.iv_load_cycle);
        loadCycle.startAnimation(animation);
        if (mDialog.getWindow() != null)
            mDialog.getWindow().setDimAmount(0);
        mDialog.setCanceledOnTouchOutside(false);
        if (context instanceof Activity)
            mDialog.show();
    }

    public ProgressSubscriber() {

    }

    @Override
    protected void cancelConnect() {
        super.cancelConnect();
        if (mDialog != null) {
            if (mContext instanceof Activity)
                mDialog.dismiss();
        }
    }
}
