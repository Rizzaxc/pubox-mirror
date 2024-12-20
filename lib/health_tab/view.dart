import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubox/core/sport_switcher.dart';

class HealthTab extends StatefulWidget {
  const HealthTab({super.key});

  @override
  State<HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<HealthTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSport>.value(
      value: SelectedSport.instance,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Sức Khoẻ'),
            centerTitle: true,
            scrolledUnderElevation: 0,
            leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_active_outlined)),
            actions: [SportSwitcher.instance],
          ),
          body: Center(child: Text('TODO'))),
    );
  }
}
