package io.flutter.plugins;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.baidu.mapapi.bikenavi.params.BikeNaviLaunchParam;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.walknavi.WalkNavigateHelper;
import com.baidu.mapapi.walknavi.adapter.IWEngineInitListener;
import com.baidu.mapapi.walknavi.adapter.IWRoutePlanListener;
import com.baidu.mapapi.walknavi.model.WalkRoutePlanError;
import com.baidu.mapapi.walknavi.params.WalkNaviLaunchParam;
import com.zxac.dingdong_flutter.MapActivity;
import com.zxac.dingdong_flutter.R;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class BaiduMapFlutterPlugin implements MethodChannel.MethodCallHandler {

    public static final String CHANNEL = "com.zxac.flutter.plugins/baiduMap";
    private static MethodChannel channel;
    private Activity activity;


    private BaiduMapFlutterPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        BaiduMapFlutterPlugin instance = new BaiduMapFlutterPlugin(registrar.activity());
        // setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method){
            case "mapView" :
                //解析参数
                String name = methodCall.argument("name");

                //带参数跳转到指定Activity
                Intent intent = new Intent(activity, MapActivity.class);
                intent.putExtra("name", name);
                activity.startActivity(intent);

                //返回给flutter的参数
                result.success(true);
                break;
            case "init":
                Intent intentMap = new Intent();
                intentMap.setClass(activity, MapActivity.class);
                activity.startActivity(intentMap);
                break;
        }

//        } else {
//            result.notImplemented();
//        }


    }
}