import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtil {

  static void toast (msg, ToastGravity gravity, MaterialColor backgroundColor, MaterialColor textColor, double fontSize){
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: gravity,
        timeInSecForIos: 1, backgroundColor: backgroundColor, textColor: textColor, fontSize: fontSize);
  }

  static void toastMsg (msg){
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.black38, textColor: Colors.white, fontSize: 16.0);
  }


  static void toastInternetError () {
    Fluttertoast.showToast(msg: "请求错误, 请检查网络", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  static void toastInternetTimeout () {
    Fluttertoast.showToast(msg: "请求服务器超时, 请检查网络", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  static void toastLocationPermission () {
    Fluttertoast.showToast(msg: "请检查是否开启定位权限", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  static void toastNoCitycode () {
    Fluttertoast.showToast(msg: "你所在城市暂未开通此服务", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.black38, textColor: Colors.white, fontSize: 16.0
    );
  }
  static void toastNoBuilding () {
    Fluttertoast.showToast(msg: "该城市暂无此服务", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP,
        timeInSecForIos: 1, backgroundColor: Colors.black38, textColor: Colors.white, fontSize: 16.0
    );
  }

}