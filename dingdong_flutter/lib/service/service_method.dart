import 'package:dio/dio.dart';
import 'dart:async';
import '../config/service_url.dart';


Future getHomePageContent() async{
    try{
        Response response;
        Dio dio = new Dio();
        var data = {'cityId':'1','buildingId':'2'};
        response = await dio.get(servicePath['homePageContext'], queryParameters: data);
        if(response.statusCode == 200){
            return response.data;
        }else{
            throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
        }
    }catch(e){
        // ignore: unnecessary_brace_in_string_interps
        return print('ERROR:======>${e}');
    }
}
