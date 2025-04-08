import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../../core/model/timeslot.dart';
import '../model.dart';
import '../state_provider.dart';
import 'teammate_result_item.dart';

class TeammateSection extends StatefulWidget {
  const TeammateSection({super.key});

  @override
  State<TeammateSection> createState() => _TeammateSectionState();
}

class _TeammateSectionState extends State<TeammateSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'Đồng Đội';

  final ScrollController _scrollController = ScrollController();

  final List<TeammateModel> _mockTeammates = [
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "gamer9999",
      location: ["New York", "USA"],
      playtime: Timeslot(DayOfWeek.monday, DayChunk.noon),
      details: {
        "skill": "Expert",
        "games": ["Valorant", "CS:GO"]
      },
      compatScore: 0.92,
      searchableId: "gp99_12345",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.lobby,
      resultTitle: "Weekend Warriors",
      location: ["Online", "Global"],
      playtime: Timeslot(DayOfWeek.saturday, DayChunk.night),
      details: {
        "players": 6,
        "games": ["Apex Legends"]
      },
      compatScore: 0.78,
      searchableId: "ww_lobby_67890",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "CasualGamer42",
      location: ["London", "UK"],
      playtime: Timeslot(DayOfWeek.even, DayChunk.early),
      details: {
        "skill": "Intermediate",
        "games": ["Fortnite", "Rocket League"]
      },
      compatScore: 0.65,
      searchableId: "cg42_54321",
    ),
  ];

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
    return Consumer<HomeStateProvider>(builder:
        (BuildContext context, HomeStateProvider homeState, Widget? child) {
      return RefreshIndicator(
        onRefresh: Provider.of<HomeStateProvider>(context).refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              title: Text(sectionTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              titleSpacing: 4,
              centerTitle: false,
            ),
            PagedSliverList<int, TeammateModel>(
              state: homeState.teammatePagingState,
              fetchNextPage:
                  Provider.of<HomeStateProvider>(context).loadTeammate,
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, data, index) =>
                      TeammateResultItem(data: data)),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 128),
            ),
          ],
        ),
      );
    });
  }
}
