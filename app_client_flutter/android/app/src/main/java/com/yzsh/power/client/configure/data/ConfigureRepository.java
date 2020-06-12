package com.yzsh.power.client.configure.data;

import com.yzsh.power.client.base.BaseResponse;
import com.yzsh.power.client.configure.data.req.PayOrderReq;
import com.yzsh.power.client.configure.data.resq.HomeResq;
import com.yzsh.power.client.configure.data.resq.UpdateAppInfoResp;
import com.yzsh.power.client.configure.data.resq.WXPayResp;
import com.yzsh.power.client.net.Api;
import com.yzsh.power.client.net.RxSchedulersHelper;
import io.reactivex.Observable;

public class ConfigureRepository {
    private static ConfigureRepository instance;
    private ConfigureRestfulApi mConfigureRestfulApi;

    private ConfigureRepository() {
        mConfigureRestfulApi = Api.getRetrofit().create(ConfigureRestfulApi.class);
    }

    public static synchronized ConfigureRepository getInstance() {
        if (instance == null) {
            instance = new ConfigureRepository();
        }
        return instance;
    }

    public Observable<BaseResponse<HomeResq>> reqHome() {
        return mConfigureRestfulApi.reqHome().compose(RxSchedulersHelper.io_main());
    }

    public Observable<BaseResponse<UpdateAppInfoResp>> getAppInfo() {
        return mConfigureRestfulApi.getAppInfo().compose(RxSchedulersHelper.io_main());
    }

    public Observable<BaseResponse<WXPayResp>> payOrderData(PayOrderReq payOrderReq) {
        return mConfigureRestfulApi.payOrderData(payOrderReq).compose(RxSchedulersHelper.io_main());
    }
}
