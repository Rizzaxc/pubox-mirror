import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pubox/core/sport_switcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../core/player.dart';
import '../core/utils.dart';
import '../welcome_flow/auth_form.dart';
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
      if (context.read<Player>().id == null) {
        _showAuthFormModal(context);
      }
    });
  }

  void _showAuthFormModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      isDismissible: false,
      expand: true,
      builder: (BuildContext context) {
        return const AuthForm();
      },
    );
  }

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
            if (player.id == null) return const EmptyPage();
            return Center(child: const Text('Quản Lý'));
          },
        ),
      ),
    );
  }
}
