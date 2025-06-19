import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

class NetworkSelection extends StatelessWidget {
  const NetworkSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileStateProvider>(context);
    final selectedNetworks = profileState.selectedNetworks;

    return isCupertino(context)
        ? _buildIOSNetworkListTile(context, selectedNetworks)
        : _buildAndroidNetworkListTile(context, selectedNetworks);
  }

  Widget _buildAndroidNetworkListTile(
      BuildContext context, List<Network> selectedNetworks) {
    String subtitle;
    if (selectedNetworks.isEmpty) {
      subtitle = context.tr('not_set');
    } else if (selectedNetworks.length == 1) {
      subtitle = selectedNetworks[0].getLocalizedName(context);
    } else {
      subtitle =
          '${selectedNetworks[0].getLocalizedName(context)}, ${selectedNetworks[1].getLocalizedName(context)}';
    }

    return ListTile(
      leading: PuboxIcons.network,
      title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showNetworkModal(context, selectedNetworks),
    );
  }

  void _showNetworkModal(
      BuildContext context, List<Network> selectedNetworks) {
    final TextEditingController searchController = TextEditingController();

    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      cupertino: CupertinoModalSheetData(
          barrierDismissible: true, semanticsDismissible: true),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        snap: true,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setState) {
            final selectedNetworks =
                context.select<ProfileStateProvider, List<Network>>(
                    (provider) => provider.selectedNetworks);

            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('network_selection_title'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PlatformTextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.tr('done')),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isCupertino(context)
                              ? CupertinoSearchTextField(
                                  controller: searchController,
                                  placeholder: context.tr('search_network'),
                                  onChanged: (value) {
                                    // Search functionality will be handled by TypeAheadField
                                  },
                                )
                              : TypeAheadField<Network>(
                                  suggestionsCallback: (pattern) async {
                                    if (pattern.isEmpty) {
                                      return [];
                                    }
                                    return NetworkData.instance.searchNetworks(pattern);
                                  },
                                  itemBuilder: (context, network) {
                                    final isSelected = selectedNetworks.contains(network);
                                    return ListTile(
                                      title: Text(network.name),
                                      trailing: isSelected
                                          ? const Icon(Icons.check_circle)
                                          : null,
                                    );
                                  },
                                  onSelected: (network) {
                                    context.read<ProfileStateProvider>().toggleNetwork(network);
                                    searchController.clear();
                                  },
                                ),
                        ),
                        if (selectedNetworks.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      context.tr('selected_networks'),
                                      style: isCupertino(context)
                                          ? const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            )
                                          : Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  ...selectedNetworks.map((network) => ListTile(
                                        title: Text(network.name),
                                        trailing: IconButton(
                                          icon: Icon(
                                            isCupertino(context)
                                                ? CupertinoIcons.minus_circle
                                                : Icons.remove_circle,
                                            color: isCupertino(context)
                                                ? CupertinoColors.destructiveRed
                                                : null,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ProfileStateProvider>()
                                                .toggleNetwork(network);
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIOSNetworkListTile(
      BuildContext context, List<Network> selectedNetworks) {
    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
      leading: PuboxIcons.network,
      trailing: const CupertinoListTileChevron(),
      onTap: () => _showNetworkModal(context, selectedNetworks),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await NetworkData.instance.searchNetworks(query);

    setState(() {
      _searchResults = results;
      _isSearching = false;
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: context.tr('search_network'),
                onChanged: (value) {
                  _performSearch(value);
                },
              ),
            ),
            if (_isSearching)
              const Center(child: CupertinoActivityIndicator())
            else if (_searchController.text.isNotEmpty && _searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(context.tr('no_networks_found')),
              )
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    children: _searchResults.map((network) {
                      final isSelected = selectedNetworks.contains(network);
                      return CupertinoListTile.notched(
                        title: Text(network.name),
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
                ),
              ),
            if (selectedNetworks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        context.tr('selected_networks'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      children: selectedNetworks.map((network) {
                        return CupertinoListTile.notched(
                          title: Text(network.name),
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              CupertinoIcons.minus_circle,
                              color: CupertinoColors.destructiveRed,
                            ),
                            onPressed: () {
                              context
                                  .read<ProfileStateProvider>()
                                  .toggleNetwork(network);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
