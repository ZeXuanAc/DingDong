import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CityOptionCard extends StatelessWidget {
  final Map map;

  const CityOptionCard(this.map,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(10.0),
      child: Material(
        elevation: 4.0,
        shadowColor: Color(0x30E5E5E5),
        color: Colors.transparent,
        child: ClipPath(
          clipper: TicketClipper(12.0),
          child: Card(
            elevation: 0.0,
            margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 8.0),
            child: _buildCardContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(context) {
    TextStyle citycodeStyle = new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400);
    TextStyle provinceNameStyle = new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w200);
    return GestureDetector(
      child: Container(
        height: 104.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(map['citycode'], style: citycodeStyle),
                    ),
                    Text(map['name'], style: provinceNameStyle, overflow: TextOverflow.fade,),
                  ],
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.location_city,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 0.0),
                child: Center(
                  child: Text(map['province'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300)),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
      Navigator.pop(context, map)
      },
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double radius;

  TicketClipper(this.radius);

  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: radius));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
