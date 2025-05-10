import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../core/model/enum.dart';
import '../core/tag_carousel.dart';
import 'state_provider.dart';
import 'teammate_section/teammate_state_provider.dart';
import 'timeslot_selection.dart';

class HomeSearchPage extends StatelessWidget {
  static var borderRadius = BorderRadius.circular(8);
  static const borderRadiusVal = Radius.circular(8);

  HomeSearchPage({
    super.key,
  });

  final searchBarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateProvider>(
      builder: (context, stateProvider, _) {
        final city = stateProvider.city;
        final districts = stateProvider.districts;

        return Material(
          child: GestureDetector(
            onTap: () => searchBarFocusNode.hasFocus
                ? searchBarFocusNode.unfocus()
                : null,
            onVerticalDragStart: (_) => searchBarFocusNode.hasFocus
                ? searchBarFocusNode.unfocus()
                : null,
            onHorizontalDragStart: (_) => searchBarFocusNode.hasFocus
                ? searchBarFocusNode.unfocus()
                : null,
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
                      Column(
                        spacing: 8,
                        children: [
                          Row(
                            children: [
                              Icon(PlatformIcons(context).locationSolid),
                              Text('Khu Vực',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          Card(
                            child: Column(
                              children: [
                                PlatformPopupMenu(
                                    material: (_, __) => MaterialPopupMenuData(
                                        position: PopupMenuPosition.under,
                                        padding: EdgeInsets.zero,
                                        splashRadius: 32,
                                        constraints:
                                            BoxConstraints(maxWidth: 128),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            side: BorderSide(
                                                color: Colors.grey.shade200)),
                                        popUpAnimationStyle: AnimationStyle(
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 250))),
                                    cupertino: (_, __) =>
                                        CupertinoPopupMenuData(
                                          title: Text(
                                            'Thành Phố',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    icon: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade800,
                                          borderRadius: BorderRadius.only(
                                              topLeft: HomeSearchPage
                                                  .borderRadiusVal,
                                              topRight: HomeSearchPage
                                                  .borderRadiusVal)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.location_city,
                                                color: Colors.white),
                                            Text(
                                              city.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    options: City.values
                                        .map((each) => PopupMenuOption(
                                              label: each.shorthand,
                                              material: (_, __) =>
                                                  MaterialPopupMenuOptionData(
                                                      child: Text(each.name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge)),
                                              cupertino: (_, __) =>
                                                  CupertinoPopupMenuOptionData(
                                                      child: Text(each.name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge)),
                                              onTap: (_) {
                                                stateProvider.updateCity(
                                                    City.fromShorthand(
                                                        each.shorthand));
                                              },
                                            ))
                                        .toList()),
                                const SizedBox(height: 8),
                                TagCarousel(
                                  height: 80,
                                  tagLabels: VietnamLocationData.instance
                                      .getDistrictsByCity(city)
                                      .map((e) => e.fullName)
                                      .toList(),
                                  initialSelection: districts,
                                  onSelectionChanged: (selectedDistricts) {
                                    stateProvider
                                        .updateDistricts(selectedDistricts);
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const TimeslotSelection(),
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
    Future.wait([context.read<TeammateStateProvider>().loadData()]);
  }
}
