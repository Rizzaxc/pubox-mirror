import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../model.dart';
import '../state_provider.dart';

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
              fetchNextPage: Provider.of<HomeStateProvider>(context).loadTeammate,
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

class TeammateResultItem extends StatelessWidget {
  const TeammateResultItem({super.key, required this.data});

  final TeammateModel data;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Placeholder();
  }
}
