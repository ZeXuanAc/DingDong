import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:dingdong_flutter/page/city_options_page.dart';


Handler cityOptionsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
        return CityOptionsPage();
    }
);


//Handler buildingOptionsHandler = Handler(
//    handlerFunc: (BuildContext context, Map<String, List<String>> params){
//      String buildingId = params['buildingId'].first;
//      return BuildingOptionsPage(buildingId);
//    }
//);