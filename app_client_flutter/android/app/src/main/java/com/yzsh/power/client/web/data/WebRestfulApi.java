package com.yzsh.power.client.web.data;

import com.yzsh.power.client.base.BaseResponse;
import io.reactivex.Observable;
import okhttp3.MultipartBody;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.Query;

public interface WebRestfulApi {

    @Multipart
    @POST("common/uploadfile")
    Observable<BaseResponse<String>> upLoadPic(@Part() MultipartBody.Part file);

    //头像
    @POST("admin/uploadPicture")
    Observable<BaseResponse<String>> uploadHeadPortrait(@Query("uuid") String uuid, @Query("img") String img);
}