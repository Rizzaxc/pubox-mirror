import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubox/core/sport_switcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Home'),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.userGroup),
                        iconSize: 16),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.fireFlameCurved),
                        iconSize: 16),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.flagCheckered),
                        iconSize: 16),
                  ],
                )
              ],
            ),
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            ),
            trailing: SportSwitcher.instance,
          ),
          SliverFillRemaining(
              // TODO: content
              )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
