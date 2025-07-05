import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../../core/model/enum.dart';
import '../../core/network_repository.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

class NetworkSelection extends StatelessWidget {
  const NetworkSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedNetworks =
        context.select<ProfileStateProvider, List<Network>>(
            (provider) => provider.selectedNetworks);
    return isCupertino(context)
        ? _buildIOSNetworkListTile(context)
        : _buildAndroidNetworkListTile(context);
  }

  Widget _buildAndroidNetworkListTile(BuildContext context) {
    return ListTile(
      leading: PuboxIcons.network,
      title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // onTap: () => _showNetworkModal(context, selectedNetworks),
    );
  }

  Widget _buildIOSNetworkListTile(BuildContext context) {
    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
      leading: PuboxIcons.network,
      trailing: const CupertinoListTileChevron(),
      onTap: () => _iosNetworkListPageBuilder(context),
    );
  }

  void _iosNetworkListPageBuilder(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const NetworkListPage(),
      ),
    );
  }
}

class NetworkListPage extends StatefulWidget {
  const NetworkListPage({super.key});

  @override
  State<NetworkListPage> createState() => _NetworkListPageState();
}

class _NetworkListPageState extends State<NetworkListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Network> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _performSearch(String query) async {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set up new timer for debouncing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (query.length < 3) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      setState(() {
        _isSearching = true;
      });

      final results = await NetworkRepository.searchNetworks(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedNetworks =
        context.select<ProfileStateProvider, List<Network>>(
            (provider) => provider.selectedNetworks);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(context.tr('$l10nKeyPrefix.networkLabel'))),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoSearchTextField(
                      controller: _searchController,
                      onChanged: (value) {
                        _performSearch(value);
                      },
                    ),
                  ],
                ),
              ),
              selectedNetworkSection(selectedNetworks),
              if (_isSearching)
                const Center(child: CupertinoActivityIndicator())
              else if (_searchController.text.isNotEmpty &&
                  _searchController.text.length >= 2 &&
                  _searchResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(context.tr('$l10nKeyPrefix.no_networks_found')),
                )
              else if (_searchResults.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  children: _searchResults.map((network) {
                    final isSelected = selectedNetworks.contains(network);
                    return CupertinoListTile.notched(
                      title: Row(
                        children: [
                          Expanded(
                              child: Text(
                            network.name,
                            style: TextStyle(),
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: network.category.categoryColor
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: network.category.categoryColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        network.category.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          color: network.category.categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(CupertinoIcons.check_mark)
                          : null,
                      onTap: () {
                        context
                            .read<ProfileStateProvider>()
                            .toggleNetwork(network);
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedNetworkSection(List<Network> selectedNetworks) {
    return CupertinoListSection.insetGrouped(
      header: Text(
        context.tr('$l10nKeyPrefix.selected_networks'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      footer: (selectedNetworks.isEmpty
          ? Text(
              context.tr('$l10nKeyPrefix.no_networks_selected'),
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
              ),
            )
          : null),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: selectedNetworks.map((network) {
        return GestureDetector(
            onTap: () {
              // show cupertino action sheet
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                        title: Text(network.name),
                        message: Text(context.tr('$l10nKeyPrefix.toggleAlumniStatus')),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              context
                                  .read<ProfileStateProvider>()
                                  .toggleAlumniStatus(network);
                              context.pop();
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  Text(
                                    context.tr('$l10nKeyPrefix.currentMember'),
                                  ),
                                  (!network.isAlumni
                                      ? Icon(CupertinoIcons.check_mark)
                                      : SizedBox.shrink()),
                                ]),
                          ),
                          CupertinoActionSheetAction(
                              onPressed: () {
                                context
                                    .read<ProfileStateProvider>()
                                    .toggleAlumniStatus(network);
                                context.pop();
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 4,
                                  children: [
                                    Text(context.tr('$l10nKeyPrefix.alumni')),
                                    (network.isAlumni
                                        ? Icon(CupertinoIcons.check_mark)
                                        : SizedBox.shrink()),
                                  ])),
                          CupertinoActionSheetAction(
                              onPressed: () {
                                context
                                    .read<ProfileStateProvider>()
                                    .toggleNetwork(network);
                                context.pop();
                              },
                              isDestructiveAction: true,
                              child: const Text('Delete')),
                        ]);
                  });
            },
            child: CupertinoListTile(
              title: Text(network.name, style: TextStyle(overflow: TextOverflow.ellipsis),),
            ));
      }).toList(),
    );
  }
}
