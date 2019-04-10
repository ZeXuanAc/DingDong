import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'third_page.dart';
import 'two_page.dart';
import 'home_page.dart';

class IndexPage extends StatefulWidget {
    _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

    final List tabBodies = [
        HomePage(),
        TwoPage(),
        ThirdPage()
    ];

    final List<BottomNavigationBarItem> bottomTabs = [
        BottomNavigationBarItem(
                icon:Icon(CupertinoIcons.home),
                title:Text('首页')
        ),
        BottomNavigationBarItem(
                icon:Icon(CupertinoIcons.search),
                title:Text('分类')
        ),
        BottomNavigationBarItem(
                icon:Icon(CupertinoIcons.profile_circled),
                title:Text('会员中心')
        ),
    ];

    int currentIndex = 0;
    var currentPage;
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

