
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class PuboxIconData {
  static const Widget soccer =
  SvgPicture(
      AssetBytesLoader('./assets/icons/soccer.svg.vec'));

  static const Widget basketball =
  SvgPicture(
      AssetBytesLoader('./assets/icons/basketball.svg.vec'));

  static const Widget tennis =
  SvgPicture(
      AssetBytesLoader('./assets/icons/tennis.svg.vec'));

  static const Widget badminton =
  SvgPicture(
      AssetBytesLoader('./assets/icons/badminton.svg.vec'));
}


class SportIcons {
  static SizedBox soccer({double size = 16}) {
    return SizedBox.fromSize(size: Size.fromRadius(size),
        child: PuboxIconData.soccer);
  }

  static SizedBox basketball({double size = 16}) {
    return SizedBox.fromSize(size: Size.fromRadius(size),
        child: PuboxIconData.basketball);
  }

  static SizedBox tennis({double size = 16}) {
    return SizedBox.fromSize(size: Size.fromRadius(size),
        child: PuboxIconData.tennis);
  }

  static SizedBox badminton({double size = 16}) {
    return SizedBox.fromSize(size: Size.fromRadius(size),
        child: PuboxIconData.badminton);
  }
}