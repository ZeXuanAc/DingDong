import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'page/index_page.dart';
import 'package:amap_location/amap_location.dart';
import 'package:fluro/fluro.dart';
import 'package:dingdong_flutter/config/routes.dart';
import 'package:dingdong_flutter/config/application.dart';
import 'package:dingdong_flutter/utils/storage_util.dart';
import 'package:dingdong_flutter/config/common.dart';
import 'package:dingdong_flutter/page/login_page.dart';

void main() {
    AMapLocationClient.setApiKey("4cad2d787551c53980ca94675c5db6b6");

    runApp(MaterialApp(
        home: MyApp(), // becomes the route named '/'
//        routes: <String, WidgetBuilder> {
//            '/indexPage': (BuildContext context) => IndexPage(),
//        },
    ));
}


class MyApp extends StatefulWidget {
    _MyAppState createState() {return _MyAppState();}
}

class _MyAppState extends State<MyApp>{

    Widget firstPage;

    @override
    void initState() {
        final router = Router();
        Routes.configureRoutes(router);
        Application.router = router;
        _initAnimation();
        _login();

        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        if (firstPage == null && Application.loadingAnimation != null) {
            return Center(
                child: new FluttieAnimation(Application.loadingAnimation),
            );
        } else if (firstPage != null) {
            return Container(
                child: MaterialApp(
                    title:'叮咚',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                        primaryColor:Colors.blue
                    ),
                    home: firstPage
                ),
            );
        } else  {
            return Container(
                child: MaterialApp(
                    title:'叮咚',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                        primaryColor:Colors.blue
                    ),
                    home: Center(
                        child: Text("广告"),
                    )
                ),
            );
        }
    }

    void _initAnimation () async {
        // 先加载组件
        var instance = new Fluttie();
        var eComposition = await instance.loadAnimationFromAsset(
            'assets/animatd/loading-flutter.json',
        );
        Application.loadingAnimation = await instance.prepareAnimation(eComposition);
    }


    void _login(){
        StorageUtil.get(token).then((val){
            if (val != null) {
                // todo 验证本地token，存在则返回用户信息，不存在则转至登录页登陆
                print("获取本地token，取得用户信息: " + val.toString());
                setState(() {
                    firstPage =  new IndexPage();
                });
            } else {
                print("本地token不存在或者获取失败");
                setState(() {
                    firstPage =  new LoginPage();
                });
            }
        });
    }
}