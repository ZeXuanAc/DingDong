import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';


Future getHomePageContent() async{
    try{
        print('开始获取首页数据...............');
        Response response;
        Dio dio = new Dio();
        var data = {'cityId':'1','buildingId':'1'};
        response = await dio.get(servicePath['homePageContext-test'], queryParameters: data);
        if(response.statusCode == 200){
            print('首页数据获取成功...............');
            return response.data;
        }else{
            throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
        }
    }catch(e){
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}
