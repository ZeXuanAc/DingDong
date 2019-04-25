package com.zxac.dingdong_flutter;

import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.ImageButton;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.UiSettings;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.route.IndoorPlanNode;
import com.baidu.mapapi.search.route.IndoorRoutePlanOption;
import com.baidu.mapapi.search.route.IndoorRouteResult;
import com.baidu.mapapi.search.route.OnGetRoutePlanResultListener;
import com.baidu.mapapi.search.route.RoutePlanSearch;
import com.baidu.mapapi.walknavi.WalkNavigateHelper;
import com.baidu.mapapi.walknavi.adapter.IWEngineInitListener;
import com.baidu.mapapi.walknavi.adapter.IWRoutePlanListener;
import com.baidu.mapapi.walknavi.model.WalkRoutePlanError;
import com.baidu.mapapi.walknavi.params.WalkNaviLaunchParam;
import com.baidu.mapapi.walknavi.params.WalkRouteNodeInfo;
import com.hanks.htextview.line.LineTextView;
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

    private LocationClient locationClient; // 获取定位信息入口(只定位一次)
    private LocationClient indoorLocationClient; // 室内导航定位(每秒一次)
    private RoutePlanSearch mSearch; // 室内路线规划寻找
    private BDLocation bdLocation; // 当前位置信息

    private int searchCount = 1; // 记录第几次室内路径规划

    private ImageButton walkBtn; // 步行导航按钮
    private ImageButton arWalkBtn; // ar步行导航按钮
    private ImageButton returnStartBtn; // 回到起点按钮
    private ImageButton returnEndBtn; // 回到终点按钮
    private LineTextView floorText; // floor文本

//    double lat = 30.305088; // todo
//    double lng = 120.113296; // todo

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        StatusBarUtil.setStatusBarTranslucent(this, true);
        setContentView(R.layout.activity_map);

        // 路径规划
        mSearch = RoutePlanSearch.newInstance();

        mMapView = findViewById(R.id.mapview);

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
                    //清除地图上的所有覆盖物
                    mBaiduMap.clear();
                    //在地图上绘制IndoorRouteOverlay
                    overlay.addToMap();
                    Log.d("====czx", "地图上显示室内路线规划");
                    walkBtn.setVisibility(View.INVISIBLE);
                    arWalkBtn.setVisibility(View.INVISIBLE);
                    returnStartBtn.setVisibility(View.INVISIBLE);
                    returnEndBtn.setVisibility(View.INVISIBLE);
                    if (searchCount == 1) {
                        startIndoorNavi();
                    }
                    searchCount ++;
                } else {
                    if (searchCount != 1) {
                        return;
                    }
                    Log.d("=====czx", "不存在合适的室内路径");
                    Log.d("=====czx", "开始步行导航");
                    walkBtn.setVisibility(View.VISIBLE);
                    arWalkBtn.setVisibility(View.VISIBLE);
                    returnStartBtn.setVisibility(View.VISIBLE);
                    returnEndBtn.setVisibility(View.VISIBLE);
                    if (indoorLocationClient != null && indoorLocationClient.isStarted()) {
                        indoorLocationClient.stop();
                    }
                    initOverlay();
                    startWalkNavi(indoor);
                }
            }
        };
        mSearch.setOnGetRoutePlanResultListener(listener);

        BDAbstractLocationListener mListener = new BDAbstractLocationListener() {
            @Override
            public void onReceiveLocation(BDLocation location) {
            bdLocation = location;
            // 定位获取当前位置
//            bdLocation.setLatitude(lat); // todo
//            bdLocation.setLongitude(lng); // todo
            startPt = new LatLng(bdLocation.getLatitude(), bdLocation.getLongitude());
            Log.d("======czx", "定位数据：latitude: " + startPt.latitude + " ; longitude : " + startPt.longitude);

            Intent intent = getIntent();
            // 设置终点为传递过来的楼层经纬度
            endPt = new LatLng(Double.parseDouble(intent.getStringExtra("lat")), Double.parseDouble(intent.getStringExtra("lng")));
            endFloor = intent.getStringExtra("floor");

            initView();

            /*构造导航起终点参数对象*/
            WalkRouteNodeInfo walkStartNode = new WalkRouteNodeInfo();
            walkStartNode.setLocation(startPt);
            WalkRouteNodeInfo walkEndNode = new WalkRouteNodeInfo();
            walkEndNode.setLocation(endPt);

            walkParam = new WalkNaviLaunchParam().startNodeInfo(walkStartNode).endNodeInfo(walkEndNode);

            initMapStatus(getApplicationContext());

//            bdLocation.setFloor("F4"); // todo
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
     * 初始化控件
     */
    private void initView () {
        /*普通步行导航入口*/
        walkBtn = findViewById(R.id.btn_walknavi_normal);
        walkBtn.setOnClickListener(v -> {
            walkParam.extraNaviMode(0);
            startWalkNavi(indoor);
        });

        /*AR步行导航入口*/
        arWalkBtn = findViewById(R.id.btn_walknavi_ar);
        arWalkBtn.setOnClickListener(v -> {
            walkParam.extraNaviMode(1);
            startWalkNavi(indoor);
        });

        /*回到起点*/
        returnStartBtn = findViewById(R.id.btn_return_start);
        returnStartBtn.setOnClickListener(v -> {
            MapStatus.Builder builder = new MapStatus.Builder();
            int zoomLevel = LocationUtil.getZoom(startPt, endPt);
            builder.target(new LatLng(startPt.latitude, startPt.longitude)).zoom(zoomLevel);
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
        });

        /*回到终点*/
        returnEndBtn = findViewById(R.id.btn_return_end);
        returnEndBtn.setOnClickListener(v -> {
            MapStatus.Builder builder = new MapStatus.Builder();
            int zoomLevel = LocationUtil.getZoom(startPt, endPt);
            builder.target(new LatLng(endPt.latitude, endPt.longitude)).zoom(zoomLevel);
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
        });

        floorText = findViewById(R.id.floor_text);
        floorText.setTextColor(getResources().getColor(R.color.fbutton_default_color));
        floorText.setAnimationDuration(1500);
        floorText.animateText(getString(R.string.floor_tips) + endFloor);

    }


    /**
     * 初始化地图状态
     */
    private void initMapStatus(Context context){
        Log.i("======czx", "设置进出入室内监听");
        mBaiduMap = mMapView.getMap();
        mBaiduMap.setIndoorEnable(true);// 打开室内图，默认为关闭状态
        //实例化UiSettings类对象
        UiSettings mUiSettings = mBaiduMap.getUiSettings();
        mUiSettings.setRotateGesturesEnabled(false);
        //通过设置enable为true或false 选择是否显示指南针
        mUiSettings.setCompassEnabled(true);

        MapStatus.Builder builder = new MapStatus.Builder();
        int zoomLevel = LocationUtil.getZoom(startPt, endPt);
        Log.d("======czx", "设置缩放级别为：" + zoomLevel);
        builder.target(new LatLng(startPt.latitude, startPt.longitude)).zoom(zoomLevel);
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
                if (indoorLocationClient != null && indoorLocationClient.isStarted()) {
                    indoorLocationClient.stop();
                }
            }
        });
    }

    /**
     * 开始室内导航
     */
    private void startIndoorNavi(){
        mBaiduMap.setMyLocationEnabled(true); // 开启地图的定位图层
        BDAbstractLocationListener indoorListener = new BDAbstractLocationListener() {
            @Override
            public void onReceiveLocation(BDLocation location) {
                //mapView 销毁后不在处理新接收的位置
                if (location == null || mMapView == null){
                    return;
                }
                Log.d("====czx", "startIndoorNavi 当前位置信息： latitude: " + location.getLatitude() + "; longitude: " + location.getLongitude());

//                lat += 0.00002; // todo
//                lng += 0.00002; // todo
//                location.setLatitude(lat); // todo
//                location.setLongitude(lng); // todo
                Log.d("======czx", "重新获得定位：latitude: " + location.getLatitude() + "; longitude: " + location.getLongitude());

                // 获取定位并展示在地图中
                MyLocationData locData = new MyLocationData.Builder().accuracy(location.getRadius())
                        // 此处设置开发者获取到的方向信息，顺时针0-360
                        .direction(location.getDirection()).latitude(location.getLatitude())
                        .longitude(location.getLongitude()).build();
                mBaiduMap.setMyLocationData(locData);
//                location.setFloor("F4"); // todo
                // 如果定位还在室内，则再次进行室内路径规划导航
                if (location.getFloor() != null) {
                    IndoorPlanNode startNode = new IndoorPlanNode(new LatLng(location.getLatitude(), location.getLongitude()), location.getFloor());
                    IndoorPlanNode endNode = new IndoorPlanNode(new LatLng(endPt.latitude, endPt.longitude), endFloor);
                    mSearch.walkingIndoorSearch(new IndoorRoutePlanOption().from(startNode).to(endNode));
                }
            }
        };
        // 定位模式、是否开启方向、设置自定义定位图标、精度圈填充颜色、精度圈边框颜色
        MyLocationConfiguration configuration = new MyLocationConfiguration(MyLocationConfiguration.LocationMode.FOLLOWING, true,
                BitmapDescriptorFactory.fromBitmap(UIUtil.zoomImg(BitmapFactory.decodeResource(getResources(), R.drawable.icon_geo), 50, 50))
                , 0x22FFFF88, 0xAAAFEEEE);
        mBaiduMap.setMyLocationConfiguration(configuration);
        //通过LocationClientOption设置LocationClient相关参数
        LocationClientOption option = new LocationClientOption();
        option.setOpenGps(true); // 打开gps
        option.setCoorType("bd09ll"); // 设置坐标类型
        option.setScanSpan(1000);
        indoorLocationClient = LocationUtil.init(getApplicationContext(), indoorListener, option);
        indoorLocationClient.startIndoorMode();
        indoorLocationClient.start();
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
        Log.d("====czx", "onPause");
    }

    @Override
    protected void onResume() {
        super.onResume();
        mMapView.onResume();
        if (floorText != null) {
            floorText.animateText(getString(R.string.floor_tips) + " 【 " + endFloor + " 】");
        }
        Log.d("====czx", "onResume");
    }

    @Override
    protected void onDestroy() {
        Log.d("====czx", "onDestroy");
        mMapView.onDestroy();
        mMapView = null;
        if (mBaiduMap != null) {
            mBaiduMap.setMyLocationEnabled(false);
        }
        if (bdStart != null) {
            bdStart.recycle();
        }
        if (bdEnd != null) {
            bdEnd.recycle();
        }
        if (locationClient != null) {
            locationClient.stop();
        }
        if (indoorLocationClient != null) {
            indoorLocationClient.stop();
        }
        if (mSearch != null) {
            mSearch.destroy();
        }
        super.onDestroy();
    }

}
