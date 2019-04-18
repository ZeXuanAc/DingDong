import 'package:flutter/material.dart';

class BuildingOptionsPage extends StatelessWidget {
    final String buildingId;
    BuildingOptionsPage(this.buildingId);

    @override
    Widget build(BuildContext context) {
        return Container(
            child:Text('buildingId：${buildingId}')
        );
    }
}