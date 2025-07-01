import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../core/sport_switcher.dart';
import '../model.dart';
import 'lobby_state_provider.dart';
import 'lobby_item.dart';

class LobbySection extends StatefulWidget {
  const LobbySection({super.key});

  @override
  State<LobbySection> createState() => _LobbySectionState();
}

class _LobbySectionState extends State<LobbySection>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Row(
            children: [
              Text(
                context.tr('manageTab.lobby.title'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          titleSpacing: 4,
          centerTitle: false,
          pinned: false,
          primary: false,
        ),
        Consumer2<LobbyStateProvider, SelectedSportProvider>(
          builder: (context, lobbyProvider, sportProvider, child) {

            if (lobbyProvider.isLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (lobbyProvider.lobbies.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          context.tr('manageTab.lobby.empty.title'),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          context.tr('manageTab.lobby.empty.message'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lobby = lobbyProvider.lobbies[index];
                  return LobbyItem(
                    lobby: lobby,
                    onTap: () => _onLobbyTap(lobby),
                  );
                },
                childCount: lobbyProvider.lobbies.length,
              ),
            );
          },
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }

  void _onLobbyTap(UserLobbyModel lobby) {
    // TODO: Navigate to lobby detail using main lobby route
    // This should navigate to the main lobby route with the lobby ID
    
    // For now, show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('manageTab.lobby.navigate')),
        content: Text(
          context.tr('manageTab.lobby.navigateMessage', namedArgs: {
            'lobbyTitle': lobby.title,
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('done')),
          ),
        ],
      ),
    );
  }

  void _showCreateLobbyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('manageTab.lobby.createNew')),
        content: Text(context.tr('manageTab.lobby.createMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('done')),
          ),
        ],
      ),
    );
  }
}