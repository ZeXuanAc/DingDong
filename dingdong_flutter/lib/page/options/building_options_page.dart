import 'package:dingdong_flutter/config/application.dart';
import 'package:flutter/material.dart';
import 'package:dingdong_flutter/page/options/building_options_card.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'package:dingdong_flutter/utils/toast_util.dart';
import 'package:fluttie/fluttie.dart';

class BuildingOptionsPage extends StatefulWidget {
  final String citycode;
  final String lat;
  final String lng;
  BuildingOptionsPage(this.citycode, this.lat, this.lng);

  @override
  BuildingOptionsPageState createState() => new BuildingOptionsPageState(citycode, lat, lng);
}

class BuildingOptionsPageState extends State<BuildingOptionsPage>{

  final TextEditingController searchView = TextEditingController();
  String citycode;
  String lat;
  String lng;
  List<Map> resultList = []; // 结果list
  bool isSearching;
  String searchString = "";
  Icon actionIcon = Icon(Icons.search, color: Colors.black);
  Widget appBarTextView = Text("building", style: new TextStyle(color: Colors.black),);

  BuildingOptionsPageState(citycode, lat, lng) {
    this.citycode = citycode;
    this.lat = lat;
    this.lng = lng;
    searchView.addListener(() {
      if (searchView.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchString = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchString = searchView.text;
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    isSearching = false;
    init();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(context),
      body: buildBody()
    );
  }


  void init () {
    print("lat: " + lat.toString() + " ; lng: " + lng.toString());
    String location;
    if (lat != null && lng != null) {
      location = lat + "," + lng;
    }
    getBuildingUrl(citycode, location).then((val){
      if (val != null && mounted) {
        setState(() {
          for (Map map in val['data']){
            resultList.add(map);
          }
        });
      }
    }).timeout(new Duration(milliseconds: 5000), onTimeout: (){
      ToastUtil.toastInternetTimeout();
    });
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTextView,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTextView = TextField(
                    controller: searchView,
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.black)),
                  );
                  searchStart();
                } else {
                  searchEnd();
                }
              });
            },
          ),
        ]);
  }


  Widget buildBody () {
    if (resultList == null) {
      _startLoadingAnimation();
      return Center(
        child: new FluttieAnimation(Application.loadingAnimation),
      );
    } else {
      return Container(
//        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          children: isSearching ? _buildSearchList() : _buildList(),
        ),
      );
    }
  }


  List<BuildingOptionCard> _buildList() {
    return resultList.map((map) => BuildingOptionCard(map)).toList();
  }

  List<BuildingOptionCard> _buildSearchList() {
    if (searchString.isEmpty) {
      return resultList.map((map) => BuildingOptionCard(map)).toList();
    } else {
      List<Map> searchList = List();
      for (int i = 0; i < resultList.length; i++) {
        Map buildingInfo = resultList.elementAt(i);
        if (buildingInfo['name'].toLowerCase().contains(searchString.toLowerCase())) {
          searchList.add(buildingInfo);
        }
      }
      return searchList.map((map) => BuildingOptionCard(map)).toList();
    }
  }


  void searchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void searchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTextView = Text(
        "building",
        style: TextStyle(color: Colors.black),
      );
      isSearching = false;
      searchView.clear();
    });
  }

  void _startLoadingAnimation () async {
    if (Application.loadingAnimation != null && mounted) {
      setState(() {
        Application.loadingAnimation.start(); //start our looped emoji animation
      });
    } else {
      // 先加载组件
      var instance = new Fluttie();
      var eComposition = await instance.loadAnimationFromAsset(
        'assets/animatd/loading-flutter.json',
      );
      Application.loadingAnimation = await instance.prepareAnimation(eComposition);
      if (mounted) {
        setState(() {
          Application.loadingAnimation.start(); //start our looped emoji animation
        });
      }
    }
  }


}