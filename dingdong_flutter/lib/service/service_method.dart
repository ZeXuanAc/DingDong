import 'package:dio/dio.dart';
import 'dart:async';
import '../config/service_url.dart';


/// 主页信息，通过 citycode和 buildingId 得到所有所属的设备信息
Future getHomePageContentUrl(citycode, buildingId) async{
    try {
        Response response;
        Dio dio = new Dio();
        var data = {'citycode': citycode,'buildingId': buildingId};
        response = await dio.get(servicePath['homePageContext'], queryParameters: data);
        if(response.statusCode == 200){
            return response.data;
        }else{
            throw Exception('【${servicePath['homePageContext']}】接口出现异常.........');
        }
    } catch (e) {
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}


/// 得到该 citycode 下的所有 Building
Future getBuildingUrl (citycode, location) async{
    try {
        Response response;
        Dio dio = new Dio();
        var data = {'citycode': citycode, 'location': location};
        response = await dio.get(servicePath['building'], queryParameters: data);
        if (response.statusCode == 200){
            return response.data;
        } else {
            throw Exception('【${servicePath['building']}】接口出现异常.........');
        }
    } catch (e) {
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}


/// 得到所有 city
Future getCityUrl () async{
    try {
        Response response;
        Dio dio = new Dio();
        response = await dio.get(servicePath['allCity']);
        if (response.statusCode == 200){
            return response.data;
        } else {
            throw Exception('【${servicePath['allCity']}】接口出现异常.........');
        }
    } catch (e) {
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}


/// 检查citycode是否存在
Future checkCitycode (citycode) async{
    try {
        Response response;
        Dio dio = new Dio();
        var data = {'citycode': citycode};
        response = await dio.get(servicePath['citycode_get'], queryParameters: data);
        if (response.statusCode == 200){
            return response.data;
        } else {
            throw Exception('【${servicePath['citycode_get']}】接口出现异常.........');
        }
    } catch (e) {
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}
