import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingdong_flutter/config/common.dart';
import 'package:fluttie/fluttie.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dingdong_flutter/utils/log_util.dart';
import 'package:dingdong_flutter/config/application.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';
import 'package:dingdong_flutter/service/baidu_map_service.dart';
import 'package:dingdong_flutter/utils/toast_util.dart';
import 'package:dingdong_flutter/utils/common_util.dart';


class HomePage extends StatefulWidget {

    _HomePageState createState() {
      return _HomePageState();
    }
}
class _HomePageState extends State<HomePage> with WidgetsBindingObserver{

    Map eqMap;  // building所有的设备信息
    Map cityBuildingMap; // 当前 building
    List<Map> allBuildingList; // 当前城市下的所有 building
    List<Map> allCityList; // 所有city 列表
    var startUpTime; // 记录app启动的时间
    var loadingAnimation; // 加载中的动画
    var animationTime; // 记录当前动画开始时间
    AMapLocation location; // 当前定位信息
    var homeCitycode; // 城市代码
    bool noCitycode = false; // 是否存在此citycode标志
    DateTime nowTime;
    Timer httpTimer;
    Timer nowTimeTimer;


    @override
    void initState() {
        _initAnimation();
        _getLocalBuilding();
        startUpTime = animationTime = DateTime.now();
        super.initState();
        WidgetsBinding.instance.addObserver(this);
    }


    @override
    Widget build(BuildContext context) {
        ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//        CommonUtil.setBarStatus(true);

        if (eqMap == null || eqMap['data'] == null) {
            _toastMsg("网络开了小差, 请检查网络", home_page_timeout);
            if (loadingAnimation != null && nowTime != null && nowTime.difference(animationTime).inSeconds >= 2) {
                animationTime = nowTime;
                loadingAnimation.start();
            }
            _startTimer();
            return Scaffold(
                appBar: _buildAppBar("无"),
                body: Center(
                    child: new FluttieAnimation(loadingAnimation),
                ),
            );
        } else {
            return Container (
                child: Scaffold(
                    appBar: _buildAppBar(cityBuildingMap['name']),
                    body: _listView(eqMap['data'], nowTime),
                )
            );
        }
    }


    Widget _buildAppBar (titleText) {
        return AppBar(
            leading: new Icon(Icons.home, color: Colors.blue,),
            title: new Text.rich(new TextSpan(
                text: titleText,
                style: TextStyle(color: Colors.black,),
                recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                        _showBuildingAlertDialog(context);
                    }
            )),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: <Widget>[
                new IconButton( // action button
                    icon: new Icon(Icons.location_on, color: Colors.blue,),
                    onPressed: () {
                        Future future = Application.router.navigateTo(context, "/buildingOptions?buildingId=00933123");
                        future.then((value) {
                            if (value != null) {
                                _loadingPresentCity(value['citycode']);
                            }
                        });
                    },
                ),
            ],
        );
    }

    void toMapView(lat, lng, floor) async {
      await BaiduMapService.mapView(lat, lng, floor);
    }

    // 得到离定位最近的 building, 先定位再检查本地是否存在是为了在外地时能检测到而提示切换城市
    void _getLocalBuilding () {
        print("1------开始获取最近的building");
        _checkPermission().then((val) {
            if (val != null) {
                location = val;
                print("2-----定位获取成功, citycode: " + location.citycode.toString() + ", 纬度：" + location.latitude.toString() + ", 经度：" + location.longitude.toString());
                checkCitycode(location.citycode).then((result) {
//                    if (result['data'] == 0) { // todo 测试
                    if (result['data'] == 1) {
                        print("3-----数据库【存在】此citycode");
                        // 检查本地是否存在此citycode
                        StorageUtil.get(storageCitycode).then((localCitycode) {
                            if (localCitycode == null || localCitycode == "") {
                                print("4------检测到本地【不存在】citycode");
                                StorageUtil.save(storageCitycode, location.citycode);
                                print("4.1-----本地citycode存储成功");
                                if (mounted) {
                                    setState(() {
                                        homeCitycode = location.citycode;
                                    });
                                }
                            } else {
                                print("4------检测到本地【存在】citycode, localCitycode: " + localCitycode);
                                if (location.citycode != localCitycode) {
                                    print("4.1------检测到本地citycode和定位得到的citycode【不符】, 开始选择是否更改为当前定位citycode");
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                            return new AlertDialog(
                                                title: Text('Notice'),
                                                content: Text("检测到你在【" + location.city + "】, 是否切换？"),
                                                actions: <Widget>[
                                                    FlatButton(
                                                        child: Text("确认"),
                                                        onPressed: () {
                                                            StorageUtil.save(storageCitycode, location.citycode);
                                                            setState(() {
                                                                homeCitycode = location.citycode;
                                                                startUpTime = DateTime.now();
                                                            });
                                                            StorageUtil.remove(storageBuilding);
                                                            print("5------获取citycode成功(确认), citycode为：" + homeCitycode);
                                                            _getBuildingByCitycode(homeCitycode);
                                                            Navigator.of(context).pop();
                                                        },
                                                    ),
                                                    FlatButton(
                                                        child: Text("取消"),
                                                        onPressed: () {
                                                            setState(() {
                                                                homeCitycode = localCitycode;
                                                                startUpTime = DateTime.now();
                                                            });
                                                            print("5------获取citycode成功（取消）, citycode为：" + homeCitycode);
                                                            _getBuildingByCitycode(homeCitycode);
                                                            Navigator.of(context).pop();
                                                        },
                                                    ),
                                                ],
                                            );
                                        });
                                } else {
                                    print("4.1------检测到本地citycode和定位得到的citycode【相同】");
                                    homeCitycode = localCitycode;
                                }
                            }
                            print("5------获取citycode成功, citycode为：" + homeCitycode);
                            _getBuildingByCitycode(homeCitycode);
                        });
                    } else {
                        print("3-----数据库【不存在】此citycode, 检查本地是否存储");
                        StorageUtil.get(storageCitycode).then((localCitycode) {
                            if (localCitycode != null && localCitycode != '') {
                                _getBuildingByCitycode(localCitycode);
                            } else {
                                ToastUtil.toastNoCitycode();
                                _getBuildingByCitycode("-1");
                            }
                        });

                    }
                }).timeout(new Duration(milliseconds: 3000), onTimeout: (){
                    ToastUtil.toastInternetTimeout();
                }).catchError((e){
                    print("=====czx : " + e.toString());
                    ToastUtil.toastInternetError();
                });
            }
        }).catchError((e) {
            ToastUtil.toastLocationPermission();
            LogUtil.e("homt_page._getLocalBuilding 获取最近的 building 失败: ", "${e.error}");     // Finally, callback fires.
        });
    }

    void _getBuildingByCitycode (citycode) {
        print("6------开始获取buildingMap, citycode为： " + citycode);
        print("7------开始尝试获取本地buildingMap");
        StorageUtil.get(storageBuilding).then((val) {
            var getBuildingUrlFlag = true;
            if (val != null && val != "") {
               print("8------获取本地buildingMap成功，buildingMap: " + val);
               var localBuildingMap = json.decode(val);
               if (localBuildingMap['citycode'] == citycode) {
                   cityBuildingMap = localBuildingMap;
                   getBuildingUrlFlag = false;
                   _startTimer();
                   print("8.1------开启定时器");
               }
            }
            if (citycode != "-1" && getBuildingUrlFlag) {
                print("8------本地buildingMap不存在或不为该city下，开始获取该city下的最近building");
                String latlng = location.latitude.toString() + "," + location.longitude.toString();
                getBuildingUrl(citycode, latlng).then((val){
                    if (val != null && val['data'] != "" && mounted) {
                        print("8.1------获取最近的building成功, 为: " + val['data'][0].toString());
                        setState(() {
                            cityBuildingMap = val['data'][0];
                            // todo 本地存储buildingId
                            StorageUtil.save(storageBuilding, json.encode(cityBuildingMap));
                            print("9------本地存储buildingMap, mapString: " + json.encode(cityBuildingMap));
                            _startTimer();
                            print("10------开启定时器");
                        });
                    } else {
                        ToastUtil.toastNoBuilding();
                    }
                }).catchError((e) {
                    LogUtil.e("homt_page._getAllBuilding: ", "${e.toString()}");     // Finally, callback fires.
                });
            }
            if (citycode == "-1") {
                _showCityAlertDialog(context);
            }
        });
    }

    void _startTimer () {
        print("开启定时器");
        const oneSec = const Duration(milliseconds: timer_duration);
        startUpTime = DateTime.now();
        if (cityBuildingMap != null && cityBuildingMap.isNotEmpty) {
          if (httpTimer == null) {
            httpTimer = new Timer.periodic(oneSec, (Timer t) =>
                getHomePageContentUrl(cityBuildingMap['citycode'], cityBuildingMap['id']).then((val){
                  if (val != null && mounted) {
                    setState(() {
                      eqMap = val;
                    });
                  }
                }).timeout(new Duration(milliseconds: home_page_content_url), onTimeout: (){
                  _toastMsg("请求主页数据超时, 请检查网络", home_page_timeout);
                })
            );
          }
          if (nowTimeTimer == null) {
            nowTimeTimer = new Timer.periodic(oneSec, (Timer t) =>
                setNowTimeState()
            );
          }
        }
    }

    void setNowTimeState () {
        if (mounted) {
            setState((){
                nowTime = DateTime.now();
            });
        }
    }

    // 选择building
    void _showBuildingAlertDialog(BuildContext context) {
        if (allBuildingList != null && homeCitycode != null && allBuildingList[0]['citycode'] == homeCitycode) {
            _loadingBuildingDialog(allBuildingList);
        } else {
            if (homeCitycode != null) {
                getBuildingUrl(homeCitycode, null).then((val){
                    if (val != null && mounted) {
                        allBuildingList = [];
                        setState(() {
                            for (Map map in val['data']){
                                allBuildingList.add(map);
                            }
                        });
                        _loadingBuildingDialog(allBuildingList);
                    }
                }).catchError((e) {
                    LogUtil.e("homt_page._getAllBuilding: ", "${e.error}");     // Finally, callback fires.
                });
            } else {
                ToastUtil.toastMsg("请先选择所在城市");
            }
        }
    }

    void _loadingBuildingDialog (buildingList) {
        List<Widget> dialogWidget = [];
        for (Map map in allBuildingList) {
            dialogWidget.add(new SimpleDialogOption(
                child:  Text(
                    map['name'],
                    style: TextStyle(
                        height: 1.3,
                        color: Colors.blue,
                        shadows: [Shadow(color: Color(0x9900FFFF), offset: Offset(0.5, 0.5), blurRadius: 5)], // 阴影
                    ),
                ),
                onPressed: () {
                    if (cityBuildingMap == null || (cityBuildingMap != null && cityBuildingMap['name'] != map['name'])) {
                        cityBuildingMap = map;
                        StorageUtil.save(storageBuilding, json.encode(cityBuildingMap));
                    }
                    Navigator.pop(context); //关闭对话框
                },
            ),);
        }
        showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
                return  SimpleDialog(
                    title:  Text('选择'),
                    children: dialogWidget,
                );
            },
        );
    }


    // 选择city
    void _showCityAlertDialog(BuildContext context) {
        if (allCityList != null) {
            _loadingCityDialog(allCityList);
        } else {
            getCityUrl().then((val){
                if (val != null && mounted) {
                    allCityList = [];
                    setState(() {
                        for (Map map in val['data']){
                            allCityList.add(map);
                        }
                    });
                    _loadingCityDialog(allCityList);
                }
            });
        }
    }

    // 重新加载城市
    void _loadingPresentCity (citycode) {
        if (homeCitycode == null || (homeCitycode != null && homeCitycode != citycode)) {
            setState(() {
                homeCitycode = citycode;
                eqMap = null;
                startUpTime = DateTime.now();
                StorageUtil.save(storageCitycode, homeCitycode);
                _getBuildingByCitycode(homeCitycode);
            });
        }
    }

    void _loadingCityDialog (cityList) {
        List<Widget> dialogWidget = [];
        for (Map map in cityList) {
            dialogWidget.add(new SimpleDialogOption(
                child:  Text(
                    map['name'],
                    style: TextStyle(
                        height: 1.3,
                        color: Colors.blue,
                        shadows: [Shadow(color: Color(0x9900FFFF), offset: Offset(0.5, 0.5), blurRadius: 5)], // 阴影
                    ),
                ),
                onPressed: () {
                    setState(() {
                      homeCitycode = map['citycode'];
                      eqMap = null;
                      startUpTime = DateTime.now();
                    });
                    Navigator.pop(context); // 关闭对话框
                    StorageUtil.save(storageCitycode, homeCitycode);
                    _getBuildingByCitycode(homeCitycode);
                },
            ),);
        }
        showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
                return  SimpleDialog(
                    title:  Text('选择城市'),
                    children: dialogWidget,
                );
            },
        );
    }

    void _initAnimation () async {
        // 先加载组件
        var instance = new Fluttie();
        var eComposition = await instance.loadAnimationFromAsset(
            'assets/animatd/loading-flutter.json',
        );
        loadingAnimation = await instance.prepareAnimation(eComposition);
        if (mounted) {
            setState(() {
                loadingAnimation.start(); //start our looped emoji animation
            });
        }
    }

    // 检查定位和文件读取权限并获取定位
    Future<AMapLocation> _checkPermission() async{
        try {
            PermissionStatus locationPermissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
            PermissionStatus storagePermissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
            if(locationPermissionStatus == PermissionStatus.denied || storagePermissionStatus == PermissionStatus.denied){
                Map<PermissionGroup, PermissionStatus> requestPermissionResult = await PermissionHandler().requestPermissions([PermissionGroup.location, PermissionGroup.storage]);
                if(requestPermissionResult[PermissionGroup.location] == PermissionStatus.denied ||
                    requestPermissionResult[PermissionGroup.storage] == PermissionStatus.denied){
                    ToastUtil.toastMsg("申请定位权限或者读取文件失败");
                    return null;
                }
            }
            await AMapLocationClient.startup(new AMapLocationOption(desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters ));
            return await AMapLocationClient.getLocation(true);
        } catch(e) {
            LogUtil.e("home_page", "定位失败" + e.error);
            return null;
        }
    }


    void _toastMsg (msg, period) {
        if (nowTime != null && nowTime.difference(startUpTime).inSeconds >= period) {
            startUpTime = nowTime;
            ToastUtil.toastMsg(msg);
        }
    }


    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        switch (state) {
            case AppLifecycleState.inactive:
                print('AppLifecycleState.inactive');
                break;
            case AppLifecycleState.paused:
                print('AppLifecycleState.paused');
                /// 释放两个定时器，因为在切换到其他页面时会导致此页面停止，但是本身两个定时器却不会停止，
                /// 这两个定时器会做 setState方法, 这可能会导致内存泄漏，重写这个方法的目的就是让此 widget
                /// 停止的时候保证没有调用setState方法的操作。
                _stopTimer();
                break;
            case AppLifecycleState.resumed:
                print('AppLifecycleState.resumed');
                _startTimer();
                break;
            case AppLifecycleState.suspending:
                print('AppLifecycleState.suspending');
                break;
        }
        super.didChangeAppLifecycleState(state);
    }



    @override
    void deactivate() {
        print("deactivate");
        super.deactivate();
    }

    @override
    void dispose() {
        print("dispose");
        AMapLocationClient.shutdown();
        _stopTimer();
        super.dispose();
    }

    void _stopTimer() {
        if (httpTimer != null) {
            httpTimer.cancel();
        }
        if (nowTimeTimer != null) {
            nowTimeTimer.cancel();
        }
    }

}

Widget _listView(sEqMap, nowTime) {
    List<Widget> wList = [];
    List<List> storeyEquipmentList = [];
    sEqMap.forEach((k, v) => storeyEquipmentList.add(v));
    for (List eqList in storeyEquipmentList) {
        List<Widget> imageWidgetList = [];
        for (Map eqMap in eqList) {
            imageWidgetList.add(_singleGridWidget(eqMap, nowTime));
        }
        Card card = new Card(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),  //设置圆角
            child: new Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("http://img7.3png.com/c4314640cf6f234a98ca48d6c9532e4f344a.jpeg/p"),
                        fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                child: new Column(
                    children: <Widget>[
                        Stack(
                            alignment: const FractionalOffset(0.5, 0.5),
                            children: <Widget>[
                                new Container(
                                    height: ScreenUtil.getInstance().setWidth(140),
                                    decoration: BoxDecoration(
                                        color: Color(0x99FF6347),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                    ),
                                    child: Center(
                                        child: Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                        ),
                                    ),
                                ),
                                Center(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                            Container(
                                                width: ScreenUtil.getInstance().setWidth(150),
                                                child: Center(
                                                    child: Text(
                                                        eqList.elementAt(0)['floor'],
                                                        style: TextStyle(
                                                            fontSize: ScreenUtil.getInstance().setSp(storey_font_size),
                                                            color: Colors.cyanAccent,
                                                            shadows: [Shadow(color: Colors.cyanAccent, offset: Offset(0.2, 0.2), blurRadius: 5)], // 阴影
                                                        )
                                                    ),
                                                )
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 30, right: 30), //容器外补白
                                                width: ScreenUtil.getInstance().setWidth(500),
                                                child: Center(
                                                    child: Text(
                                                        eqList.elementAt(0)['storeyName'],
                                                        style: TextStyle(
                                                            fontSize: ScreenUtil.getInstance().setSp(storey_font_size),
                                                            color: Colors.white,
                                                            shadows: [Shadow(color: Colors.white, offset: Offset(0.2, 0.2), blurRadius: 5)], // 阴影
                                                        )
                                                    ),
                                                )
                                            ),
                                            Container(
                                                width: ScreenUtil.getInstance().setWidth(150),
                                                child: new IconButton( // action button
                                                    icon: ImageIcon(AssetImage('assets/images/icons_foot.png'), color: Colors.cyanAccent,),
                                                    onPressed: () {
                                                        _HomePageState().toMapView(eqList.elementAt(0)['latitude'], eqList.elementAt(0)['longitude'],
                                                            eqList.elementAt(0)['floor']);
                                                    },
                                                ),
                                            ),

                                        ],
                                    ),
                                )
                            ]
                        ),
                        GridView.count(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            childAspectRatio: 1.0,
                            children: imageWidgetList,
                        ),
                    ]
                )
            ),
        );
        Container container = new Container(
            margin: new EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: card,
        );
        wList.add(container);
    }
    return Container(
        child: ListView(
                children: wList,
            )
    );
}


Widget _singleGridWidget(eqMap, nowTime){
    var difference = nowTime.difference(DateTime.parse(eqMap['createTimeStr']));
    var apartHour = difference.inHours.toString();
    var apartMinute = (difference.inMinutes - difference.inHours * 60) < 10 ? "0" + (difference.inMinutes - difference.inHours * 60).toString() : (difference.inMinutes - difference.inHours * 60).toString();
    var apartSecond = (difference.inSeconds - difference.inMinutes * 60) < 10 ? "0" + (difference.inSeconds - difference.inMinutes * 60).toString() : (difference.inSeconds - difference.inMinutes * 60).toString();
    var apartTime;
    if (apartHour.contains("-") || apartMinute.contains("-") || apartMinute.contains("-")) {
        apartTime = "错误";
    } else {
        apartTime = apartHour + ":" + apartMinute + ":" + apartSecond;
    }
    return Container(
        child: _stackImage(eqMap, apartTime)
    );
}

Widget _stackImage(eqMap, apartTime){
    var imageWidget;
    if (eqMap['status'] == "0") {
        imageWidget = Column(
            children: <Widget>[
                Container(
                    width: ScreenUtil.getInstance().setWidth(180), height: ScreenUtil.getInstance().setWidth(180),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(image: AssetImage("assets/images/green.jpg")),
                        // 生成阴影， 阴影位置由offset决定,阴影模糊层度由blurRadius大小决定（大就更透明更扩散），阴影模糊大小由spreadRadius决定
                        boxShadow: [BoxShadow(color: Color(0x9900FFFF), offset: Offset(2.0, 2.0), blurRadius: 10.0, spreadRadius: 2.0),],
                    ),
                ),
                Text("空闲")
            ]
        );
    } else if (eqMap['status'] == "1") {
        imageWidget = Column(
            children: <Widget>[
                Stack(
                    alignment: const FractionalOffset(0.5, 0.8), // 方法一
                    children: <Widget>[
                        Container(
                            width: ScreenUtil.getInstance().setWidth(180), height: ScreenUtil.getInstance().setWidth(180),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(image: AssetImage("assets/images/red.jpg")),
                                // 生成俩层阴影，一层黄， 阴影位置由offset决定,阴影模糊层度由blurRadius大小决定（大就更透明更扩散），阴影模糊大小由spreadRadius决定
                                boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(2.0, 2.0), blurRadius: 10.0, spreadRadius: 2.0),],
                            ),
                        ),
                        new Container(
                            height: ScreenUtil.getInstance().setWidth(40),
                            width: ScreenUtil.getInstance().setWidth(180),
                            decoration: BoxDecoration(
                                color: Color(0x99FF8C00)
                            ),
                            child: Center(
                                child: Text(
                                    apartTime,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway-Light',
                                    ),
                                ),
                            ),
                        ),
                    ]
                ),
                Text("占用"),
            ]
        );
    }
    return Column(
        children: <Widget>[
            Text(
                eqMap['eqName'],
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(eq_name_font_size),
                ),
            ),
            imageWidget,
        ]
    );
}

