import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildingOptionCard extends StatelessWidget {
  final Map map;

  const BuildingOptionCard(this.map,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);


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
    var distance = map['distanceStr'];
    if (distance == null) {
      distance = "";
    }
    return GestureDetector(
      child: Container(
        height: 90.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().setWidth(150),
              margin: EdgeInsets.only(left: 15.0),
              child: Center(
                child: Icon(
                  Icons.business,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              width: ScreenUtil.getInstance().setWidth(500),
              margin: EdgeInsets.only(left: 10.0),
              child: Text(map['name'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300), textAlign: TextAlign.left,)
            ),
            Container(
              width: ScreenUtil.getInstance().setWidth(180),
              margin: EdgeInsets.only(left: 10.0),
              child: Center(
                child: Center(
                  child: Text(distance, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
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
