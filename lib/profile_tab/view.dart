import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSportProvider>.value(
      value: SelectedSportProvider.instance,
      child: Scaffold(
        appBar: AppBar(
          title: PlatformText('Hồ Sơ'),
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
            SportSwitcher.instance,
            IconButton(
                onPressed: () async {
                  if (context.read<PlayerProvider>().player.id == null) {
                    context.go('/welcome');
                    return;
                  }
                  await supabase.auth.signOut();
                  if (context.mounted) {
                    context.go('/welcome');
                  }
                },
                icon: Icon(Icons.exit_to_app_rounded))
          ],
        ),
        body: Center(
          child: Text('Profile Tab'),
        ),
      ),
    );
  }
}
