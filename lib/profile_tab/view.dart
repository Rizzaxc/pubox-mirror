import 'package:flutter/material.dart';

import '../core/sport_switcher.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        scrolledUnderElevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active_outlined)),
        actions: [SportSwitcher.instance],
      ),
      body: Center(
        child: Text('Profile Tab'),
      ),
    );
  }
}
