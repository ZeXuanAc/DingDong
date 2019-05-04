import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user_center_page.dart';
import 'follow_building_page.dart';
import 'home_page.dart';

class IndexPage extends StatefulWidget {
    final int currentIndex = 0;

    IndexPage(currentIndex);

    _IndexPageState createState() => _IndexPageState(this.currentIndex);
}

class _IndexPageState extends State<IndexPage> {
    int currentIndex = 0;
    var currentPage;

    _IndexPageState(currentIndex){
        this.currentIndex = currentIndex;
    }

    final List tabBodies = [
        HomePage(),
        FollowBuildingPage(),
        UserCenterPage()
    ];

    final List<BottomNavigationBarItem> bottomTabs = [
        BottomNavigationBarItem(
            icon:Icon(CupertinoIcons.home),
            title:Text('首页'),
        ),
        BottomNavigationBarItem(
            icon:Icon(CupertinoIcons.search),
            title:Text('关注'),
        ),
        BottomNavigationBarItem(
            icon:Icon(CupertinoIcons.profile_circled),
            title:Text('个人中心'),
        ),
    ];


    @override
    void initState() {
        currentPage = tabBodies[currentIndex];
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                items: bottomTabs,
                onTap: (index){
                    setState(() {
                        currentIndex = index;
                        currentPage = tabBodies[currentIndex];
                    });
                },
            ),
            body: currentPage
        );
    }
}

