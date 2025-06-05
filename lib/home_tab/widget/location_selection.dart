
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../../core/tag_carousel.dart';
import '../home_search_page.dart';
import '../state_provider.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key});

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  late City _selectedCity;
  late Set<String> _selectedDistricts;
  late HomeStateProvider _stateProvider;

  @override
  void initState() {
    super.initState();
    // Initialize local state from the provider's current committed state.
    // Note: Using context.read here as initState runs once.
    _stateProvider = context.read<HomeStateProvider>();
    _selectedCity = _stateProvider.city; // Reads committed city
    _selectedDistricts = Set<String>.from(_stateProvider.districts); // Reads committed districts
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Icon(PlatformIcons(context).locationSolid),
            Text('Khu Vực', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Card(
          child: Column(
            children: [
              PlatformPopupMenu(
                material: (_, __) => MaterialPopupMenuData(
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.zero,
                    splashRadius: 32,
                    constraints: BoxConstraints(maxWidth: 128), // Adjust width as needed
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200)),
                    popUpAnimationStyle: AnimationStyle(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 250))),
                cupertino: (_, __) => CupertinoPopupMenuData(
                  title: Text(
                    'Thành Phố',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                icon: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.only(
                          topLeft: HomeSearchPage.borderRadiusVal,
                          topRight: HomeSearchPage.borderRadiusVal)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.location_city, color: Colors.white),
                        Text(
                          _selectedCity.name, // Use local state for display
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                options: City.values
                    .map((eachCity) => PopupMenuOption(
                  label: eachCity.shorthand,
                  material: (_, __) => MaterialPopupMenuOptionData(
                      child: Text(eachCity.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge)),
                  cupertino: (_, __) => CupertinoPopupMenuOptionData(
                      child: Text(eachCity.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge)),
                  onTap: (_) {
                    if (_selectedCity != eachCity) {
                      setState(() {
                        _selectedCity = eachCity;
                        _selectedDistricts = {}; // Clear districts when city changes
                      });
                      // Update the provider with the pending city change
                      _stateProvider.updateCity(eachCity);
                    }
                  },
                ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              TagCarousel(
                height: 92,
                tagLabels: VietnamLocationData.instance
                    .getDistrictsByCity(_selectedCity) // Use local state for district list
                    .map((e) => e.fullName)
                    .toList(),
                initialSelection: _selectedDistricts, // Use local state
                onSelectionChanged: (selectedDistrictsFromCarousel) {
                  setState(() {
                    _selectedDistricts = selectedDistrictsFromCarousel;
                  });
                  // Update the provider with the pending district change
                  _stateProvider.updateDistricts(selectedDistrictsFromCarousel);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}