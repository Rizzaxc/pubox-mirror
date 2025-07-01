import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VenueSection extends StatefulWidget {
  const VenueSection({super.key});

  @override
  State<VenueSection> createState() => _VenueSectionState();
}

class _VenueSectionState extends State<VenueSection>
    with AutomaticKeepAliveClientMixin {
  static const l10nKeyPrefix = 'homeTab';

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
          title: Text(context.tr('$l10nKeyPrefix.venue.title'),
              style: Theme.of(context).textTheme.headlineMedium),
          titleSpacing: 4,
          centerTitle: false,
          pinned: false,
          primary: false,
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
