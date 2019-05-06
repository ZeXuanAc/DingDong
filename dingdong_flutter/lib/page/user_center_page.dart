import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';
import 'package:dingdong_flutter/config/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingdong_flutter/config/application.dart';
import 'package:dingdong_flutter/page/gender/gender_card.dart';
import 'package:dingdong_flutter/page/gender/gender.dart';


class UserCenterPage extends StatefulWidget {
    UserCenterPage({Key key}) : super(key: key);

    @override
    _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {

    Gender gender = Gender.female;
    String genderStr = Application.userInfo['gender'];
    String vip = Application.userInfo['vip'];

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
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),  //设置圆角
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/user_center.jpg"),
                                        fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0),),
                                ),
                                child: ListView(
                                    children: getUserInfoList(),
                                ),
                            )
                        )
                    )
                ],
            ),
        );
    }

    List<Widget> getUserInfoList (){
        List<Widget> widgetList = [];
        if (genderStr == "1") {
            genderStr = "男";
            gender = Gender.male;
        } else if (genderStr == "2") {
            genderStr = "女";
            gender = Gender.female;
        } else {
            genderStr = "无";
            gender = Gender.other;
        }
        if (vip == "1") {
            vip = "尊贵会员";
        } else {
            vip = "暂时不是";
        }
        widgetList.add(GestureDetector(
            child: Container(
                height: 60.0,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Container(
                            width: ScreenUtil.getInstance().setWidth(80.0), height: ScreenUtil.getInstance().setHeight(80.0),
                            margin: EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/icon_natural_person.png")),
                            ),
                        ),
                        Container(
                            width: ScreenUtil.getInstance().setWidth(550),
                            margin: EdgeInsets.only(left: 30.0),
                            child: Text(Application.userInfo['name'], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,),
                        ),
                    ],
                ),
            ),
            onTap: () => {
            },
        ));
        widgetList.add(GestureDetector(
            child: Container(
                height: 60.0,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Container(
                            width: ScreenUtil.getInstance().setWidth(80.0), height: ScreenUtil.getInstance().setHeight(80.0),
                            margin: EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/phone.png")),
                            ),
                        ),
                        Container(
                            width: ScreenUtil.getInstance().setWidth(550),
                            margin: EdgeInsets.only(left: 30.0),
                            child: Text(Application.userInfo['phone'], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,),
                        ),
                    ],
                ),
            ),
            onTap: () => {
            },
        ));
        widgetList.add(GestureDetector(
            child: Container(
                height: 60.0,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Container(
                            width: ScreenUtil.getInstance().setWidth(65.0), height: ScreenUtil.getInstance().setHeight(65.0),
                            margin: EdgeInsets.only(left: 22.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/gender.png")),
                            ),
                        ),
                        Container(
                            width: ScreenUtil.getInstance().setWidth(550),
                            margin: EdgeInsets.only(left: 32.0),
                            child: Text(genderStr, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,),
                        ),
                    ],
                ),
            ),
            onTap: () => {
                showDialog<Null>(
                    context: context,
                    builder: (BuildContext context) {
                        return SimpleDialog(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 18.0),
                            children: <Widget>[
                                GenderCard(
                                    gender: gender,
                                    onChanged: (val) => setState(() => gender = val),
                                ),
                            ],
                        );
                    },
                ).then((val){
                    setState(() {
                        genderStr = Application.userInfo['gender'];
                    });
                })
            },
        ));
        widgetList.add(GestureDetector(
            child: Container(
                height: 60.0,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Container(
                            width: ScreenUtil.getInstance().setWidth(90.0), height: ScreenUtil.getInstance().setHeight(90.0),
                            margin: EdgeInsets.only(left: 19.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/vip.png")),
                            ),
                        ),
                        Container(
                            width: ScreenUtil.getInstance().setWidth(550),
                            margin: EdgeInsets.only(left: 28.0),
                            child: Text(vip, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,),
                        ),
                    ],
                ),
            ),
            onTap: () => {
            },
        ));
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

