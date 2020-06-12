package com.yzsh.power.client.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;

import com.blankj.utilcode.util.ScreenUtils;

import com.yzsh.power.client.R;
import com.yzsh.power.client.base.BaseActivity;

/**
 * Created by jiajia on 2017/2/15.
 */
public abstract class CenterDialog extends Dialog {
    protected Context context;

    public CenterDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId);
        this.context = context;
    }

    public CenterDialog(Context context) {
        this(context, R.style.dialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        View view = LayoutInflater.from(context).inflate(getLayoutId(), null);
        setContentView(view);
        initData(view);
        Window dialogWindow = this.getWindow();
        assert dialogWindow != null;
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = (int) (ScreenUtils.getScreenWidth() * 0.8f);
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        lp.gravity = Gravity.CENTER;
        dialogWindow.setAttributes(lp);
    }

    public CenterDialog setCancel(boolean flag) {
        this.setCancelable(flag);
        return this;
    }

    protected abstract void initData(View view);

    @LayoutRes
    protected abstract int getLayoutId();

    @Override
    public void show() {
        if (context instanceof BaseActivity) {
            return;
        }
        super.show();
    }
}
