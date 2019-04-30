import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';
import 'package:dingdong_flutter/config/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingdong_flutter/config/application.dart';

class UserCenterPage extends StatefulWidget {
    UserCenterPage({Key key}) : super(key: key);

    @override
    _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {


    @override
    Widget build(BuildContext context) {
        ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

        return new Scaffold(
            body: Stack(
                children: <Widget>[
                    buildAppBar(context),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 10.0),
                        child: Card(
                            elevation: 5.0,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),  //设置圆角
                            child: ListView(
                                children: getUserInfoList(),
                            )
                        )
                    )
                ],
            ),
        );
    }

    List<Widget> getUserInfoList (){
        List<Widget> widgetList = [];
        if (Application.userInfo != null) {
            Application.userInfo.forEach((key, val) {
                widgetList.add(_buildCardContent(key, val));
            });
        }
        return widgetList;
    }
}


Widget buildAppBar(context) {
    return Stack(
        children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[400], Colors.blue[800]],
                    ),
                ),
                height: ScreenUtil.getInstance().setHeight(600.0),
            ),
            new AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                title: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Text(
                        "个人中心",
                        style: TextStyle(
                            fontFamily: 'NothingYouCouldDo', fontWeight: FontWeight.bold),
                    ),
                ),
                actions: <Widget>[
                    new IconButton( // action button
                        icon: new Icon(Icons.delete_outline, color: Colors.white,),
                        onPressed: () {
                            StorageUtil.remove(storageToken);
                            Navigator.pushAndRemoveUntil(context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                        return LoginPage();
                                    },
                                ), (route) => route == null);
                        },
                    ),
                ],
            ),
        ],
    );
}

Widget _buildCardContent(key, value) {
    return GestureDetector(
        child: Container(
            height: 60.0,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    Container(
                        width: ScreenUtil.getInstance().setWidth(250),
                        margin: EdgeInsets.only(left: 30.0),
                        child: Text(key, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.cyan),
                            textAlign: TextAlign.left, )
                    ),
                    Container(
                        width: ScreenUtil.getInstance().setWidth(500),
                        margin: EdgeInsets.only(left: 30.0),
                        child: Text(value, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,),
                    ),
                ],
            ),
        ),
        onTap: () => {
        },
    );
}
