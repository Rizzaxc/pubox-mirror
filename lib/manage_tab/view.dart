import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubox/core/sport_switcher.dart';

import '../core/player.dart';
import '../core/utils.dart';
import '../welcome_flow/auth_form.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({super.key});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSport>.value(
      value: SelectedSport.instance,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản Lý'),
          centerTitle: true,
          scrolledUnderElevation: 0,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active_outlined)),
          actions: [SportSwitcher.instance],
        ),
        body: Consumer<Player>(
          builder: (context, player, _) {
            if (player.id == null) {
              return AuthForm();
            }
            return const Text('Quản Lý');
          },
        ),
      ),
    );
  }
}
