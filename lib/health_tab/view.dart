import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';

class HealthTab extends StatefulWidget {
  const HealthTab({super.key});

  @override
  State<HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<HealthTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PlatformText('Health'),
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
      // TODO: provide context & redirect to /profile/auth

      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) {
          final player = playerProvider.player;
          if (player.id == null) {
            // TODO: provide context & redirect to /profile/auth
            return const Placeholder();
          }
          return Center(
              child: Text('Welcome ${player.username}@${player.tagNumber}'));
        },
      ),
    );
  }
}
