import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:pubox/core/expandable_fab.dart';

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
      children: [
        ActionButton(
          onPressed: () => context.showToast('location'),
          icon: const Icon(Icons.pin_drop_outlined),
        ),
        ActionButton(
          onPressed: () => context.showToast('schedule'),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        ActionButton(
          onPressed: () => context.showToast('skill'),
          icon: const Icon(FontAwesomeIcons.handFist),
        ),
      ],
    );
  }

  void _openSubMenu() {}

  void _openFullModal() {}
}
