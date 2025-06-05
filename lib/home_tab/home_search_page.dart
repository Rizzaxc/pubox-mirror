import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/model/enum.dart';
import '../core/tag_carousel.dart';
import 'state_provider.dart';
import 'teammate_section/teammate_state_provider.dart';
import 'widget/location_selection.dart';
import 'widget/timeslot_selection.dart';

class HomeSearchPage extends StatelessWidget {
  static var borderRadius = BorderRadius.circular(16);
  static const borderRadiusVal = Radius.circular(16);

  HomeSearchPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final searchBarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateProvider>(
      builder: (context, stateProvider, _) {
        final city = stateProvider.city;
        final districts = stateProvider.districts;

        return SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          hitTestBehavior: HitTestBehavior.translucent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Material(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 512),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 32,
                    children: [
                      PlatformSearchBar(
                        focusNode: searchBarFocusNode,
                        keyboardType: TextInputType.text,
                        hintText: 'FriendID hoặc InviteCode',
                        cupertino: (_, __) => CupertinoSearchBarData(
                          itemSize: 16,
                          autocorrect: false,
                        ),
                      ),
                      LocationSelection(),
                      TimeslotSelection(
                        initialSelection: stateProvider.timeSlots,
                        onSelectionChanged: (selectedTimeslots) {
                          stateProvider.updateTimeslots(selectedTimeslots);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: PlatformElevatedButton(
                      onPressed: () => refreshData(context),
                      color: Colors.green.shade600,
                      cupertino: (_, __) => CupertinoElevatedButtonData(
                          borderRadius: BorderRadius.all(Radius.circular(32))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PlatformText(
                            'Refresh',
                          ),
                          Icon(PlatformIcons(context).refreshBold),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void refreshData(BuildContext context) {
    // Commit the selection before calling subtabs' loadData
    context.read<HomeStateProvider>().commit();

    context.read<TeammateStateProvider>().loadData(isRefresh: true);
    // TODO:
    // context.read<ChallengerStateProvider>().loadData(isRefresh: true);
    // context.read<NeutralStateProvider>().loadData(isRefresh: true);
    // context.read<LocationStateProvider>().loadData(isRefresh: true);

    context.pop();
  }
}
