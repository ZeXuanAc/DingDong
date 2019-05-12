import 'package:dio/dio.dart';
import 'dart:async';
import '../config/service_url.dart';


/// 主页信息，通过 citycode和 buildingId 得到所有所属的设备信息
Future getHomePageContentUrl(citycode, buildingId, gender) async{
    Response response;
    Dio dio = new Dio();
    print("getHomePageContentUrl : citycode: " + citycode.toString() + ", buildingId: " + buildingId.toString() + ", gender: " + gender.toString());
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
    print("server_method: getBuildingUrl: " + citycode + ", location: " + location);
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

/// 查询该building是否已关注
Future followBuildingCount (uid, buildingId) async{
    Response response;
    Dio dio = new Dio();
    var data = {'uid': int.parse(uid), 'buildingId': buildingId};
    response = await dio.get(servicePath['followBuildingCount'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['followBuildingCount']}】接口出现异常.........');
    }
}


/// 关注building
Future followBuilding (uid, phone, buildingId) async{
    Response response;
    Dio dio = new Dio();
    var data = {'uid': int.parse(uid), 'phone': phone.toString(), 'buildingId': buildingId};
    response = await dio.get(servicePath['followBuilding'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['followBuilding']}】接口出现异常.........');
    }
}

/// 取消关注building
Future unFollowBuilding (uid, buildingId) async{
    Response response;
    Dio dio = new Dio();
    var data = {'uid': uid, 'buildingId': buildingId};
    response = await dio.get(servicePath['unFollowBuilding'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['unFollowBuilding']}】接口出现异常.........');
    }
}

/// 获取所有关注building
Future allFollowBuilding (uid, location) async{
    Response response;
    Dio dio = new Dio();
    var data = {'uid': uid, 'location': location};
    response = await dio.get(servicePath['allFollowBuilding'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['allFollowBuilding']}】接口出现异常.........');
    }
}

/// 修改用户信息
Future editInfo (id, token, gender) async{
    Response response;
    Dio dio = new Dio();
    var data = {'id': id, 'token': token, "gender": gender};
    response = await dio.get(servicePath['editInfo'], queryParameters: data);
    if (response.statusCode == 200){
        return response.data;
    } else {
        throw Exception('【${servicePath['editInfo']}】接口出现异常.........');
    }
}