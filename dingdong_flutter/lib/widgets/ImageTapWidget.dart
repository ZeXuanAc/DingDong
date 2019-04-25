import 'package:flutter/material.dart';

///
/// 图片点击效果，使用动画实现（透明度改变）
/// 在按下的时候执行动画, 然后在抬起或取消的时候也先不结束动画,而是监听动画状态,等待动画完成再执行动画效果上的取消动画
///
class ImageTapWidget extends StatefulWidget {
  final Widget child;
  final Function onTap;

  const ImageTapWidget(this.child, this.onTap, {Key key}) : super(key: key);

  @override
  ImageTapWidgetState createState() {
    return new ImageTapWidgetState();
  }
}

class ImageTapWidgetState extends State<ImageTapWidget> with SingleTickerProviderStateMixin {
  AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _ctl.stop();
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (BuildContext context, Widget child) {
          return Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5 * _ctl.value),
            ),
            child: widget.child,
          );
        },
      ),
      onTap: widget.onTap,
      onTapDown: (d) => _ctl.forward(),
      onTapUp: (d) => prepareToIdle(),
      onTapCancel: () => prepareToIdle(),
    );
  }

  void prepareToIdle() {
    AnimationStatusListener listener;
    listener = (AnimationStatus statue) {
      if (statue == AnimationStatus.completed) {
        _ctl.removeStatusListener(listener);
        toStart();
      }
    };
    _ctl.addStatusListener(listener);
    if (!_ctl.isAnimating) {
      _ctl.removeStatusListener(listener);
      toStart();
    }
  }

  void toStart() {
    _ctl.stop();
    _ctl.reverse();
  }
}

