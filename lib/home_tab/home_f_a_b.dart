import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../core/pubox_fab.dart';
import '../core/utils.dart';
import 'home_remote_fetch_state_provider.dart';
import 'home_search_page.dart';

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
          onPressed: () => _openFullModal(context),
          isLoading: isLoading,
          icon: Icon(
            PlatformIcons(context).search,
          ),
        );
      },
    );
  }

  void _openFullModal(BuildContext context) {
    // open a modal
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      cupertino: CupertinoModalSheetData(
        barrierDismissible: true,
        semanticsDismissible: true
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.70,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 8,
              right: 8),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: HomeSearchPage(), controller: scrollController,),
        ),
      ),
    );
  }
}
