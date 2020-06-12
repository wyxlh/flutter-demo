package com.yzsh.power.client.service;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.blankj.utilcode.util.Utils;

import java.util.Timer;
import java.util.TimerTask;

import com.yzsh.power.client.R;
import com.yzsh.power.client.channel.FlutterMethodChannel;
import com.yzsh.power.client.utils.EmptyUtils;
import com.yzsh.power.client.utils.SPUtils;

public class LocationService extends Service {
    static public int periodTime = 5 * 60 * 1000;

    private AMapLocationClient sLocationClient = null;
    private static AMapLocationClientOption mOption;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {  //在onCreate()方法中打印了一个log便于测试
        super.onCreate();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("yzc_partner", getString(R.string.app_name), NotificationManager.IMPORTANCE_MIN);
            channel.enableVibration(false);//去除振动

            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            if (manager != null) manager.createNotificationChannel(channel);

            Notification.Builder builder = new Notification.Builder(getApplicationContext(), "yzc_partner")
//                    .setContentTitle("正在后台运行")
                    .setSmallIcon(R.mipmap.logo);
            startForeground(1234321, builder.build());//id must not be 0,即禁止是0

            //startForeground(1234321, new Notification());
        }

        initLocation();

        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                LocationService.this.startLocation();
            }
        }, 0, periodTime);
    }

    private void initLocation() {
        sLocationClient = new AMapLocationClient(this);
        sLocationClient.setLocationListener(new AMapLocationListener() {
            @Override
            public void onLocationChanged(AMapLocation aMapLocation) {
                LocationService.this.stopLocation();
                FlutterMethodChannel.longitude = String.valueOf(aMapLocation.getLongitude());    //获取经度信息
                FlutterMethodChannel.latitude = String.valueOf(aMapLocation.getLatitude());    //获取纬度信息
                Log.i("LocationService", "pos(" + FlutterMethodChannel.longitude + "," + FlutterMethodChannel.latitude +"):" + aMapLocation.getAddress());
            }
        });
        mOption = new AMapLocationClientOption();
        mOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.SignIn);//默认签到
        mOption.setOnceLocation(true);
        mOption.setLocationCacheEnable(false);//关闭缓存机制
        sLocationClient.setLocationOption(mOption);
    }

    public void startLocation() {
        if (!EmptyUtils.isEmpty(sLocationClient)) {
            sLocationClient.startLocation();
        }
    }

    public void stopLocation() {
        if (!EmptyUtils.isEmpty(sLocationClient) && sLocationClient.isStarted()) {
            sLocationClient.stopLocation();
        }
    }
}
