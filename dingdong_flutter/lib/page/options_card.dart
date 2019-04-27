import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OptionCard extends StatelessWidget {
  final Map map;

  const OptionCard(this.map,{Key key}) : super(key: key);

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
            margin: const EdgeInsets.all(2.0),
            child: _buildCardContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(context) {
    TextStyle airportNameStyle = new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
    TextStyle airportShortNameStyle = new TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200);
    TextStyle flightNumberStyle = new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500);
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
                      child: Text("MASDDA", style: airportNameStyle),
                    ),
                    Text(map['name'], style: airportShortNameStyle),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Icon(
                    Icons.airplanemode_active,
                    color: Colors.red,
                  ),
                ),
                Text("asd123123", style: flightNumberStyle),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("12312as", style: airportNameStyle),
                    ),
                    Text("4fsdq", style: airportShortNameStyle),
                  ],
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
