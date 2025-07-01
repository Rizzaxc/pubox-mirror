import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../model.dart';
import 'neutral_state_provider.dart';
import 'professional_result_item.dart';
import 'professional_booking_widget.dart';

class NeutralSection extends StatefulWidget {
  const NeutralSection({super.key});

  @override
  State<NeutralSection> createState() => _NeutralSectionState();
}

class _NeutralSectionState extends State<NeutralSection>
    with AutomaticKeepAliveClientMixin {
  static const l10nKeyPrefix = 'homeTab';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<NeutralStateProvider>(
      builder: (context, state, child) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(() => state.refresh()),
          child: CustomScrollView(
            slivers: [
              // Section Header
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(context.tr('$l10nKeyPrefix.neutral.title'),
                    style: Theme.of(context).textTheme.headlineMedium),
                titleSpacing: 4,
                centerTitle: false,
                pinned: false,
                primary: false,
                actions: [
                  // Filter button for coach/referee
                  PopupMenuButton<ProfessionalRole?>(
                    icon: Icon(
                      state.selectedRole == null
                          ? Icons.filter_list_outlined
                          : Icons.filter_list,
                    ),
                    onSelected: (role) => state.setRoleFilter(role),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: null,
                        child: Text(
                            context.tr('$l10nKeyPrefix.neutral.filter.all')),
                      ),
                      PopupMenuItem(
                        value: ProfessionalRole.coach,
                        child: Text(
                            context.tr('$l10nKeyPrefix.neutral.filter.coach')),
                      ),
                      PopupMenuItem(
                        value: ProfessionalRole.referee,
                        child: Text(
                            context.tr('$l10nKeyPrefix.neutral.filter.referee')),
                      ),
                    ],
                  ),
                ],
              ),

              // Professional List
              // PagedSliverList<int, ProfessionalModel>(
              //   state: state.professionalPagingState,
              //   fetchNextPage: state.loadData,
              //   builderDelegate: PagedChildBuilderDelegate(
              //     itemBuilder: (context, professional, index) {
              //       return ProfessionalResultItem(
              //         professional: professional,
              //         onBookingTap: () =>
              //             _showBookingModal(context, professional),
              //       );
              //     },
              //     noItemsFoundIndicatorBuilder: (context) =>
              //         _buildEmptyState(context),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PuboxIcons.coach,
            const SizedBox(height: 16),
            Text(
              context.tr('$l10nKeyPrefix.neutral.empty.title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('$l10nKeyPrefix.neutral.empty.message'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingModal(BuildContext context, ProfessionalModel professional) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      builder: (context) =>
          ProfessionalBookingWidget(professional: professional),
    );
  }
}
