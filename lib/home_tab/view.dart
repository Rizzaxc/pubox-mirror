import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pubox/core/sport_switcher.dart';
import 'package:pubox/core/utils.dart';
import 'package:pubox/home_tab/home_f_a_b.dart';

class HomeTab extends StatefulWidget {
  const HomeTab._();

  static final instance = HomeTab._();

  // static const title = 'Home';
  static final fab = HomeFAB();

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
    return ChangeNotifierProvider<SelectedSport>.value(
        value: SelectedSport.instance,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: true,
            scrolledUnderElevation: 0,
            leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_active_outlined)),
            actions: [SportSwitcher.instance],
          ),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  toolbarHeight: 8,
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: homeSections,
                    dividerHeight: 0,
                  ),
                ),
                // const SliverGap(16),
                // SliverPadding(padding: 16),
              ];
            },
            body: TabBarView(controller: _tabController, children: [
              TeammateSection(),
              ChallengerSection(),
              NeutralSection(),
              LocationSection()
            ]),
          ),
        ));
  }
}

class TeammateSection extends StatefulWidget {
  const TeammateSection({super.key});

  @override
  State<TeammateSection> createState() => _TeammateSectionState();
}

class _TeammateSectionState extends State<TeammateSection> {
  static const sectionTitle = Text(
    'Đồng đội',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: sectionTitle,
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
      ],
    );
  }
}

class ChallengerSection extends StatefulWidget {
  const ChallengerSection({super.key});

  @override
  State<ChallengerSection> createState() => _ChallengerSectionState();
}

class _ChallengerSectionState extends State<ChallengerSection> {
  static const sectionTitle = Text(
    'Đối thủ',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: sectionTitle,
          floating: false,
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
      ],
    );
  }
}

class NeutralSection extends StatefulWidget {
  const NeutralSection({super.key});

  @override
  State<NeutralSection> createState() => _NeutralSectionState();
}

class _NeutralSectionState extends State<NeutralSection> {
  static const sectionTitle = Text(
    'Trung gian',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: sectionTitle,
          floating: false,
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
      ],
    );
  }
}

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  static const sectionTitle = Text(
    'Địa điểm',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: sectionTitle,
          floating: false,
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
      ],
    );
  }
}
