import 'package:flutter/material.dart';
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


        return Container(
            child: MaterialApp(
                title:'叮咚',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor:Colors.pink
                ),
                home: IndexPage()
            ),
        );
    }

}