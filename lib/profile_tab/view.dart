import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';
import 'account_modal.dart';
import 'avatar/pubox_avatar.dart';
import 'profile_state_provider.dart';
import 'widget/age_group_selection.dart';
import 'widget/gender_selection.dart';
import 'widget/industry_selection.dart';
import 'widget/network_selection.dart';
import 'widget/playtime_selection.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {


  void _showAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const AccountModal(),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar component
          PuboxAvatar(
            username: playerProvider.username,
            onTap: () => _showAccountModal(context),
            showUploadButton: false,
            showRegenerateButton: false,
          ),

          const SizedBox(height: 16),

          // Username and tag directly beneath
          Text(
            playerProvider.username,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final selectedSport = context.watch<SelectedSportProvider>().self;

    // Conditionally render iOS or Android UI based on the current platform
    if (isCupertino(context)) {
      // iOS UI
      return CupertinoListSection.insetGrouped(
        header: const Text('General'),
        footer: Text(context.tr('profileView.profile_feature_explanation'), style: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.secondaryLabel,
        ),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          const GenderSelection(),
          const AgeGroupSelection(),
          const PlaytimeSelection(),
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
              const PlaytimeSelection(),
              // Save/cancel buttons removed - now handled by FAB
            ],
          ),
        ),
      );
    }
  }

  Widget _buildNetworkIndustrySection(BuildContext context) {
    // Conditionally render iOS or Android UI based on the current platform
    if (isCupertino(context)) {
      // iOS UI
      return CupertinoListSection.insetGrouped(
        header: const Text('Network & Industry'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          const NetworkSelection(),
          const IndustrySelection(),
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
              const NetworkSelection(),
              const IndustrySelection(),
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
              _buildNetworkIndustrySection(context),
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
    if (playerProvider.loading || playerProvider.id == null) {
      // If user is not logged in and not currently loading, schedule redirect.
      if (playerProvider.id == null && !playerProvider.loading) {
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
