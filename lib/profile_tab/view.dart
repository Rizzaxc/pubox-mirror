import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart'; // Assuming this imports supabase and context.showToast

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text('Username: ${player.username}#${player.tagNumber}'),
              // TODO: Add onTap to edit username
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(supabase.auth.currentUser?.email ?? 'No Email'),
              // TODO: Add onTap to change email
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile ${selectedSport.name}',
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.male),
              title: Text('Gender'),
              subtitle: const Text('Male'),
              onTap: () {
                // TODO: Edit
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.handFist),
              title: Text('Age Group'),
              subtitle: const Text('Mature'),
              onTap: () {
                // TODO: Edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: Text('Skill'),
              subtitle: const Text('Not set'),
              onTap: () {
                // TODO: Edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text('Fitness'),
              subtitle: const Text('Not set'),
              onTap: () {
                // TODO: Edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_work),
              title: Text('Position'),
              subtitle: const Text('Not set'),
              onTap: () {
                // TODO: Edit preferred position
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text('Playtime'),
              subtitle: const Text('Not set'),
              onTap: () {
                // TODO: Edit
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network & Industry',
                style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Industry'),
              subtitle: const Text('Not set'),
              onTap: () {
                // TODO: Edit industry
              },
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Networks (School, Company)'),
              subtitle: const Text('Not set'),
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
    return SingleChildScrollView(
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
            final currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
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