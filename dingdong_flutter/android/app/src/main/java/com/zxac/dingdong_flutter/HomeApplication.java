package com.zxac.dingdong_flutter;

import android.app.Application;

import com.baidu.mapapi.SDKInitializer;

import io.flutter.app.FlutterApplication;

public class HomeApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        SDKInitializer.initialize(this);
    }
}
