package com.yzsh.power.client.net;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.yzsh.power.client.MyApplication;
import com.yzsh.power.client.base.BaseResponse;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public abstract class BaseSubscriber<T> implements Observer<BaseResponse<T>> {
    private static final int CODE = 200;
    private static final int OLD_CODE = 0;
    private Disposable disposable;

    @Override
    public void onNext(BaseResponse<T> baseResponse) {
        if (baseResponse.getCode() == CODE || baseResponse.getCode() == OLD_CODE) {
            onSucceed(baseResponse.getData());
            onSucceed(baseResponse.getMsg());
        } else {
            onFailed(new Exception(baseResponse.getMsg()), baseResponse.getMsg());
            onFailed(new Exception(baseResponse.getMsg()), baseResponse.getMsg(), baseResponse.getCode());
            onFailed(new Exception(baseResponse.getMsg()), baseResponse.getMsg(), baseResponse.getCode(), baseResponse.getData());
        }
    }


    @Override
    public void onError(Throwable e) {
        onFailed(e, RxExceptionUtil.exceptionHandler(e));
        onFailed(e, RxExceptionUtil.exceptionHandler(e), -1);
        onFailed(e, RxExceptionUtil.exceptionHandler(e), -1, null);
        cancelConnect();
    }

    @Override
    public void onComplete() {
        cancelConnect();
    }

    @Override
    public void onSubscribe(Disposable d) {
        disposable = d;
        if (!isNetworkAvalible()) {
            cancelConnect();
            onNoNetwork("请检查网络连接");
        }
    }

    protected void cancelConnect() {
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
        }
    }

    protected abstract void onNoNetwork(String msg);

    protected abstract void onFailed(Throwable e, String msg);

    protected void onFailed(Throwable e, String msg, int code) {

    }

    protected void onFailed(Throwable e, String msg, int code, T data) {

    }

    protected abstract void onSucceed(T responseData);

    protected void onSucceed(String msg) {

    }

    private boolean isNetworkAvalible() {
        // 获得网络状态管理器
        ConnectivityManager connectivityManager = (ConnectivityManager) MyApplication
                .getInstance()
                .getSystemService(Context.CONNECTIVITY_SERVICE);

        if (connectivityManager == null) {
            return false;
        } else {
            // 建立网络数组
            NetworkInfo[] net_info = connectivityManager.getAllNetworkInfo();

            if (net_info != null) {
                for (int i = 0; i < net_info.length; i++) {
                    // 判断获得的网络状态是否是处于连接状态
                    if (net_info[i].getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
