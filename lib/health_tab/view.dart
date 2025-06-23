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
        actions: [
          SportSwitcher.instance
        ],
      ),
      // TODO: provide context & redirect to /profile/auth

      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) {
          if (playerProvider.id == null) {
            // TODO: provide context & redirect to /profile/auth
            return const Placeholder();
          }
          return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${playerProvider.username}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 4),
                  Chip(
                    label: Text(
                      '#${playerProvider.tagNumber}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade700,
                        height: 0.8,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ));
        },
      ),
    );
  }
}
