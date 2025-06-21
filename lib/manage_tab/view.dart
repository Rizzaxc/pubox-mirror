import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import 'empty_page.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({super.key});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PlatformText('Quản Lý'),
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
        actions: [SportSwitcher.instance],
      ),
      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, _) {
          if (playerProvider.id == null) {
            // TODO: provide context & redirect to /profile/auth
            return const EmptyPage();
          }
          return Center(
              child: Text('Welcome ${playerProvider.username}@${playerProvider.tagNumber}'));
        },
      ),
    );
  }
}
