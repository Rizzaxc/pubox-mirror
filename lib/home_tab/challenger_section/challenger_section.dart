import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChallengerSection extends StatefulWidget {
  const ChallengerSection({super.key});

  @override
  State<ChallengerSection> createState() => _ChallengerSectionState();
}

class _ChallengerSectionState extends State<ChallengerSection>
    with AutomaticKeepAliveClientMixin {
  static const sectionTitle = 'TODO'; // homeTab.challenger.title

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
          title: Text('TODO', // homeTab.challenger.title
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
