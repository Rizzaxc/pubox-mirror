import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../core/pubox_fab.dart';
import '../core/utils.dart';
import 'home_remote_fetch_state_provider.dart';

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
  HomeFAB({super.key});



  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRemoteLoadStateProvider>(
      builder: (context, fetchState, _) {
        final isLoading = fetchState.isLoading;
        return PuboxFab(
          onPressed: _openFullModal,
          isLoading: isLoading,
          icon: Icon(PlatformIcons(context).search,),
        );
      },
    );
  }

  void _openFullModal() {}
}
