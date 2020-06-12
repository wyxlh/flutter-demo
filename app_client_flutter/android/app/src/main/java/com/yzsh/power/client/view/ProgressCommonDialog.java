package com.yzsh.power.client.view;

import android.app.Dialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.TextView;

import com.yzsh.power.client.R;

public class ProgressCommonDialog {
    private Dialog mDialog;

    public ProgressCommonDialog(Context context, String text) {
        LayoutInflater inflater = LayoutInflater.from(context);
        View view;
        view = inflater.inflate(R.layout.loading, null);
        assert context != null;
        mDialog = new Dialog(context, R.style.SubscribeDialog);
        mDialog.setContentView(view);
        ((TextView) view.findViewById(R.id.tv_content)).setText(text);
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
        mDialog.show();
    }

    public void cancelConnect() {

        if (mDialog != null) {
            mDialog.dismiss();
        }
    }
}
