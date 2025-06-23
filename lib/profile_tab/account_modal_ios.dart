import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../core/player_provider.dart';
import '../core/user_preferences.dart';
import '../core/utils.dart';
import 'avatar/pubox_avatar.dart';

/// iOS-specific implementation of the account modal
class AccountModalIOS extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final VoidCallback onSubmit;
  final ScrollController? scrollController;

  const AccountModalIOS({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.onSubmit,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Avatar with PuboxAvatar
              PuboxAvatar(
                username: playerProvider.username,
                onTap: () {
                  // TODO: Implement avatar change functionality
                  context.showToast('Avatar change functionality coming soon',
                    type: ToastificationType.info);
                },
              ),
              const SizedBox(height: 24),

              // User info section
              CupertinoListSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  // Username with Tag Number
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.person),
                    title: Text(playerProvider.username),
                    // subtitle: const Text('Username'),
                    subtitle: Text('#${playerProvider.tagNumber}'),
                    onTap: () {},
                  ),

                  // Email
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.mail),
                    title: Text(supabase.auth.currentUser?.email ?? 'No Email'),
                    subtitle: const Text('Email'),
                    trailing: const Icon(CupertinoIcons.lock, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Account actions
              CupertinoListSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  // Change Password
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.lock),
                    title: const Text('Change Password'),
                    trailing: const Icon(CupertinoIcons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to change password screen
                      context.showToast('Navigate to change password screen',
                          type: ToastificationType.info);
                    },
                  ),

                  // Logout
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.square_arrow_right, color: CupertinoColors.destructiveRed),
                    title: const Text('Log Out', style: TextStyle(color: CupertinoColors.destructiveRed)),
                    onTap: () async {
                      showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Confirm Log Out?'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => context.pop(),
                              child: const Text('No'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () async {
                                // Clear user-specific data before signing out
                                await UserPreferences.instance.clearUserData();
                                await supabase.auth.signOut();
                                if (context.mounted) {
                                  context.go('/welcome');
                                  context.pop();
                                }
                              },
                              child: const Text('Yes'),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
