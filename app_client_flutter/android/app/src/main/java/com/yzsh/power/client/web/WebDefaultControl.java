package com.yzsh.power.client.web;

import com.yzsh.power.client.net.BasePresenter;
import com.yzsh.power.client.net.BaseView;
import okhttp3.MultipartBody;

public interface WebDefaultControl {
    interface View extends BaseView<Presenter> {
        void reqFail(String msg);

        void upLoadPicSuc(String url);

        void upLoadHeadPortrait(String url);
    }

    interface Presenter extends BasePresenter {
        void upLoadPic(MultipartBody.Part file);

        void upLoadHeadPortrait(String base64String);
    }
}
