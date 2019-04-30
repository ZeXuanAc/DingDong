import 'package:dio/dio.dart';
import 'dart:async';
import '../config/service_url.dart';


/// 主页信息，通过 citycode和 buildingId 得到所有所属的设备信息
Future getHomePageContentUrl(citycode, buildingId, gender) async{
    Response response;
    Dio dio = new Dio();
    var data = {'citycode': citycode,'buildingId': buildingId, "gender": gender};
    response = await dio.get(servicePath['homePageContext'], queryParameters: data);
    if(response.statusCode == 200){
        return response.data;
    }else{
        throw Exception('【${servicePath['homePageContext']}】接口出现异常.........');
    }
}

/// 得到该 citycode 下的所有 Building
Future getBuildingUrl (citycode, location) async{
    Response response;
    Dio dio = new Dio();
    var data = {'citycode': citycode, 'location': location};
    response = await dio.get(servicePath['building'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['building']}】接口出现异常.........');
    }
}

/// 得到所有 city
Future getCityUrl () async{
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['allCity']);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['allCity']}】接口出现异常.........');
    }
}

/// 检查citycode是否存在
Future checkCitycode (citycode) async{
    Response response;
    Dio dio = new Dio();
    var data = {'citycode': citycode};
    response = await dio.get(servicePath['citycode_get'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['citycode_get']}】接口出现异常.........');
    }
}

/// 自动登陆接口
Future autoLogin (token) async{
    Response response;
    Dio dio = new Dio();
    var data = {'token': token};
    response = await dio.get(servicePath['autoLogin'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['autoLogin']}】接口出现异常.........');
    }
}

/// 登陆
Future login (phone, password) async{
    Response response;
    Dio dio = new Dio();
    var data = {'phone': phone, 'password': password};
    response = await dio.get(servicePath['login'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['login']}】接口出现异常.........');
    }
}

/// 注册
Future signUp (name, phone, password, gender) async{
    Response response;
    Dio dio = new Dio();
    var data = {'phone': phone, 'password': password, 'name': name, 'gender': gender};
    response = await dio.get(servicePath['signUp'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['signUp']}】接口出现异常.........');
    }
}