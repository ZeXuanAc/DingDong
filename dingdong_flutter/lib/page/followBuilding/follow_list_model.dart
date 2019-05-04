import 'follow_building_row.dart';
import 'package:flutter/material.dart';

class FollowListModel {
  FollowListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Map item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Map removeAt(int index) {
    final Map removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) => new FollowBuildingRow(
              map: removedItem,
              animation: animation,
            ),
        duration: new Duration(milliseconds: (150 + 200 * (index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Map operator [](int index) => items[index];

  int indexOf(Map item) => items.indexOf(item);
}
