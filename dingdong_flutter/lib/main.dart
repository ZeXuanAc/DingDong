import 'package:flutter/material.dart';
import 'page/index_page.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
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