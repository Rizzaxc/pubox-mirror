import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../../core/model/timeslot.dart';
import '../../core/sport_switcher.dart';
import '../model.dart';
import '../state_provider.dart';
import 'teammate_result_item.dart';
import 'teammate_state_provider.dart';

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
    return Consumer<TeammateStateProvider>(builder: (BuildContext context,
        TeammateStateProvider teammateState, Widget? child) {
      return RefreshIndicator(
        onRefresh: context.read<TeammateStateProvider>().refreshData,
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
              state: teammateState.teammatePagingState,
              fetchNextPage: context.read<TeammateStateProvider>().loadTeammate,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, data, index) =>
                    TeammateResultItem(data: data),
                // noItemsFoundIndicatorBuilder: (_) => const Center(
                //   child: Text('No teammates found'),
                // ),
                // firstPageErrorIndicatorBuilder: (_) => const Center(
                //   child: Text('Error loading teammates'),
                // ),
              ),
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
