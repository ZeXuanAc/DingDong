import 'package:flutter/material.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'dart:async';
import 'package:dingdong_flutter/component/animated_rotation_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingdong_flutter/config/common.dart';


class HomePage extends StatefulWidget {
    _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

    Map eqMap;
    DateTime nowTime;
    Timer httpTimer;
    Timer nowTimeTimer;


    @override
    void initState() {
        const oneSec = const Duration(milliseconds: 500);
        httpTimer = new Timer.periodic(oneSec, (Timer t) =>
            getHomePageContent().then((val){
                if (val != null && this.mounted) {
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
        super.initState();
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
    Widget build(BuildContext context) {
        ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

        if (eqMap == null) {
            return Center(
                child: new AnimatedRotationBoxRoute()
            );
        } else {
            return Scaffold(
                appBar: AppBar(title: Text("叮咚"),),
                body: _listView(eqMap['data'], nowTime)
            );
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
                            alignment: const FractionalOffset(0.5, 0.5 ),
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
                                        height: 1.3
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
                        image: DecorationImage(image: AssetImage("images/green.jpg")),
                        // 生成俩层阴影，一层绿，一层黄， 阴影位置由offset决定,阴影模糊层度由blurRadius大小决定（大就更透明更扩散），阴影模糊大小由spreadRadius决定
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
                                image: DecorationImage(image: AssetImage("images/red.jpg")),
                                // 生成俩层阴影，一层绿，一层黄， 阴影位置由offset决定,阴影模糊层度由blurRadius大小决定（大就更透明更扩散），阴影模糊大小由spreadRadius决定
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
                                        color: Colors.white
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

