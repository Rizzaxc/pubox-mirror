import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/player.dart';
import '../core/sport_switcher.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSport>.value(
      value: SelectedSport.instance,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hồ Sơ'),
          centerTitle: true,
          scrolledUnderElevation: 0,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active_outlined)),
          actions: [
            SportSwitcher.instance,
            IconButton(
                onPressed: () async {
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
