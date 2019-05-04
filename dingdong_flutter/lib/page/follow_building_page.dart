import 'package:dingdong_flutter/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:dingdong_flutter/config/application.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'package:fluttie/fluttie.dart';
import 'package:dingdong_flutter/page/followBuilding/follow_image_clipper.dart';
import 'followBuilding/follow_building_row.dart';
import 'package:dingdong_flutter/utils/common_util.dart';
import 'followBuilding/follow_list_model.dart';

class FollowBuildingPage extends StatefulWidget {
    _FollowBuildingPageState createState() => _FollowBuildingPageState();
}
class _FollowBuildingPageState extends State<FollowBuildingPage> {
    final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
    FollowListModel listModel;
    Map resultMap;
    List followBuildingList = [];
    bool show = false;

    @override
    void initState() {
        super.initState();
        init();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Scaffold(
                body: buildBody()
            ),
        );
    }


    void init () {
        String location;
        if (Application.location != null && Application.userInfo != null) {
            location = Application.location.latitude.toString() + "," + Application.location.longitude.toString();
            allFollowBuilding(int.parse(Application.userInfo['id']), location).then((val){
                if (val != null && mounted) {
                    setState(() {
                        resultMap = val['data'];
                        initFollowBuildingList(resultMap);
                        listModel = new FollowListModel(_listKey, followBuildingList);
                    });
                }
            }).timeout(new Duration(milliseconds: 5000), onTimeout: (){
                ToastUtil.toastInternetTimeout();
            });
        } else {
            ToastUtil.toastMsg("初始化定位未完成");
        }
    }

    void initFollowBuildingList (resultMap) {
        int first = 0;
        resultMap.values.forEach((v){
            Color color = CommonUtil.randomColor();
            v.forEach((map) {
                map['color'] = color;
                if (first == 0) {
                    map['show'] = true;
                } else {
                    map['show'] = false;
                }
                followBuildingList.add(map);
            });
            first ++;
        });
    }

    Widget buildBody () {
        if (resultMap == null) {
            _startLoadingAnimation();
            return Center(
                child: new FluttieAnimation(Application.loadingAnimation),
            );
        } else {
            return Container(
                child: Stack(
                    children: <Widget>[
                        // 背景图
                        ClipPath(
                            clipper: new FollowImageClipper(),
                            child: Image.asset('assets/images/peak.jpg', fit: BoxFit.fitWidth,
                                colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40),),
                        ),
                        // header
                        _buildTopHeader(),
                        _buildBottomPart(),
                        _buildTimeline(),
                        _buildFab(),
                    ],
                )
            );
        }
    }


    Widget _buildTopHeader() {
        return new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
            child: new Row(
                children: <Widget>[
                    new Icon(Icons.menu, size: 26.0, color: Colors.white),
                    new Expanded(
                        child: new Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Text(
                                "我的关注",
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                            ),
                        ),
                    ),
                    new Icon(Icons.linear_scale, color: Colors.white),
                ],
            ),
        );
    }


    Widget _buildBottomPart() {
        return new Padding(
            padding: new EdgeInsets.only(top: 210.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    _buildMyTasksHeader(),
                    _buildTasksList(),
                ],
            ),
        );
    }

    Widget _buildTasksList() {
        return new Expanded(
            child: new AnimatedList(
                initialItemCount: followBuildingList.length,
                key: _listKey,
                itemBuilder: (context, index, animation) {
                    return new FollowBuildingRow(
                        map: listModel[index],
                        animation: animation,
                    );
                },
            )
        );
    }

    Widget _buildMyTasksHeader() {
        return new Padding(
            padding: new EdgeInsets.only(left: 24.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                    new Text(
                        'Follow Building',
                        style: new TextStyle(fontSize: 34.0),
                    ),
                    Container(
                        height: 34.0,
                        width: 40.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对齐
                            children: <Widget>[
                                Text('('+ followBuildingList.length.toString() + ')', style: new TextStyle(color: Colors.grey, fontSize: 20.0),),
                            ],
                    ),
                    ) ,
                ],
            ),
        );
    }

    Widget _buildTimeline() {
        return new Positioned(
            top: 270.0,
            bottom: 0.0,
            left: 32.0,
            child: new Container(
                width: 1.0,
                color: Colors.grey[300],
            ),
        );
    }

    Widget _buildFab() {
        return new Positioned(
            top: 210 - 36.0,
            right: 16.0,
            child: new FloatingActionButton(
                onPressed: _changeFilterState,
                backgroundColor: Colors.pink,
                child: new Icon(Icons.filter_list),
            ),
        );
    }

    void _changeFilterState() {
        show = !show;
        followBuildingList.where((map) => !map['show']).forEach((map) {
            if (show) {
                listModel.removeAt(listModel.indexOf(map));
            } else {
                listModel.insert(followBuildingList.indexOf(map), map);
            }
        });
    }


    void _startLoadingAnimation () async {
        if (Application.loadingAnimation != null && mounted) {
            setState(() {
                Application.loadingAnimation.start(); //start our looped emoji animation
            });
        } else {
            // 先加载组件
            var instance = new Fluttie();
            var eComposition = await instance.loadAnimationFromAsset(
                'assets/animatd/loading-flutter.json',
            );
            Application.loadingAnimation = await instance.prepareAnimation(eComposition);
            if (mounted) {
                setState(() {
                    Application.loadingAnimation.start(); //start our looped emoji animation
                });
            }
        }
    }

}