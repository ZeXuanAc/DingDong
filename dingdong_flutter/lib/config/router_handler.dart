import 'package:dingdong_flutter/page/options/building_options_page.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:dingdong_flutter/page/options/city_options_page.dart';
import 'package:dingdong_flutter/page/index_page.dart';


Handler indexPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      return IndexPage(0);
    }
);

Handler cityOptionsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
        return CityOptionsPage();
    }
);


Handler buildingOptionsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params){
      print("params: " + params.toString());
      String citycode = params['citycode'].first;
      String lat = params['lat'].first;
      String lng = params['lng'].first;
      return BuildingOptionsPage(citycode, lat, lng);
    }
);