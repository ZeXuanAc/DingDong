import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class FollowBuildingPage extends StatefulWidget {
    _FollowBuildingPageState createState() => _FollowBuildingPageState();
}
class _FollowBuildingPageState extends State<FollowBuildingPage> {
    String showText = '';

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Scaffold(
                    appBar: AppBar(title: Text("我的关注"),),
                    body: SingleChildScrollView(
                        child: Container(
                            child: Column(
                                children: <Widget>[
                                    TextField(
                                        decoration:InputDecoration (
                                                contentPadding: EdgeInsets.all(10.0),
                                                labelText: '美女类型',
                                                helperText: '请输入你喜欢的类型'
                                        ),
                                        autofocus: false,
                                    ),
                                    Text(
                                        showText,
                                        overflow:TextOverflow.ellipsis,
                                        maxLines: 2,
                                    ),
                                ],
                            ),
                        )
                    )
            ),
        );
    }

}