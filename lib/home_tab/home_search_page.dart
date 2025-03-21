import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

import '../core/model/enum.dart';
import '../core/tag_carousel.dart';
import 'model.dart';
import 'state_provider.dart';

class HomeSearchPage extends StatefulWidget {
  final City city;
  final List<String> districts;

  const HomeSearchPage({
    super.key,
    required this.city,
    required this.districts,
  }) : assert(districts.length < 4);

  static var borderRadius = BorderRadius.circular(8);
  static const borderRadiusVal = Radius.circular(8);

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  late City _city;
  late List<String> _districts;

  @override
  void initState() {
    super.initState();

    _city = widget.city;
    _districts = widget.districts;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                    keyboardType: TextInputType.text,
                    hintText: 'Search FriendID hoặc InviteCode',
                    cupertino: (_, __) => CupertinoSearchBarData(
                      itemSize: 24,
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
                              style: Theme.of(context).textTheme.titleMedium),
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
                                    constraints: BoxConstraints(maxWidth: 128),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                            color: Colors.grey.shade200)),
                                    popUpAnimationStyle: AnimationStyle(
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 250))),
                                cupertino: (_, __) => CupertinoPopupMenuData(
                                      title: Text(
                                        'Thành Phố',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                icon: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      borderRadius: BorderRadius.only(
                                          topLeft:
                                              HomeSearchPage.borderRadiusVal,
                                          topRight:
                                              HomeSearchPage.borderRadiusVal)),
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
                                          _city.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge)),
                                          cupertino: (_, __) =>
                                              CupertinoPopupMenuOptionData(
                                                  child: Text(each.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge)),
                                          onTap: (_) {
                                            setState(() {
                                              _city = City.fromShorthand(
                                                  each.shorthand);
                                            });
                                          },
                                        ))
                                    .toList()),
                            const SizedBox(height: 8),
                            TagCarousel(
                                height: 80,
                                tagLabels: VietnamLocationData.instance.getDistrictsByCity(_city).map((e) => e.fullName).toList())
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              PlatformElevatedButton(
                onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
