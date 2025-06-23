import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../core/pubox_fab.dart';
import '../core/sport_switcher.dart';
import 'home_search_page.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return PuboxFab(
      onPressed: () => _openFullModal(context),
      icon: Icon(
        PlatformIcons(context).search,
      ),
    );
  }

  void _openFullModal(BuildContext context) {

    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      cupertino: CupertinoModalSheetData(
          barrierDismissible: true, semanticsDismissible: true),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        snap: true,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: HomeSearchPage(scrollController: scrollController),
        ),
      ),
    );
  }
}
