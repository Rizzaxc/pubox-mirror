import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import 'empty_page.dart';
import 'schedule_section/schedule_section.dart';
import 'lobby_section/lobby_section.dart';
import 'schedule_section/schedule_state_provider.dart';
import 'lobby_section/lobby_state_provider.dart';

const manageSections = <Widget>[
  Tab(
    icon: Icon(
      Icons.calendar_today,
      size: 28,
    ),
  ),
  Tab(
    icon: Icon(
      Icons.group,
      size: 28,
    ),
  ),
];

class ManageTab extends StatefulWidget {
  const ManageTab({super.key});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const l10nKeyPrefix = 'manageTab';

  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Text(context.tr('$l10nKeyPrefix.title')),
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
        actions: [
          SportSwitcher.instance
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Consumer<PlayerProvider>(
          builder: (context, playerProvider, _) {
            if (playerProvider.id == null) {
              // TODO: provide context & redirect to /profile/auth
              return const EmptyPage();
            }

            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 8),
                    sliver: SliverAppBar(
                      toolbarHeight: 8,
                      bottom: TabBar(
                        controller: _tabController,
                        tabs: manageSections,
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
              body: TabBarView(
                controller: _tabController,
                children: const [
                  ScheduleSection(),
                  LobbySection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
