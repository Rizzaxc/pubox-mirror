// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
import 'challenger_section/challenger_section.dart';
import 'home_f_a_b.dart';
import 'location_section/location_section.dart';
import 'model.dart';
import 'neutral_section/neutral_section.dart';
import 'state_provider.dart';
import 'teammate_section/teammate_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab._({this.initialTabIndex = 0})
      : assert(initialTabIndex >= 0 && initialTabIndex <= 3,
            'initialTabIndex must be between 0 and 3');

  /// The index of the tab to display initially.
  /// Must be a value between 0 and 3, inclusive.
  final int initialTabIndex;

  static final instance = HomeTab._();

  static HomeTab withInitialTab(int initialTabIndex) {
    return HomeTab._(initialTabIndex: initialTabIndex);
  }

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  static const homeSections = <Widget>[
    Tab(
      icon: Icon(
        CupertinoIcons.person_2_fill,
        size: 28,
      ),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.fireFlameCurved),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.flagCheckered),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.shieldHalved),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: PlatformText('Home'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: PlatformIconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_active_outlined,
            size: 24,
          ),
        ),
        actions: [SportSwitcher.instance],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 8),
                sliver: SliverAppBar(
                  toolbarHeight: 8,
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: homeSections,
                    labelColor: Colors.white,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 1),
                    splashBorderRadius: BorderRadius.circular(16),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            TeammateSection(),
            ChallengerSection(),
            NeutralSection(),
            LocationSection()
          ]),
        ),
      ),
    );
  }
}
