// import 'dart:async';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:provider/provider.dart';
//
// import '../../core/icons/main.dart';
// import '../../core/model/enum.dart';
// import '../profile_state_provider.dart';
//
// const l10nKeyPrefix = "profileView";
//
// class NetworkSelection extends StatelessWidget {
//   const NetworkSelection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = Provider.of<ProfileStateProvider>(context);
//     final selectedNetworks = profileState.selectedNetworks;
//
//     return isCupertino(context)
//         ? _buildIOSNetworkListTile(context, selectedNetworks)
//         : _buildAndroidNetworkListTile(context, selectedNetworks);
//   }
//
//   Widget _buildAndroidNetworkListTile(
//       BuildContext context, List<Network> selectedNetworks) {
//     String subtitle;
//     if (selectedNetworks.isEmpty) {
//       subtitle = context.tr('not_set');
//     } else if (selectedNetworks.length == 1) {
//       subtitle = selectedNetworks[0].getLocalizedName(context);
//     } else {
//       subtitle =
//           '${selectedNetworks[0].getLocalizedName(context)}, ${selectedNetworks[1].getLocalizedName(context)}';
//     }
//
//     return ListTile(
//       leading: PuboxIcons.network,
//       title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
//       subtitle: Text(subtitle),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       onTap: () => _showNetworkModal(context, selectedNetworks),
//     );
//   }
//
//   void _showNetworkModal(BuildContext context, List<Network> selectedNetworks) {
//     final TextEditingController searchController = TextEditingController();
//
//     showPlatformModalSheet(
//       context: context,
//       material: MaterialModalSheetData(
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//         ),
//       ),
//       cupertino: CupertinoModalSheetData(
//           barrierDismissible: true, semanticsDismissible: true),
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         minChildSize: 0.4,
//         maxChildSize: 0.8,
//         snap: true,
//         builder: (context, scrollController) => StatefulBuilder(
//           builder: (context, setState) {
//             final selectedNetworks =
//                 context.select<ProfileStateProvider, List<Network>>(
//                     (provider) => provider.selectedNetworks);
//
//             return Container(
//               decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(24))),
//               padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         isCupertino(context)
//                             ? Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: CupertinoSearchTextField(
//                                       controller: searchController,
//                                       onChanged: (value) {
//                                         // Search functionality will be handled by TypeAheadField
//                                       },
//                                     ),
//                                   ),
//                                   // TODO: Selected network section
//                                   CupertinoListSection.insetGrouped(
//                                     // header: Text(context.tr('$l10nKeyPrefix.selected_networks')),
//                                     backgroundColor: Theme.of(context)
//                                         .scaffoldBackgroundColor,
//
//                                     children: [
//                                       CupertinoListTile.notched(
//                                           title: Text('Selected Network'))
//                                     ],
//                                   ),
//                                   // TODO: Search result section
//                                   CupertinoListSection.insetGrouped(
//                                     backgroundColor: Theme.of(context)
//                                         .scaffoldBackgroundColor,
//                                     footer: Text(
//                                         context.tr('$l10nKeyPrefix.network_feature_explanation'),
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           color: CupertinoColors.secondaryLabel,
//                                         ),
//                                       ),
//                                     children: [
//                                       // TODO: search result
//                                       CupertinoListTile.notched(
//                                           title: Text('TODO'))
//                                     ],
//                                   ),
//                                 ],
//                               )
//                             : TypeAheadField<Network>(
//                                 suggestionsCallback: (pattern) async {
//                                   if (pattern.trim().isEmpty ||
//                                       pattern.length < 2) {
//                                     // Show popular networks when no search term
//                                     return NetworkRepository.instance
//                                         .getPopularNetworks(limit: 10);
//                                   }
//                                   return NetworkRepository.instance
//                                       .searchNetworks(pattern);
//                                 },
//                                 debounceDuration:
//                                     const Duration(milliseconds: 300),
//                                 itemBuilder: (context, network) {
//                                   final isSelected =
//                                       selectedNetworks.contains(network);
//                                   return ListTile(
//                                     title: Row(
//                                       children: [
//                                         Expanded(child: Text(network.name)),
//                                         if (network.category != null)
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8, vertical: 2),
//                                             decoration: BoxDecoration(
//                                               color: _getCategoryColor(
//                                                       network.category!)
//                                                   .withValues(alpha: 0.2),
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                               border: Border.all(
//                                                 color: _getCategoryColor(
//                                                     network.category!),
//                                                 width: 1,
//                                               ),
//                                             ),
//                                             child: Text(
//                                               network.category!.displayName,
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: _getCategoryColor(
//                                                     network.category!),
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                     trailing: isSelected
//                                         ? const Icon(Icons.check_circle)
//                                         : null,
//                                   );
//                                 },
//                                 onSelected: (network) {
//                                   context
//                                       .read<ProfileStateProvider>()
//                                       .toggleNetwork(network);
//                                   searchController.clear();
//                                 },
//                               ),
//                         if (selectedNetworks.isNotEmpty)
//                           Expanded(
//                             child: SingleChildScrollView(
//                               controller: scrollController,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       context.tr(
//                                           '$l10nKeyPrefix.selected_networks'),
//                                       style: isCupertino(context)
//                                           ? const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             )
//                                           : Theme.of(context)
//                                               .textTheme
//                                               .titleMedium,
//                                     ),
//                                   ),
//                                   ...selectedNetworks.map((network) => ListTile(
//                                         title: Row(
//                                           children: [
//                                             Expanded(child: Text(network.name)),
//                                             if (network.category != null)
//                                               Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 8,
//                                                         vertical: 2),
//                                                 decoration: BoxDecoration(
//                                                   color: _getCategoryColor(
//                                                           network.category!)
//                                                       .withValues(alpha: 0.2),
//                                                   borderRadius:
//                                                       BorderRadius.circular(12),
//                                                   border: Border.all(
//                                                     color: _getCategoryColor(
//                                                         network.category!),
//                                                     width: 1,
//                                                   ),
//                                                 ),
//                                                 child: Text(
//                                                   network.category!.displayName,
//                                                   style: TextStyle(
//                                                     fontSize: 10,
//                                                     color: _getCategoryColor(
//                                                         network.category!),
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                         trailing: IconButton(
//                                           icon: Icon(
//                                             isCupertino(context)
//                                                 ? CupertinoIcons.minus_circle
//                                                 : Icons.remove_circle,
//                                             color: isCupertino(context)
//                                                 ? CupertinoColors.destructiveRed
//                                                 : null,
//                                           ),
//                                           onPressed: () {
//                                             context
//                                                 .read<ProfileStateProvider>()
//                                                 .toggleNetwork(network);
//                                           },
//                                         ),
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildIOSNetworkListTile(
//       BuildContext context, List<Network> selectedNetworks) {
//     return CupertinoListTile.notched(
//       title: Text(context.tr('$l10nKeyPrefix.networkLabel')),
//       leading: PuboxIcons.network,
//       trailing: const CupertinoListTileChevron(),
//       onTap: () => _showNetworkModal(context, selectedNetworks),
//     );
//   }
//
//   void _iosNetworkListPageBuilder(BuildContext context) {
//     Navigator.of(context).push(
//       CupertinoPageRoute(
//         builder: (context) => const NetworkListPage(),
//       ),
//     );
//   }
//
//   Color _getCategoryColor(NetworkCategory category) {
//     switch (category) {
//       case NetworkCategory.highSchool:
//         return Colors.blue;
//       case NetworkCategory.giftedHighSchool:
//         return Colors.purple;
//       case NetworkCategory.university:
//         return Colors.green;
//       case NetworkCategory.company:
//         return Colors.orange;
//     }
//   }
// }
//
// class NetworkListPage extends StatefulWidget {
//   const NetworkListPage({super.key});
//
//   @override
//   State<NetworkListPage> createState() => _NetworkListPageState();
// }
//
// class _NetworkListPageState extends State<NetworkListPage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Network> _searchResults = [];
//   bool _isSearching = false;
//   Timer? _debounceTimer;
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Load popular networks initially
//     _loadPopularNetworks();
//   }
//
//   Future<void> _loadPopularNetworks() async {
//     setState(() {
//       _isSearching = true;
//     });
//
//     final networkProvider = context.read<NetworkRepository>();
//
//     final results =
//         await networkProvider.getPopularNetworks();
//
//     setState(() {
//       _searchResults = results;
//       _isSearching = false;
//     });
//   }
//
//   Future<void> _performSearch(String query) async {
//     // Cancel previous timer
//     _debounceTimer?.cancel();
//
//     // Set up new timer for debouncing
//     _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
//       if (query.trim().isEmpty) {
//         await _loadPopularNetworks();
//         return;
//       }
//
//       if (query.length < 3) {
//         setState(() {
//           _searchResults = [];
//           _isSearching = false;
//         });
//         return;
//       }
//
//       setState(() {
//         _isSearching = true;
//       });
//
//       final networkProvider = context.read<NetworkRepository>();
//       final results = await networkProvider.searchNetworks(query);
//
//       setState(() {
//         _searchResults = results;
//         _isSearching = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedNetworks =
//         context.select<ProfileStateProvider, List<Network>>(
//             (provider) => provider.selectedNetworks);
//
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//           middle: Text(context.tr('$l10nKeyPrefix.networkLabel'))),
//       child: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 4.0),
//                     child: Text(
//                       'TODO',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: CupertinoColors.secondaryLabel,
//                       ),
//                     ),
//                   ),
//                   CupertinoSearchTextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       _performSearch(value);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (_isSearching)
//               const Center(child: CupertinoActivityIndicator())
//             else if (_searchController.text.isNotEmpty &&
//                 _searchController.text.length >= 2 &&
//                 _searchResults.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(context.tr('$l10nKeyPrefix.no_networks_found')),
//               )
//             else if (_searchResults.isNotEmpty)
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: CupertinoListSection.insetGrouped(
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                     children: _searchResults.map((network) {
//                       final isSelected = selectedNetworks.contains(network);
//                       return CupertinoListTile.notched(
//                         title: Row(
//                           children: [
//                             Expanded(child: Text(network.name)),
//                             if (network.category != null)
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: _getCategoryColor(network.category!)
//                                       .withValues(alpha: 0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: _getCategoryColor(network.category!),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   network.category!.displayName,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: _getCategoryColor(network.category!),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         trailing: isSelected
//                             ? const Icon(CupertinoIcons.check_mark)
//                             : null,
//                         onTap: () {
//                           context
//                               .read<ProfileStateProvider>()
//                               .toggleNetwork(network);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             if (selectedNetworks.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         context.tr('selected_networks'),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     CupertinoListSection.insetGrouped(
//                       backgroundColor:
//                           Theme.of(context).scaffoldBackgroundColor,
//                       children: selectedNetworks.map((network) {
//                         return CupertinoListTile.notched(
//                           title: Row(
//                             children: [
//                               Expanded(child: Text(network.name)),
//                               if (network.category != null)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: _getCategoryColor(network.category!)
//                                         .withValues(alpha: 0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color:
//                                           _getCategoryColor(network.category!),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     network.category!.displayName,
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       color:
//                                           _getCategoryColor(network.category!),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           trailing: CupertinoButton(
//                             padding: EdgeInsets.zero,
//                             child: const Icon(
//                               CupertinoIcons.minus_circle,
//                               color: CupertinoColors.destructiveRed,
//                             ),
//                             onPressed: () {
//                               context
//                                   .read<ProfileStateProvider>()
//                                   .toggleNetwork(network);
//                             },
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//          ),
//       ),
//     );
//   }
//
//
// }
