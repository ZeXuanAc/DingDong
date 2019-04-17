import 'package:flutter/material.dart';
import 'page/index_page.dart';
import 'package:amap_location/amap_location.dart';

void main() {
    AMapLocationClient.setApiKey("4cad2d787551c53980ca94675c5db6b6");
    runApp(MyApp());
}


class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
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