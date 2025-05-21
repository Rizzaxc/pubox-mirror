import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../model.dart';
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
        onRefresh: () =>
            context.read<TeammateStateProvider>().loadData(isRefresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              title: Text(sectionTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              titleSpacing: 4,
              centerTitle: false,
              pinned: false,
              primary: false,
            ),
            PagedSliverList<int, TeammateModel>(
              state: teammateState.teammatePagingState,
              fetchNextPage: context.read<TeammateStateProvider>().loadData,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, data, index) =>
                    TeammateResultItem(data: data),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        const SizedBox(height: 4,),
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          'No results found',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Try adjusting your preferences or check back later',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 64),

                      ],
                    ),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        const SizedBox(height: 4,),
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        Text(
                          'Error loading teammates',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          context.read<TeammateStateProvider>().teammatePagingState.error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.read<TeammateStateProvider>().loadData(isRefresh: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Retry'),
                        ),
                        const SizedBox(height: 64),

                      ],
                    ),
                  ),
                ),
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
