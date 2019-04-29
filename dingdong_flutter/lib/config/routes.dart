import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
    static String root='/';
    static String cityOptionsPage = '/cityOptions';
    static String buildingOptionsPage = '/buildingOptions';
    static void configureRoutes(Router router){
        router.notFoundHandler = new Handler(
            handlerFunc: (BuildContext context, Map<String,List<String>> params){
                print('ERROR====>ROUTE WAS NOT FONUND!!!');
            }
        );

        // 定义 building选项 router
        router.define(cityOptionsPage, handler:cityOptionsHandler);
        router.define(buildingOptionsPage, handler:buildingOptionsHandler);
    }

}