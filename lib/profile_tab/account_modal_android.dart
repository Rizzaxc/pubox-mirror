import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../core/player_provider.dart';
import '../core/user_preferences.dart';
import '../core/utils.dart';
import 'avatar/pubox_avatar.dart';

/// Android-specific implementation of the account modal
class AccountModalAndroid extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final VoidCallback onSubmit;
  final ScrollController? scrollController;

  const AccountModalAndroid({
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Avatar with PuboxAvatar
              PuboxAvatar(
                username: playerProvider.username,
                radius: 60,
                onTap: () {
                  // TODO: Implement avatar change functionality
                  context.showToast('Avatar change functionality coming soon',
                    type: ToastificationType.info);
                },
              ),
              const SizedBox(height: 24),

              // User info as ListTiles
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Username with Tag Number as trailing
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Username'),
                      subtitle: Text(playerProvider.username),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${playerProvider.tagNumber}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Divider(height: 1),

                    // Email
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(supabase.auth.currentUser?.email ?? 'No Email'),
                      trailing: const Icon(Icons.lock_outline, color: Colors.grey),
                      enabled: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Account actions
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Change Password
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to change password screen
                        context.showToast('Navigate to change password screen',
                            type: ToastificationType.info);
                      },
                    ),
                    const Divider(height: 1),

                    // Logout
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Log Out', style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Log Out?'),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('No'),
                              ),
                              TextButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
