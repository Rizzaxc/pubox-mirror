// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
import 'home_f_a_b.dart';

class HomeTab extends StatefulWidget {
  const HomeTab._();

  static final instance = HomeTab._();

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<SelectedSportProvider>.value(
        value: SelectedSportProvider.instance,
        child: Scaffold(
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
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
        ));
  }
}

class TeammateSection extends StatefulWidget {
  const TeammateSection({super.key});

  @override
  State<TeammateSection> createState() => _TeammateSectionState();
}

class _TeammateSectionState extends State<TeammateSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'Đồng Đội';

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Text(sectionTitle, style:
          Theme.of(context).textTheme.headlineMedium),
          titleSpacing: 4,
          centerTitle: false,
        ),
        SliverList.list(
          children: [
            Card(
              child: Placeholder(),
            ),
            Card(
              child: Placeholder(),
            ),
            // Gap(128)
          ],
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }
}

class ChallengerSection extends StatefulWidget {
  const ChallengerSection({super.key});

  @override
  State<ChallengerSection> createState() => _ChallengerSectionState();
}

class _ChallengerSectionState extends State<ChallengerSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'Đối thủ';

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Text(sectionTitle, style:
          Theme.of(context).textTheme.headlineMedium),
          titleSpacing: 4,
          centerTitle: false,
        ),
        SliverList.list(
          children: [
            Card(
              child: Placeholder(),
            ),
            Card(
              child: Placeholder(),
            ),
            // Gap(128)
          ],
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }
}

class NeutralSection extends StatefulWidget {
  const NeutralSection({super.key});

  @override
  State<NeutralSection> createState() => _NeutralSectionState();
}

class _NeutralSectionState extends State<NeutralSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'Trung gian';

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Text(sectionTitle, style:
          Theme.of(context).textTheme.headlineMedium),
          titleSpacing: 4,
          centerTitle: false,
        ),
        SliverList.list(
          children: [
            Card(
              child: Placeholder(),
            ),
            Card(
              child: Placeholder(),
            ),
            // Gap(128)
          ],
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }
}

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'Địa điểm';

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Text(sectionTitle, style:
          Theme.of(context).textTheme.headlineMedium),
          titleSpacing: 4,
          centerTitle: false,
        ),
        SliverList.list(
          children: [
            Card(
              child: Placeholder(),
            ),
            Card(
              child: Placeholder(),
            ),
            // Gap(128)
          ],
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }
}
