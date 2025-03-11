import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../core/pubox_fab.dart';
import '../core/utils.dart';
import 'home_search_page.dart';
import 'state_provider.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateProvider>(
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
          barrierDismissible: true, semanticsDismissible: true),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.7,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            controller: scrollController,
            child: HomeSearchPage(
              city: Provider.of<HomeStateProvider>(context, listen: false).city,
              districts: Provider.of<HomeStateProvider>(context, listen: false).districts,
            ),
          ),
        ),
      ),
    );
  }
}
