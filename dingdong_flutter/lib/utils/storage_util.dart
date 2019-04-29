import 'package:shared_preferences/shared_preferences.dart';
import 'package:dingdong_flutter/config/application.dart';

class StorageUtil {

    static init() async {
        Application.prefs = await SharedPreferences.getInstance();
    }

    static save(key, value) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(key, value);
    }

    static Future<String> get(key) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var value = prefs.getString(key);
        return value;
    }

    static Future<bool> remove(key) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var value = prefs.remove(key);
        return value;
    }

}