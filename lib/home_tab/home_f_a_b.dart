import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/anchored_overlay.dart';
import '../core/expandable_fab.dart';

import '../core/utils.dart';

// class HomeFABProvider extends ChangeNotifier {
//   bool _isFullModalOpen = false;
//
//   bool get isFullModalOpen => _isFullModalOpen;
//
//   void openFullModal() {
//     _isFullModalOpen = true;
//     notifyListeners();
//   }
//
//   void closeFullModal() {
//     _isFullModalOpen = false;
//     notifyListeners();
//   }
// }

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final faceIcon = Icon(
      PlatformIcons(context).search,
      color: Colors.white,
      size: 24,
    );

    return ExpandableFAB(
      faceIcon: faceIcon,
      distance: 72,
      children: <ActionButton>[
        ActionButton(
            onPressed: () => context.showToast('pin'),
            icon: Icon(Icons.pin_drop_outlined)),
        ActionButton(
            onPressed: () => context.showToast('cal'),
            icon: Icon(Icons.calendar_month_outlined)),
        ActionButton(
            onPressed: () => context.showToast('fist'),
            icon: Icon(FontAwesomeIcons.handFist)),
      ],
    );
  }

  void _openFullModal() {}
}
