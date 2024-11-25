import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: 'Đồng đội',
              icon: Icon(FontAwesomeIcons.handshake),
            ),
            Tab(
              text: 'Đối thủ',
              icon: Icon(FontAwesomeIcons.fireFlameCurved),
            ),
            Tab(
              text: 'Trung lập',
              icon: Icon(FontAwesomeIcons.flagCheckered),
            ),
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
