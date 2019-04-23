package com.zxac.dingdong_flutter;

import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapBaseIndoorMapInfo;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.UiSettings;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.route.BikingRouteResult;
import com.baidu.mapapi.search.route.DrivingRouteResult;
import com.baidu.mapapi.search.route.IndoorPlanNode;
import com.baidu.mapapi.search.route.IndoorRoutePlanOption;
import com.baidu.mapapi.search.route.IndoorRouteResult;
import com.baidu.mapapi.search.route.MassTransitRouteResult;
import com.baidu.mapapi.search.route.OnGetRoutePlanResultListener;
import com.baidu.mapapi.search.route.RoutePlanSearch;
import com.baidu.mapapi.search.route.TransitRouteResult;
import com.baidu.mapapi.search.route.WalkingRouteResult;
import com.baidu.mapapi.walknavi.WalkNavigateHelper;
import com.baidu.mapapi.walknavi.adapter.IWEngineInitListener;
import com.baidu.mapapi.walknavi.adapter.IWNaviCalcRouteListener;
import com.baidu.mapapi.walknavi.adapter.IWRoutePlanListener;
import com.baidu.mapapi.walknavi.model.WalkRoutePlanError;
import com.baidu.mapapi.walknavi.params.RouteNodeType;
import com.baidu.mapapi.walknavi.params.WalkNaviLaunchParam;
import com.baidu.mapapi.walknavi.params.WalkRouteNodeInfo;
import com.zxac.dingdong_flutter.listener.IndoorRoutePlanResultListener;
import com.zxac.dingdong_flutter.overlayutil.IndoorRouteOverlay;
import com.zxac.dingdong_flutter.utils.LocationUtil;
import com.zxac.dingdong_flutter.utils.StatusBarUtil;
import com.zxac.dingdong_flutter.utils.UIUtil;

public class MapActivity extends AppCompatActivity {

    private final static String TAG = MapActivity.class.getSimpleName();

    private MapView mMapView;
    private BaiduMap mBaiduMap;

    /*导航起终点Marker，可拖动改变起终点的坐标*/
    private Marker mStartMarker;
    private Marker mEndMarker;

    private String endFloor;
    private LatLng startPt;
    private LatLng endPt;
    private Boolean indoor = false;

    private WalkNaviLaunchParam walkParam;

    private BitmapDescriptor bdStart;
    private BitmapDescriptor bdEnd;

    private LocationClient locationClient; // 获取定位信息入口
    private BDLocation bdLocation; // 当前位置信息

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        StatusBarUtil.setStatusBarTranslucent(this, true);
        setContentView(R.layout.activity_map);

        // 路径规划
        RoutePlanSearch mSearch = RoutePlanSearch.newInstance();

        mMapView = findViewById(R.id.mapview);
        /*普通步行导航入口*/
        Button walkBtn = findViewById(R.id.btn_walknavi_normal);
        walkBtn.setOnClickListener(v -> {
            walkParam.extraNaviMode(0);
            startWalkNavi(indoor);
        });

        /*AR步行导航入口*/
        Button arWalkBtn = findViewById(R.id.btn_walknavi_ar);
        arWalkBtn.setOnClickListener(v -> {
            walkParam.extraNaviMode(1);
            startWalkNavi(indoor);
        });


        // 室内路径规划 listener
        OnGetRoutePlanResultListener listener = new IndoorRoutePlanResultListener() {
            @Override
            public void onGetIndoorRouteResult(IndoorRouteResult indoorRouteResult) {
                Log.d("====czx", "onGetIndoorRouteResult");
                //创建IndoorRouteOverlay实例
                IndoorRouteOverlay overlay = new IndoorRouteOverlay(mBaiduMap);
                Log.d("=====czx", "baiduMap is null: " + (mBaiduMap == null));
                if (indoorRouteResult.getRouteLines() != null && indoorRouteResult.getRouteLines().size() > 0) {
                    Log.d("=====czx", "获取室内路径成功");
                    //获取室内路径规划数据（以返回的第一条路线为例）
                    //为IndoorRouteOverlay实例设置数据
                    overlay.setData(indoorRouteResult.getRouteLines().get(0));
                    //在地图上绘制IndoorRouteOverlay
                    overlay.addToMap();
                    Log.d("====czx", "地图上显示室内路线规划");
                    walkBtn.setVisibility(View.INVISIBLE);
                    arWalkBtn.setVisibility(View.INVISIBLE);
                } else {
                    Log.d("=====czx", "不存在合适的室内路径");
                    Log.d("=====czx", "开始步行导航");
                    initOverlay();
                    startWalkNavi(indoor);
                }
                mSearch.destroy();
            }
        };
        mSearch.setOnGetRoutePlanResultListener(listener);

        BDAbstractLocationListener mListener = new BDAbstractLocationListener() {
            @Override
            public void onReceiveLocation(BDLocation location) {
            bdLocation = location;
            // 定位获取当前位置
            startPt = new LatLng(bdLocation.getLatitude(), bdLocation.getLongitude());
            Log.d("======czx", "定位数据：latitude: " + startPt.latitude + " ; longitude : " + startPt.longitude);

            Intent intent = getIntent();
            // 设置终点为传递过来的楼层经纬度
            endPt = new LatLng(Double.parseDouble(intent.getStringExtra("lat")), Double.parseDouble(intent.getStringExtra("lng")));
            endFloor = intent.getStringExtra("floor");

            /*构造导航起终点参数对象*/
            WalkRouteNodeInfo walkStartNode = new WalkRouteNodeInfo();
            walkStartNode.setLocation(startPt);
            WalkRouteNodeInfo walkEndNode = new WalkRouteNodeInfo();
            walkEndNode.setLocation(endPt);

            walkParam = new WalkNaviLaunchParam().startNodeInfo(walkStartNode).endNodeInfo(walkEndNode);

            initMapStatus(getApplicationContext());

            // 如果定位结果在室内
            if (bdLocation.getFloor() != null) {
                // 当前支持高精度室内定位
                String buildingID = bdLocation.getBuildingID();// 百度内部建筑物ID
                String buildingName = bdLocation.getBuildingName();// 百度内部建筑物缩写
                String startFloor = bdLocation.getFloor();// 室内定位的楼层信息，如 f1,f2,b1,b2
                Log.d("=====czx", "buildingID: " + buildingID + " ; buildingName: " + buildingName + " ; " + "startFloor: " + startFloor);
                locationClient.startIndoorMode();// 开启室内定位模式（重复调用也没问题），开启后，定位SDK会融合各种定位信息（GPS,WI-FI，蓝牙，传感器等）连续平滑的输出定位结果；
                indoor = true;
            }

            // 如果起点在室内，那尝试室内路径规划，存在则显示，不存在则进行步行导航
            if (indoor) {
                IndoorPlanNode startNode = new IndoorPlanNode(new LatLng(startPt.latitude, startPt.longitude), bdLocation.getFloor());
                IndoorPlanNode endNode = new IndoorPlanNode(new LatLng(endPt.latitude, endPt.longitude), endFloor);
                Log.d("======czx", "发起室内路径规划");
                mSearch.walkingIndoorSearch(new IndoorRoutePlanOption().from(startNode).to(endNode));
            } else {
                // 初始化Marker
                initOverlay();
                // 开始步行导航
                startWalkNavi(indoor);
            }

            locationClient.stop();
            }
        };

        locationClient = LocationUtil.init(getApplicationContext(), mListener, null);

        locationClient.start();

    }


    /**
     * 初始化地图状态
     */
    private void initMapStatus(Context context){
        Log.i("======czx", "11111设置室内监听");
        mBaiduMap = mMapView.getMap();
        mBaiduMap.setIndoorEnable(true);//打开室内图，默认为关闭状态
        //实例化UiSettings类对象
        UiSettings mUiSettings = mBaiduMap.getUiSettings();
        //通过设置enable为true或false 选择是否显示指南针
        mUiSettings.setCompassEnabled(true);

        MapStatus.Builder builder = new MapStatus.Builder();
        int zoomLevel = 15;
        if (indoor) {
            zoomLevel = 20;
        }
        builder.target(new LatLng(endPt.latitude, endPt.longitude)).zoom(zoomLevel);
        mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));

        // 设置监听事件来监听进入和移出室内图
        mBaiduMap.setOnBaseIndoorMapListener((on, mapBaseIndoorMapInfo) -> {
            if (on && mapBaseIndoorMapInfo != null) {
                // 进入室内图
                // 通过获取回调参数 mapBaseIndoorMapInfo 便可获取室内图信息，包含楼层信息，室内ID等
                Toast.makeText(context, "进入室内图", Toast.LENGTH_SHORT).show();
                Log.i("=======czx", "ID: " + mapBaseIndoorMapInfo.getID() +
                        "; getCurFloor: " + mapBaseIndoorMapInfo.getCurFloor() + "; floors: " + mapBaseIndoorMapInfo.getFloors());
                // 获取当前所在哪个楼层并展示，展示当前楼层
                if (indoor) {
                    // 切换楼层信息
                    // strID 通过 mMapBaseIndoorMapInfo.getID()方法获得
                    mBaiduMap.switchBaseIndoorMapFloor(bdLocation.getFloor(), mapBaseIndoorMapInfo.getID());
                }
            } else {
                // 移除室内图
                Toast.makeText(context, "移出室内图", Toast.LENGTH_SHORT).show();
            }
        });

    }


    /**
     * 初始化导航起终点Marker
     */
    public void initOverlay() {
        Log.d("=====czx", "start initOverlay");
        bdStart = BitmapDescriptorFactory.fromBitmap(
                UIUtil.zoomImg(BitmapFactory.decodeResource(getResources(), R.drawable.icon_start), 80, 105));

        bdEnd = BitmapDescriptorFactory.fromBitmap(
                UIUtil.zoomImg(BitmapFactory.decodeResource(getResources(), R.drawable.icon_end), 75, 100));

        MarkerOptions ooA = new MarkerOptions().position(startPt).icon(bdStart)
                .zIndex(9).draggable(true);

        mStartMarker = (Marker) (mBaiduMap.addOverlay(ooA));
        mStartMarker.setDraggable(true);
        MarkerOptions ooB = new MarkerOptions().position(endPt).icon(bdEnd)
                .zIndex(5);
        mEndMarker = (Marker) (mBaiduMap.addOverlay(ooB));
        mEndMarker.setDraggable(true);

        // 设置marker拖拽移动时的监听
        mBaiduMap.setOnMarkerDragListener(new BaiduMap.OnMarkerDragListener() {
            public void onMarkerDrag(Marker marker) {
            }

            public void onMarkerDragEnd(Marker marker) {
                if(marker == mStartMarker){
                    startPt = marker.getPosition();
                }else if(marker == mEndMarker){
                    endPt = marker.getPosition();
                }

                WalkRouteNodeInfo walkStartNode = new WalkRouteNodeInfo();
                walkStartNode.setLocation(startPt);
                WalkRouteNodeInfo walkEndNode = new WalkRouteNodeInfo();
                walkEndNode.setLocation(endPt);
                walkParam = new WalkNaviLaunchParam().startNodeInfo(walkStartNode).endNodeInfo(walkEndNode);
            }

            public void onMarkerDragStart(Marker marker) {
            }
        });
    }

    /**
     * 开始步行导航
     */
    private void startWalkNavi(Boolean indoor) {
        Log.i(TAG, "startWalkNavi");
        try {
            WalkNavigateHelper.getInstance().initNaviEngine(this, new IWEngineInitListener() {
                @Override
                public void engineInitSuccess() {
                    Log.i(TAG, "WalkNavi engineInitSuccess");
                    routePlanWithWalkParam(indoor);
                }

                @Override
                public void engineInitFail() {
                    Log.i(TAG, "WalkNavi engineInitFail");
                    WalkNavigateHelper.getInstance().unInitNaviEngine();
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "startWalkNavi Exception");
            e.printStackTrace();
        }
    }

    /**
     * 发起步行导航算路
     */
    private void routePlanWithWalkParam(Boolean indoor) {
        WalkNavigateHelper.getInstance().routePlanWithRouteNode(walkParam, new IWRoutePlanListener() {
            @Override
            public void onRoutePlanStart() {
                Log.i(TAG, "WalkNavi onRoutePlanStart");
            }

            @Override
            public void onRoutePlanSuccess() {
                Log.i(TAG, "onRoutePlanSuccess");
                    Intent intent = new Intent();
                    intent.setClass(MapActivity.this, WalkGuideActivity.class);
                    startActivity(intent);
            }

            @Override
            public void onRoutePlanFail(WalkRoutePlanError error) {
                Log.i(TAG, "WalkNavi onRoutePlanFail, error: " + error.name());
                Toast.makeText(getApplicationContext(), error.name(), Toast.LENGTH_SHORT).show();
            }

        });
    }



    protected void onPause() {
        super.onPause();
        mMapView.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        mMapView.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mMapView.onDestroy();
        bdStart.recycle();
        bdEnd.recycle();
    }

}
