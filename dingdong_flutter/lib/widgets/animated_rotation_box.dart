import 'package:flutter/material.dart';
import 'package:flukit/flukit.dart';


class AnimatedRotationBoxRoute extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Theme(
                data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                            color: Theme
                                    .of(context)
                                    .accentColor,
                            size: 30.0
                    ),
                ),
                child: Wrap(
                    spacing: 16.0,
                    alignment: WrapAlignment.center,
                    runSpacing: 16.0,
                    children: <Widget>[
                        AnimatedRotationBox(
                            child: GradientCircularProgressIndicator(
                                colors: [
                                    Colors.red,
                                    Colors.amber,
                                    Colors.cyan,
                                    Colors.green[200],
                                    Colors.blue,
                                    Colors.red
                                ],
                                radius: 60.0,
                                stokeWidth: 5.0,
                                strokeCapRound: true,
                                backgroundColor: Colors.transparent,
                                value: 1.0,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
