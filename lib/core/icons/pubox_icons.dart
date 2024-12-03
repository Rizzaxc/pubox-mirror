// Place fonts/PuboxIcons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: PuboxIcons
//      fonts:
//       - asset: fonts/PuboxIcons.ttf
import 'package:flutter/widgets.dart';

class PuboxIcons {
  PuboxIcons._();

  static const String _fontFamily = 'PuboxIcons';

  static const IconData group = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData profile = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData heartPulse = IconData(0xe901, fontFamily: _fontFamily);
}
