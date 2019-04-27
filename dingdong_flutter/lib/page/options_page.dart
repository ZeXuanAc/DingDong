import 'package:flutter/material.dart';
import 'package:dingdong_flutter/page/options_card.dart';
import 'package:dingdong_flutter/service/service_method.dart';
import 'package:dingdong_flutter/utils/toast_util.dart';

class BuildingOptionsPage extends StatefulWidget {
  final String buildingId;
  BuildingOptionsPage(this.buildingId);

  @override
  BuildingOptionsPageState createState() => new BuildingOptionsPageState();
}

class BuildingOptionsPageState extends State<BuildingOptionsPage>{

  final TextEditingController searchView = TextEditingController();
  List<Map> resultList; // 结果list
  bool isSearching;
  String searchString = "";
  Icon actionIcon = Icon(Icons.search, color: Colors.black);
  Widget appBarTextView = Text("", style: new TextStyle(color: Colors.black),);

  BuildingOptionsPageState() {
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
    getCityUrl().then((val){
      if (val != null && mounted) {
        resultList = [];
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
      return Text("加载中");
    } else {
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: isSearching ? _buildSearchList() : _buildList(),
      );
    }
  }


  List<OptionCard> _buildList() {
    return resultList.map((map) => OptionCard(map)).toList();
  }

  List<OptionCard> _buildSearchList() {
    if (searchString.isEmpty) {
      return resultList.map((map) => OptionCard(map)).toList();
    } else {
      List<Map> searchList = List();
      for (int i = 0; i < resultList.length; i++) {
        Map equipmentInfo = resultList.elementAt(i);
        if (equipmentInfo['name'].toLowerCase().contains(searchString.toLowerCase())) {
          searchList.add(equipmentInfo);
        }
      }
      return searchList.map((map) => OptionCard(map)).toList();
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
        "",
        style: TextStyle(color: Colors.black),
      );
      isSearching = false;
      searchView.clear();
    });
  }

}