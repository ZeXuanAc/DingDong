package com.zxac.dingdong_flutter;

import android.util.Log;

import com.baidu.mapapi.SDKInitializer;

import io.flutter.app.FlutterApplication;

public class HomeApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i("aaaa", "123");
        SDKInitializer.initialize(this);
    }
}
