import 'package:flutter/material.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
    _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

    var eqData;
    Map eqMap;

    final List imageList = ["http://pic1.win4000.com/wallpaper/2019-04-08/5cab197ed8ecf.jpg",
        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab197fc13bf.jpg',
        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab1980d7246.jpg',
        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab1981e4622.jpg',
//        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab198306518.jpg',
//        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab198410688.jpg',
//        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab198410688.jpg',
//        'http://pic1.win4000.com/wallpaper/2019-04-08/5cab198527a4b.jpg',
//    http://pic1.win4000.com/wallpaper/a/593a121d1a0b2.jpg
    ];

    @override
    void initState() {
//        const oneSec = const Duration(seconds:1);
//        new Timer.periodic(oneSec, (Timer t) => getHomePageContent().then((val){
//            setState(() {
//                print(val.toString());
//                eqData = val;
//                print("hi");
//            });
//        }));
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("叮咚"),),
            body: FutureBuilder(
                future: getHomePageContent(),
                builder: (context,snapshot) {
                    if (snapshot.hasData) {
                        var data = snapshot.data;
                        return _listView(data['data']);
                    } else {
                        return Center(
                            child: Text('加载中'),
                        );
                    }
                },
            )
        );
    }
}

Widget _listView(sEqMap) {
    List<Widget> wList = [];
    List<List> storeyEquipmentList = [];
    sEqMap.forEach((k, v) => storeyEquipmentList.add(v));
    for (List eqList in storeyEquipmentList) {
        List<Widget> imageWidgetList = [];
        for (Map eqMap in eqList) {
            imageWidgetList.add(_singleGridWidget(eqMap));
        }
        Container container = new Container(
            child: new Card(
                child: new Column(
                    children: <Widget>[
                        Text(eqList.elementAt(0)['storeyName']),
                        GridView.count(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            childAspectRatio: 1.22,
                            children: imageWidgetList,
                        )
                    ]
                )
            ),
        );
        wList.add(container);
    }
    return ListView(
        children: wList,
    );
}

Widget _singleGridWidget(eqMap){
    var path;
    if (eqMap['status'] == "0") {
        path = "images/green.jpg";
    } else if (eqMap['status'] == "1") {
        path = "images/red.jpg";
    }
    var difference = new DateTime.now().difference(DateTime.parse(eqMap['createTimeStr']));
    var apartTime = difference.inHours.toString() + ":" + (difference.inMinutes - difference.inHours * 60).toString() + ":" + (difference.inSeconds - difference.inMinutes * 60).toString();
    return Container(
        decoration: new BoxDecoration(
            border: new Border.all(width: 3.0, color: Colors.black38),
            borderRadius:
            const BorderRadius.all(const Radius.circular(5.0)),
        ),
        child: _stackImage(eqMap, apartTime)
    );
}

Widget _stackImage(eqMap, apartTime){
    var imageWidget;
    if (eqMap['status'] == "0") {
        imageWidget = new Image.asset("images/green.jpg", scale: 1, fit: BoxFit.cover);
    } else if (eqMap['status'] == "1") {
        imageWidget = new Stack(
            alignment: const FractionalOffset(0.5, 0.5),
            children: <Widget>[
                new Image.asset("images/red.jpg", scale: 1, fit: BoxFit.cover),
                Text(apartTime)
            ],
        );
    }
    return Column(
        children: <Widget>[
            imageWidget,
            Text(eqMap['eqName'])
        ]
    );
}

