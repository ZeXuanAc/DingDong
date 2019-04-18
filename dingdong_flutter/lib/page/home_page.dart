import 'package:flutter/material.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingdong_flutter/config/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttie/fluttie.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dingdong_flutter/utils/log_util.dart';
import 'package:dingdong_flutter/config/application.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';

class HomePage extends StatefulWidget {

    _HomePageState createState() {
      return _HomePageState();
    }
}
class _HomePageState extends State<HomePage> {

    Map eqMap;  // building所有的设备信息
    Map cityBuildingMap; // 当前 building
    List<Map> allBuildingList; // 当前城市下的所有 building
    var startUpTime; // 记录app启动的时间
    var loadingAnimation; // 加载中的动画
    var animationTime; // 记录当前动画开始时间
    AMapLocation location; // 当前定位信息
    var homeCitycode; // 城市代码
    DateTime nowTime;
    Timer httpTimer;
    Timer nowTimeTimer;


    @override
    void initState() {
        _initAnimation();
        _getLocalBuilding();
//        cityBuildingMap = {"citycode": "0571", "id" : "2", "name": "浙江科技学院东图书馆"};
        _getAllBuilding();
        startUpTime = animationTime = DateTime.now();
        super.initState();
    }


    @override
    Widget build(BuildContext context) {
        ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

        // 在初始化完成再通过初始化的数据完成页面的生成
        const oneSec = const Duration(milliseconds: 500);
        if (cityBuildingMap != null && cityBuildingMap.isNotEmpty) {
            httpTimer = new Timer.periodic(oneSec, (Timer t) =>
                getHomePageContentUrl(cityBuildingMap['citycode'], cityBuildingMap['id']).then((val){
                    if (val != null && mounted) {
                        setState(() {
                            eqMap = val;
                        });
                    }
                })
            );
            nowTimeTimer = new Timer.periodic(oneSec, (Timer t) =>
                setState((){
                    nowTime = DateTime.now();
                })
            );
        }

        if (eqMap == null || eqMap['data'] == null) {
            if (nowTime != null && nowTime.difference(startUpTime).inSeconds >= home_page_timeout) {
                startUpTime = nowTime;
                Fluttertoast.showToast(
                    msg: "网络超时, 请检查网络",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
            }
            if (loadingAnimation != null && nowTime != null && nowTime.difference(animationTime).inSeconds >= 2) {
                animationTime = nowTime;
                loadingAnimation.start();
            }
            return Center(
                child: new FluttieAnimation(loadingAnimation),
            );
        } else {
            return Container (
                child: Scaffold(
                    appBar: AppBar(
                        leading: new Icon(Icons.home, color: Colors.blue,),
                        title: Text(cityBuildingMap['name'], style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis,),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        actions: <Widget>[
                            new IconButton( // action button
                                icon: new Icon(Icons.airplay, color: Colors.blue,),
                                onPressed: () {
                                    Application.router.navigateTo(context, "/buildingOptions?buildingId=00933123");
                                },
                            ),
                            new IconButton( // action button
                                icon: new Icon(Icons.location_on, color: Colors.blue,),
                                onPressed: () {_showAlertDialog(context);},
                            ),
                        ],
                    ),
                    body: _listView(eqMap['data'], nowTime),
                )
            );
        }
    }


    // 得到离定位最近的 building
    void _getLocalBuilding () {
        _checkPermission().then((val) {
            if (val != null) {
                location = val;
                print("citycode: " + location.citycode.toString());
                checkCitycode(location.citycode).then((result) {
                    if (result['data'] == 1) {
                        // 检查本地是否存在此citycode
                        StorageUtil.get("citycode").then((localCitycode) {
                            if (localCitycode == null || localCitycode == "") {
                                StorageUtil.save("citycode", location.citycode);
                                print("本地citycode存储成功");
                                setState(() {
                                  homeCitycode = location.citycode;
                                });
                            } else {
                                print("localCitycode: " + localCitycode);
                                if (location.citycode != localCitycode) {
                                    showDialog(
                                        context: context,
                                        child: new AboutDialog(
                                            applicationName: "最佳助手：",
                                            applicationVersion: "V1.0",
                                            applicationIcon: new Icon(Icons.android,color: Colors.blueAccent,),
                                            children: <Widget>[new Text("更新摘要\n新增飞天遁地功能\n优化用户体验")],
                                        )
                                    );
                                    // todo 点击确认后的操作
                                    StorageUtil.save("citycode", location.citycode);
                                    setState(() {
                                      homeCitycode = location.citycode;
                                    });

                                    // todo 点击取消后的操作
                                    setState(() {
                                      homeCitycode = localCitycode;
                                    });
                                } else {
                                    homeCitycode = localCitycode;
                                }
                            }
                            print("_getBuildingByCitycode -- homeCitycode :" + homeCitycode);
                            _getBuildingByCitycode(homeCitycode);
                        });
                    } else {
                        // 数据库不存在此citycode
                        Fluttertoast.showToast(
                            msg: "你所在城市暂未开通此服务",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                    }
                });
            }
        });
    }

    void _getBuildingByCitycode (citycode) {
        String latlong = location.latitude.toString() + "," + location.longitude.toString();
        getBuildingUrl(homeCitycode, latlong).then((val){
            if (val != null) {
                print("citycode 下的 building : " + val['data'][0].toString());
                setState(() {
                    cityBuildingMap = val['data'][0];
                    // todo 本地存储buildingId
                });
            }
        }).catchError((e) {
            LogUtil.e("homt_page._getAllBuilding: ", "${e.error}");     // Finally, callback fires.
        });
    }


    // 得到该城市下的所有 building
    void _getAllBuilding () {
        if (homeCitycode != null) {
            getBuildingUrl(homeCitycode, null).then((val){
                if (val != null) {
                    allBuildingList = [];
                    setState(() {
                        for (Map map in val['data']){
                            allBuildingList.add(map);
                        }
                    });
                }
            }).catchError((e) {
                LogUtil.e("homt_page._getAllBuilding: ", "${e.error}");     // Finally, callback fires.
            });
        }
    }

    // 选择building
    void _showAlertDialog(BuildContext context) {
        _getAllBuilding();
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
                    cityBuildingMap = map;
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
                    Fluttertoast.showToast(
                        msg: "申请定位权限或者读取文件失败",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
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


    /// 释放两个定时器，因为在切换到其他页面时会导致此页面停止，但是本身两个定时器却不会停止，
    /// 这两个定时器会做 setState方法, 这可能会导致内存泄漏，重写这个方法的目的就是让此 widget
    /// 停止的时候保证没有调用setState方法的操作。
    @override
    void deactivate() {
        if (httpTimer != null) {
            httpTimer.cancel();
        }
        if (nowTimeTimer != null) {
            nowTimeTimer.cancel();
        }
        super.deactivate();
    }

    @override
    void dispose() {
        AMapLocationClient.shutdown();
        super.dispose();
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
                                Text(
                                    eqList.elementAt(0)['storeyName'],
                                    style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().setSp(storey_font_size),
                                        height: 1.3,
                                        color: Colors.white,
                                        shadows: [Shadow(color: Colors.white, offset: Offset(0.2, 0.2), blurRadius: 5)], // 阴影
                                    )
                                ),
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
                        )
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

