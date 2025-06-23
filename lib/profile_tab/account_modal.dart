import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toastification/toastification.dart';

import '../core/player_provider.dart';
import '../core/utils.dart';
import 'avatar/pubox_avatar.dart';
import 'account_modal_android.dart';
import 'account_modal_ios.dart';
import 'profile_state_provider.dart';

/// A modal that displays the user's account information and allows them to
/// change their avatar, username, password, and logout.
class AccountModal extends StatefulWidget {
  const AccountModal({super.key});

  @override
  State<AccountModal> createState() => _AccountModalState();
}

class _AccountModalState extends State<AccountModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateUserAccountData(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileStateProvider>().updateUserAccountData(username: _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        // Use platform-specific implementation based on the current platform
        if (isCupertino(context)) {
          return AccountModalIOS(
            formKey: _formKey,
            usernameController: _usernameController,
            onSubmit: () => _updateUserAccountData,
            scrollController: scrollController,
          );
        } else {
          return AccountModalAndroid(
            formKey: _formKey,
            usernameController: _usernameController,
            onSubmit: () => _updateUserAccountData,
            scrollController: scrollController,
          );
        }
      },
    );
  }
}
