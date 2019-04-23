import 'dart:async';
import 'package:flutter/services.dart';

class BaiduMapService {
  static const MethodChannel _channel = const MethodChannel('com.zxac.flutter.plugins/baiduMap');

  static Future<bool> mapView(lat, lng, floor) async {
    Map<String, String> param = {"lat": lat, "lng": lng, "floor": floor};
    return await _channel.invokeMethod('mapView', param);
  }
}