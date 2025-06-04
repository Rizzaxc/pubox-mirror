import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../core/model/enum.dart';
import '../core/model/user_details.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
import 'profile_state_provider.dart';
import 'widget/age_group_selection.dart';
import 'widget/fitness_selection.dart';
import 'widget/gender_selection.dart';
import 'widget/position_selection.dart';
import 'widget/skill_selection.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Widget _buildAccountSection(BuildContext context) {
    final player = context.watch<PlayerProvider>().player;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text('Account',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('${player.username}#${player.tagNumber}'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))

                // TODO: Add onTap to edit username
                ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(supabase.auth.currentUser?.email ?? 'No Email'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // TODO: Add onTap to change email
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Đổi Password'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                // TODO: Navigate to change password screen
                context.showToast('Navigate to change password screen',
                    type: ToastificationType.info);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade700),
              title: Text('Sign Out',
                  style: TextStyle(color: Colors.red.shade700)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () async {
                await supabase.auth.signOut();
                if (context.mounted) {
                  context.go('/welcome');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final selectedSport = context.watch<SelectedSportProvider>().self;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text('Profile ${selectedSport.name.capitalize()}',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const Divider(),
            const GenderSelection(),
            const AgeGroupSelection(),
            const SkillSelection(),
            const FitnessSelection(),
            const PositionSelection(),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Playtime'),
              subtitle: const Text('Not set'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                // TODO: Create a PlaytimeSelection widget
              },
            ),
            // Add save/cancel buttons if there are pending changes
            Consumer<ProfileStateProvider>(
              builder: (context, profileState, child) {
                if (!profileState.hasPendingChanges) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          profileState.discardChanges();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          profileState.commit();
                          context.showToast('Profile updated',
                              type: ToastificationType.success);
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text('Network & Industry',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Industry'),
              subtitle: const Text('Not set'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                // TODO: Edit industry
              },
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Networks (School, Company)'),
              subtitle: const Text('Not set'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onTap: () {
                // TODO: Edit networks
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final playerProvider = context.read<PlayerProvider>();
    final sportProvider = context.read<SelectedSportProvider>();

    return ChangeNotifierProvider(
      create: (context) => ProfileStateProvider(playerProvider, sportProvider),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildAccountSection(context),
              const SizedBox(height: 16),
              _buildProfileSection(context),
              const SizedBox(height: 16),
              _buildNetworkSection(context),
              const SizedBox(height: 120), // For FAB spacing
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();

    Widget body; // Variable to hold the body content

    // Check if we need to show loading or redirect
    if (playerProvider.loading || playerProvider.player.id == null) {
      // If user is not logged in and not currently loading, schedule redirect.
      if (playerProvider.player.id == null && !playerProvider.loading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final currentRoute = GoRouter.of(context)
                .routerDelegate
                .currentConfiguration
                .uri
                .toString();
            if (currentRoute != '/profile/auth' && currentRoute != '/welcome') {
              context.go('/profile/auth');
            }
          }
        });
      }
      // Show loading indicator for both loading and redirecting states
      body = const Center(child: CircularProgressIndicator());
    } else {
      // Show the main profile content
      body = _buildMainContent(context);
    }

    // Return a single Scaffold with a consistent AppBar
    return Scaffold(
      appBar: AppBar(
        title: PlatformText('Hồ Sơ'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: PlatformIconButton(
          onPressed: () {
            // TODO: Handle notification tap
          },
          icon: const Icon(
            Icons.notifications_active_outlined,
            size: 24,
          ),
        ),
        actions: [
          SportSwitcher.instance, // Keep SportSwitcher in actions
        ],
      ),
      body: body, // Use the determined body widget
    );
  }
}
