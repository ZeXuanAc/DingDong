import 'package:dingdong_flutter/page/index_page.dart';
import 'package:flutter/material.dart';
import 'package:dingdong_flutter/config/application.dart';


class FollowBuildingRow extends StatefulWidget {
  final Map map;
  final Animation<double> animation;

  FollowBuildingRow(this.map, this.animation);

  @override
  FollowBuildingRowState createState() => new FollowBuildingRowState(map, animation);
}
class FollowBuildingRowState extends State<FollowBuildingRow> {
  Map map;
  double dotSize = 12.0;
  Animation<double> animation;
  int paddingOpacity = 0;


  FollowBuildingRowState(Map map, Animation<double> animation) {
    this.map = map;
    this.animation = animation;
  }

  @override
  Widget build(BuildContext context) {

    return new FadeTransition(
      opacity: animation,
      child: new SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          onTap: (){
            setState(() {
              paddingOpacity = 120;
            });
            toIndex0Page(context);
          },
          onTapDown: (tapDown) {
            setState(() {
              paddingOpacity = 120;
            });
          },
          onTapUp: (tapUp) {
            setState(() {
              paddingOpacity = 0;
            });
          },
          onTapCancel: () => setState(() {
            paddingOpacity = 0;
          }),
          child: Container(
              color: Color.fromARGB(paddingOpacity, 20, 10, 40),
                child: new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                        padding:
                        new EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                        child: new Container(
                          height: dotSize,
                          width: dotSize,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle, color: map['color']),
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              map['buildingName'],
                              style: new TextStyle(fontSize: 18.0),
                            ),
                            new Text(
                              map['cityName'],
                              style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: new Text(
                          map['distanceStr'],
                          style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
          )
        )
      ),
    );
  }

  void toIndex0Page (context) {
    print("点击了" + map.toString());
    Application.cityBuildingMap.clear();
    Application.cityBuildingMap['id'] = map['buildingId'];
    Application.cityBuildingMap['name'] = map['buildingName'];
    Application.cityBuildingMap['cityName'] = map['cityName'];
    Application.cityBuildingMap['citycode'] = map['citycode'];
    Application.cityBuildingMap['longitude'] = map['longitude'];
    Application.cityBuildingMap['latitude'] = map['latitude'];
    Application.citycode = map['citycode'];
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return IndexPage(0);
          },
        ), (route) => route == null);
  }


}
