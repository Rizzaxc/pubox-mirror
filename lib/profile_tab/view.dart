import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../core/icons/main.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
import 'profile_state_provider.dart';
import 'widget/age_group_selection.dart';
import 'widget/gender_selection.dart';
import 'widget/industry_selection.dart';
import 'widget/network_selection.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Widget _buildAccountSection(BuildContext context) {
    final player = context.watch<PlayerProvider>().player;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar as the main signifier
          CircleAvatar(
            radius: 72,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          // Username and tag directly beneath
          Text(
            '${player.username}#${player.tagNumber}',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Email
          Text(
            supabase.auth.currentUser?.email ?? 'No Email',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Change password button
          OutlinedButton.icon(
            icon: const Icon(Icons.lock_outline),
            label: const Text('Đổi Password'),
            onPressed: () {
              // TODO: Navigate to change password screen
              context.showToast('Navigate to change password screen',
                  type: ToastificationType.info);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlatformElevatedButton(
          onPressed: () async {
            showPlatformDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => PlatformAlertDialog(
                      title: const Text('Confirm Log Out?'),
                      actions: [
                        PlatformTextButton(
                          onPressed: () => context.pop(),
                          child: const Text('No'),
                        ),
                        PlatformTextButton(
                          onPressed: () async {
                            await supabase.auth.signOut();
                            if (context.mounted) {
                              context.go('/welcome');
                              context.pop();
                            }
                          },
                          child: const Text('Yes'),
                        )
                      ],
                    ));
          },
          color: Theme.of(context).colorScheme.tertiary,
          cupertino: (_, __) => CupertinoElevatedButtonData(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: const [
              Icon(Icons.logout),
              Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
        // child: ListTile(
        //   leading: Icon(Icons.logout, color: Colors.red.shade700),
        //   title: Text('Sign Out', style: TextStyle(color: Colors.red.shade700)),
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12)),
        //   onTap: () async {
        //     await supabase.auth.signOut();
        //     if (context.mounted) {
        //       context.go('/welcome');
        //     }
        //   },
        // ),
        );
  }

  Widget _buildProfileSection(BuildContext context) {
    final selectedSport = context.watch<SelectedSportProvider>().self;

    // Conditionally render iOS or Android UI based on the current platform
    if (isCupertino(context)) {
      // iOS UI
      return CupertinoListSection.insetGrouped(
        header: const Text('General'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          const GenderSelection(),
          const AgeGroupSelection(),
        ],
      );
    } else {
      // Android UI
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text('Profile ${selectedSport.name.capitalize()}',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Divider(),
              const GenderSelection(),
              const AgeGroupSelection(),

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
              // Save/cancel buttons removed - now handled by FAB
            ],
          ),
        ),
      );
    }
  }

  Widget _buildNetworkSection(BuildContext context) {
    // Conditionally render iOS or Android UI based on the current platform
    if (isCupertino(context)) {
      // iOS UI
      return CupertinoListSection.insetGrouped(
        header: const Text('Network & Industry'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          const IndustrySelection(),
          const NetworkSelection(),
        ],
      );
    } else {
      // Android UI
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text('Network & Industry',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Divider(),
              const IndustrySelection(),
              const NetworkSelection(),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMainContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProfileStateProvider>().refreshProfile(),
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
              const SizedBox(height: 16),
              _buildLogoutButton(context),
              const SizedBox(height: 144), // For FAB spacing
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
