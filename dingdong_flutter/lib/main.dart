import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'page/index_page.dart';
import 'package:amap_location/amap_location.dart';
import 'package:fluro/fluro.dart';
import 'package:dingdong_flutter/config/routes.dart';
import 'package:dingdong_flutter/config/application.dart';
//import 'package:flutter_baidu_map/flutter_baidu_map.dart';

void main() {
    AMapLocationClient.setApiKey("4cad2d787551c53980ca94675c5db6b6");
//    FlutterBaiduMap.setAK("LDehsPmP5qMRfhk2rELGbGpqMdUThsHP");
    runApp(MyApp());
}


class MyApp extends StatelessWidget {


    @override
    Widget build(BuildContext context) {
        final router = Router();
        Routes.configureRoutes(router);
        Application.router = router;
        _initAnimation();

        return Container(
            child: MaterialApp(
                title:'叮咚',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor:Colors.blue
                ),
                home: IndexPage()
            ),
        );
    }


    void _initAnimation () async {
        // 先加载组件
        var instance = new Fluttie();
        var eComposition = await instance.loadAnimationFromAsset(
            'assets/animatd/loading-flutter.json',
        );
        Application.loadingAnimation = await instance.prepareAnimation(eComposition);
    }

}