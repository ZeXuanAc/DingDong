package com.zxac.dingdong_flutter.utils;

import android.content.Context;
import android.util.Log;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.utils.DistanceUtil;

public class LocationUtil {

    private LocationClient locationClient;
    private Context context;
    private BDAbstractLocationListener listener;

    public LocationUtil (Context context, BDAbstractLocationListener listener) {
        this.context = context;
        this.listener = listener;
    }

    public static LocationClient init (Context context, BDAbstractLocationListener listener, LocationClientOption option){
        LocationClient locationClient = new LocationClient(context);

        locationClient.registerLocationListener(listener);

        if (option == null) {
            option = new LocationClientOption();
            //可选，设置定位模式，默认高精度
            //LocationMode.Hight_Accuracy：高精度；
            //LocationMode. Battery_Saving：低功耗；
            //LocationMode. Device_Sensors：仅使用设备；
            option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);

            //可选，设置返回经纬度坐标类型，默认GCJ02
            //GCJ02：国测局坐标；
            //BD09ll：百度经纬度坐标；
            //BD09：百度墨卡托坐标；
            //海外地区定位，无需设置坐标类型，统一返回WGS84类型坐标
            option.setCoorType("bd09ll");

            //可选，设置发起定位请求的间隔，int类型，单位ms
            //如果设置为0，则代表单次定位，即仅定位一次，默认为0
            //如果设置非0，需设置1000ms以上才有效
            option.setScanSpan(0);

            //可选，设置是否使用gps，默认false
            //使用高精度和仅用设备两种定位模式的，参数必须设置为true
            option.setOpenGps(true);

            //可选，设置是否当GPS有效时按照1S/1次频率输出GPS结果，默认false
            option.setLocationNotify(false);

            //可选，定位SDK内部是一个service，并放到了独立进程。
            //设置是否在stop的时候杀死这个进程，默认（建议）不杀死，即setIgnoreKillProcess(true)
            option.setIgnoreKillProcess(false);

            //可选，设置是否收集Crash信息，默认收集，即参数为false
            option.SetIgnoreCacheException(false);

            //可选，V7.2版本新增能力
            //如果设置了该接口，首次启动定位时，会先判断当前Wi-Fi是否超出有效期，若超出有效期，会先重新扫描Wi-Fi，然后定位
            option.setWifiCacheTimeOut(5*60*1000);

            //可选，设置是否需要过滤GPS仿真结果，默认需要，即参数为false
            option.setEnableSimulateGps(false);
        }
        //mLocationClient为第二步初始化过的LocationClient对象
        //需将配置好的LocationClientOption对象，通过setLocOption方法传递给LocationClient对象使用
        locationClient.setLocOption(option);

        return locationClient;
    }

    //根据经纬度得到距离计算缩放级别。
    public static Integer getZoom (LatLng startP, LatLng endP) {
        double distance = DistanceUtil.getDistance(startP, endP);
        Log.d("getZoom", "距离为：" + distance);
        if (distance <= 20) {
            return 22;
        }
        int[] zoom = new int[]{2,5,10,20,50,100,200,500,1000,2000,5000,10000,20000,25000,50000,100000,200000,500000,1000000,2000000};// 级别22到3。
        for (int i = 0, zoomLen = zoom.length; i < zoomLen; i++) {
            if(zoom[i] - distance > 0){
                return 22 - i + 5;
            }
        }
        return 15;
    }


}
