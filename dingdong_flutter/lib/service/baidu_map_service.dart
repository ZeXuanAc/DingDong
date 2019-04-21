import 'dart:async';
import 'package:flutter/services.dart';

class BaiduMapService {
  static const MethodChannel _channel = const MethodChannel('com.zxac.flutter.plugins/baiduMap');

  static Future<bool> mapView(lat, lng) async {
    Map<String, String> param = {"lat": lat, "lng": lng};
    return await _channel.invokeMethod('mapView', param);
  }
}