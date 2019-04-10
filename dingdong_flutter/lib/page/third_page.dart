import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ThirdPage extends StatefulWidget {
    ThirdPage({Key key}) : super(key: key);

    @override
    _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

    final List<String> imageList = ["http://pic1.win4000.com/mobile/2019-04-10/5cad9bb9a8f3d.jpg",
                                    "http://pic1.win4000.com/mobile/2019-04-10/5cad9bba41329.jpg",
                                    "http://pic1.win4000.com/mobile/2019-04-10/5cad9bbada44b.jpg",
                                    "http://pic1.win4000.com/mobile/2019-04-10/5cad9bbbe2ab5.jpg",
                                    "http://pic1.win4000.com/mobile/2019-04-10/5cad9bbcf19d0.jpg",
                                    "http://pic1.win4000.com/mobile/2019-04-10/5cad9bbe08c17.jpg"
    ];

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Flutter Swiper"),
            ),
            body: new Swiper(
                itemBuilder: (BuildContext context, int index){
                    return new Image.network("${imageList[index]}", fit: BoxFit.cover,);
                },
                itemCount: imageList.length,
                itemWidth: 300.0,
                layout: SwiperLayout.STACK,
            ),
        );
    }
}
