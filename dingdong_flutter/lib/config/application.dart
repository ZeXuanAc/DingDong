import 'package:amap_location/amap_location.dart';
import 'package:fluro/fluro.dart';
import 'package:fluttie/fluttie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application{
    static Router router;
    static FluttieAnimationController loadingAnimation;
    static Map userInfo;
    static SharedPreferences prefs;
    static AMapLocation location;
    static String citycode;
    static Map cityBuildingMap;
}