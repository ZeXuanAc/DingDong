import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {

    static save(key, value) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(key, value);
    }

    static Future<String> get(key) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var value = prefs.getString(key);
        return value;
    }
}