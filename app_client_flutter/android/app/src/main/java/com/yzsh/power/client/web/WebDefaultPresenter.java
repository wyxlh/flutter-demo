package com.yzsh.power.client.web;


import com.blankj.utilcode.util.SPUtils;

import com.yzsh.power.client.net.Api;
import com.yzsh.power.client.net.ProgressSubscriber;
import com.yzsh.power.client.net.RxSchedulersHelper;
import com.yzsh.power.client.utils.SPConstant;
import com.yzsh.power.client.web.data.WebRestfulApi;
import okhttp3.MultipartBody;

public class WebDefaultPresenter implements WebDefaultControl.Presenter {

    private WebDefaultControl.View mView;
    public WebDefaultPresenter(WebDefaultControl.View view) {
        this.mView = view;
        mView.setPresenter(this);
    }

    @Override
    public void upLoadPic(MultipartBody.Part requestBody) {
        Api.getOldRetrofit().create(WebRestfulApi.class)
                .upLoadPic(requestBody)
                .compose(RxSchedulersHelper.io_main())
                .subscribe(new ProgressSubscriber<String>(mView) {
                    @Override
                    protected void onNoNetwork(String msg) {
                        mView.noNetwork(msg);
                    }

                    @Override
                    protected void onFailed(Throwable e, String msg) {
                        mView.reqFail(msg);
                    }

                    @Override
                    protected void onSucceed(String responseData) {
                        mView.upLoadPicSuc(responseData);
                    }
                });
    }

    @Override
    public void upLoadHeadPortrait(String base64String) {
        Api.getOldRetrofit().create(WebRestfulApi.class)
                .uploadHeadPortrait(SPUtils.getInstance().getString(SPConstant.YZC_USRE_ID),base64String)
                .compose(RxSchedulersHelper.io_main())
                .subscribe(new ProgressSubscriber<String>(mView) {
                    @Override
                    protected void onNoNetwork(String msg) {
                        mView.noNetwork(msg);
                    }

                    @Override
                    protected void onFailed(Throwable e, String msg) {
                        mView.reqFail(msg);
                    }

                    @Override
                    protected void onSucceed(String responseData) {
                        mView.upLoadHeadPortrait(responseData);
                    }
                });
    }
}
