import 'package:fluro/fluro.dart';
import 'package:fluttie/fluttie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application{
    static Router router;
    static FluttieAnimationController loadingAnimation;
    static var userInfo;
    static SharedPreferences prefs;
}