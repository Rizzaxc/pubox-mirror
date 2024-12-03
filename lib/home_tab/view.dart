import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class HomeTab extends StatefulWidget {
  const HomeTab._();
  static final instance = HomeTab._();

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final TabController _tabController;

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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: homeSections,
          dividerHeight: 0,
          // padding: EdgeInsets.all(1),
        ),
        Gap(32),
        Expanded(
            child: TabBarView(controller: _tabController, children: [
          TeammateSection(),
          ChallengerSection(),
          NeutralSection(),
          LocationSection()
        ]))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TeammateSection extends StatefulWidget {
  const TeammateSection({super.key});

  @override
  State<TeammateSection> createState() => _TeammateSectionState();
}

class _TeammateSectionState extends State<TeammateSection> {
  late final ScrollController _scrollController;

  static const sectionTitle = Text(
    'Đồng đội',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
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
            Gap(128)
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
  late final ScrollController _scrollController;

  static const sectionTitle = Text(
    'Đối thủ',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
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
            Gap(128)
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
  late final ScrollController _scrollController;

  static const sectionTitle = Text(
    'Trung gian',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
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
            Gap(128)
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
  late final ScrollController _scrollController;

  static const sectionTitle = Text(
    'Địa điểm',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
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
            Gap(128)
          ],
        ),
      ],
    );
  }
}
