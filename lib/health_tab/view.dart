import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../core/sport_switcher.dart';

class HealthTab extends StatefulWidget {
  const HealthTab({super.key});

  @override
  State<HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<HealthTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSportProvider>.value(
      value: SelectedSportProvider.instance,
      child: Scaffold(

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

          body: Center(child: Text('TODO'))),
    );
  }
}
