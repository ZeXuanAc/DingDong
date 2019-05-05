import 'gender_styles.dart';
import 'package:dingdong_flutter/page/gender/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderArrow extends AnimatedWidget {
  const GenderArrow({Key key, Listenable listenable})
      : super(key: key, listenable: listenable);

  double _arrowLength(BuildContext context) => screenAwareSize(32.0, context);

  double _translationOffset(BuildContext context) =>
      _arrowLength(context) * -0.4;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Transform.rotate(
      angle: animation.value,
      child: Transform.translate(
        offset: Offset(0.0, _translationOffset(context)),
        child: Transform.rotate(
          angle: -defaultGenderAngle,
          child: SvgPicture.asset(
            "assets/images/gender_arrow.svg",
            height: _arrowLength(context),
            width: _arrowLength(context),
          ),
        ),
      ),
    );
  }
}
