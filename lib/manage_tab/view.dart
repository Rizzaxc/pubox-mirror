import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (supabase.auth.currentUser == null) {
        context.showToast('Bạn chưa đăng nhập', type: ToastificationType.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedSportProvider>.value(
      value: SelectedSportProvider.instance,
      child: Scaffold(
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
            final player = playerProvider.player;
            if (player.id == null) {
              return const EmptyPage();
            }
            return Center(
                child: Text('Welcome ${player.username}@${player.tagNumber}'));
          },
        ),
      ),
    );
  }
}
