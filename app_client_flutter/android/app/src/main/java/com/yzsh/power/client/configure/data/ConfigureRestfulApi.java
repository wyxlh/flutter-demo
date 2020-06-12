package com.yzsh.power.client.configure.data;

import com.yzsh.power.client.base.BaseResponse;
import com.yzsh.power.client.configure.data.req.PayOrderReq;
import com.yzsh.power.client.configure.data.resq.HomeResq;
import com.yzsh.power.client.configure.data.resq.UpdateAppInfoResp;
import com.yzsh.power.client.configure.data.resq.WXPayResp;
import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

interface ConfigureRestfulApi {
    @GET("app-partner/home/page/pageInfo")
    Observable<BaseResponse<HomeResq>> reqHome();

    @GET("app-system/app-system/v1/get/app/version")
    Observable<BaseResponse<UpdateAppInfoResp>> getAppInfo();

    @POST("app-partner/applyTemplate/unifiedOrder")
    Observable<BaseResponse<WXPayResp>> payOrderData(@Body PayOrderReq req);
}