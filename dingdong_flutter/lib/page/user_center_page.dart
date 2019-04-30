import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'login_page.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';
import 'package:dingdong_flutter/config/common.dart';

class UserCenterPage extends StatefulWidget {
    UserCenterPage({Key key}) : super(key: key);

    @override
    _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {


    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("个人中心"),
                actions: <Widget>[
                    new IconButton( // action button
                        icon: new Icon(Icons.call_missed_outgoing, color: Colors.white,),
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
            body: Text("个人中心"),
        );
    }
}
