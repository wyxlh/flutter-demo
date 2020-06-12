package com.yzsh.power.client.net;


import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

public class Api {
    private static OkHttpClient mOkHttpClient;
    private static Retrofit mRetrofit;
    private static Retrofit mOldRetrofit;

    public static Retrofit getRetrofit() {
        if (mRetrofit == null) {
            if (mOkHttpClient == null) {
                mOkHttpClient = ApiClient.getOkHttpClient();
            }
            mRetrofit = new Retrofit.Builder()
                    .baseUrl(HttpUtil.getURL())
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .client(mOkHttpClient)
                    .build();
        }
        return mRetrofit;
    }

    public static Retrofit getOldRetrofit() {
        if (mOldRetrofit == null) {
            if (mOkHttpClient == null) {
                mOkHttpClient = ApiClient.getOkHttpClient();
            }
            mOldRetrofit = new Retrofit.Builder()
                    .baseUrl(HttpUtil.getOldURL())
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .client(mOkHttpClient)
                    .build();
        }
        return mOldRetrofit;
    }
}
