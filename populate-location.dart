import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// City boundaries with bounding boxes for more reliable querying
final Map<String, Map<String, dynamic>> cityBoundaries = {
  'Ho Chi Minh City': {
    'south': 10.3776,
    'west': 106.3644,
    'north': 11.1602,
    'east': 107.0219
  },
  'Hanoi': {
    'south': 20.8037,
    'west': 105.5144,
    'north': 21.2564,
    'east': 106.0156
  }
};

/// Fetch venues from OpenStreetMap using Overpass API with a bounding box
Future<List<dynamic>> fetchVenuesFromOSM(
    String cityName, String venueType) async {
  print('  Fetching $venueType venues for $cityName...');

  final bounds = cityBoundaries[cityName];
  if (bounds == null) {
    print('Error: No boundary data found for $cityName');
    return [];
  }

  // Create a properly formatted Overpass QL query
  final overpassQuery = '''
    [out:json][timeout:60];
    (
      ${venueType}(${bounds['south']},${bounds['west']},${bounds['north']},${bounds['east']});
    );
    out body center;
  ''';

  print('  Query: $overpassQuery');

  // Overpass API has rate limits, so we'll add a small delay
  await Future.delayed(Duration(seconds: 1));

  try {
    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      body: {'data': overpassQuery},
    );

    if (response.statusCode != 200) {
      print('API error: ${response.statusCode} - ${response.body}');
      return [];
    }

    final data = jsonDecode(response.body);
    final elements = data['elements'] as List<dynamic>;
    print('  Found ${elements.length} elements');
    return elements;
  } catch (e) {
    print('Error fetching venues from OSM: $e');
    return [];
  }
}

/// Get address details using Nominatim API for reverse geocoding
Future<Map<String, dynamic>> getReverseGeocode(double lat, double lon) async {
  try {
    // Add delay to respect Nominatim usage policy (1 request per second)
    await Future.delayed(Duration(seconds: 1));

    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse'
          '?format=json'
          '&lat=$lat'
          '&lon=$lon'
          '&zoom=18' // Highest zoom for most detailed address
          '&addressdetails=1'),
      headers: {
        'User-Agent':
            'SportVenueCollector/1.0 (your.email@example.com)' // Replace with real email
      },
    );

    if (response.statusCode != 200) {
      print('Nominatim API error: ${response.statusCode} - ${response.body}');
      return {};
    }

    return jsonDecode(response.body);
  } catch (e) {
    print('Error getting address from Nominatim: $e');
    return {};
  }
}

/// Process a venue element and extract relevant information
Future<Map<String, dynamic>?> processVenue(
    Map<String, dynamic> element, String cityName) async {
  final tags = element['tags'] as Map<String, dynamic>?;

  // Skip if there's no tags
  if (tags == null) return null;

  // Get venue name - use a fallback if name is missing
  final String name;
  if (tags.containsKey('name')) {
    name = tags['name'] as String;
  } else if (tags.containsKey('sport')) {
    name = '${tags['sport'].toString().capitalize()} Venue';
  } else if (tags.containsKey('leisure')) {
    name = '${tags['leisure'].toString().capitalize()} Venue';
  } else {
    name = 'Unnamed Venue';
  }

  // Get coordinates (center coordinates for ways and relations)
  double? lat;
  double? lon;

  if (element['type'] == 'node') {
    lat = element['lat'] as double?;
    lon = element['lon'] as double?;
  } else if (element.containsKey('center')) {
    final center = element['center'] as Map<String, dynamic>?;
    lat = center?['lat'] as double?;
    lon = center?['lon'] as double?;
  }

  // Skip if no coordinates
  if (lat == null || lon == null) return null;

  // Initialize address components
  String? streetNumber;
  String? streetName;
  String? district;
  String fullAddress;

  // First, try to get address from the element tags
  if (tags.containsKey('addr:housenumber')) {
    streetNumber = tags['addr:housenumber'] as String;
  }

  if (tags.containsKey('addr:street')) {
    streetName = tags['addr:street'] as String;
  }

  if (tags.containsKey('addr:district')) {
    district = tags['addr:district'] as String;
  } else if (tags.containsKey('addr:suburb')) {
    district = tags['addr:suburb'] as String;
  }

  // If address is incomplete, use Nominatim reverse geocoding
  if (streetNumber == null || streetName == null || district == null) {
    final geocodeResult = await getReverseGeocode(lat, lon);
    final address = geocodeResult['address'] as Map<String, dynamic>?;

    if (address != null) {
      // Get street number if not already set
      if (streetNumber == null && address.containsKey('house_number')) {
        streetNumber = address['house_number'] as String;
      }

      // Get street name if not already set
      if (streetName == null && address.containsKey('road')) {
        streetName = address['road'] as String;
      }

      // Get district if not already set
      if (district == null) {
        if (address.containsKey('suburb')) {
          district = address['suburb'] as String;
        } else if (address.containsKey('district')) {
          district = address['district'] as String;
        } else if (address.containsKey('neighbourhood')) {
          district = address['neighbourhood'] as String;
        }
      }
    }
  }

  // Create full address
  final addressParts = <String>[];

  if (streetNumber != null) addressParts.add(streetNumber);
  if (streetName != null) addressParts.add(streetName);
  if (district != null) addressParts.add(district);
  addressParts.add(cityName);

  if (addressParts.length > 1) {
    // More than just the city name
    fullAddress = addressParts.join(', ');
  } else {
    fullAddress = '$name ($cityName)';
  }

  // Use OSM ID as external_id
  final externalId = '${element['type']}/${element['id']}';

  return {
    'external_id': externalId,
    'name': name,
    'full_address': fullAddress,
    'street_number': streetNumber,
    'street_name': streetName,
    'district': district,
    'city': cityName,
    'latitude': lat,
    'longitude': lon,
    'tags': tags,
  };
}

/// Main function to collect venue data
Future<String> collectVenues() async {
  try {
    // Cities to collect data for
    final cities = ['Ho Chi Minh City', 'Hanoi'];

    // Define the venue types to search for
    final venueTypesQueries = [
      // Facility types
      'node["leisure"="sports_centre"]',
      'way["leisure"="sports_centre"]',
      'relation["leisure"="sports_centre"]',
      'node["leisure"="stadium"]',
      'way["leisure"="stadium"]',
      'relation["leisure"="stadium"]',
      'node["leisure"="pitch"]',
      'way["leisure"="pitch"]',
      'relation["leisure"="pitch"]',
      'node["leisure"="swimming_pool"]',
      'way["leisure"="swimming_pool"]',
      'relation["leisure"="swimming_pool"]',

      // Sport-specific facilities
      'node["sport"="soccer"]',
      'way["sport"="soccer"]',
      'relation["sport"="soccer"]',
      'node["sport"="basketball"]',
      'way["sport"="basketball"]',
      'relation["sport"="basketball"]',
      'node["sport"="tennis"]',
      'way["sport"="tennis"]',
      'relation["sport"="tennis"]',
      'node["sport"="badminton"]',
      'way["sport"="badminton"]',
      'relation["sport"="badminton"]',
      'node["sport"="pickleball"]',
      'way["sport"="pickleball"]',
      'relation["sport"="pickleball"]',
    ];

    final allVenues = <Map<String, dynamic>>[];

    // Process each city
    for (final cityName in cities) {
      print('Processing $cityName...');

      // Process each venue type
      for (final venueTypeQuery in venueTypesQueries) {
        final venues = await fetchVenuesFromOSM(cityName, venueTypeQuery);
        print('  Found ${venues.length} $venueTypeQuery venues');

        // Process each venue - this now uses await because processVenue is async
        for (final element in venues) {
          final venueData = await processVenue(element, cityName);
          if (venueData != null) {
            allVenues.add(venueData);
          }
        }

        // Add delay to respect Overpass API rate limits
        await Future.delayed(Duration(seconds: 2));
      }
    }

    // Remove duplicates based on external_id
    final uniqueVenues = <String, Map<String, dynamic>>{};
    for (final venue in allVenues) {
      uniqueVenues[venue['external_id']] = venue;
    }

    // Create output directory if it doesn't exist
    final directory = Directory('data');
    if (!await directory.exists()) {
      await directory.create();
    }

    // Save all venues to a JSON file
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filename = 'data/sport_venues_$timestamp.json';

    final file = File(filename);
    await file.writeAsString(
      JsonEncoder.withIndent('  ').convert(uniqueVenues.values.toList()),
      flush: true,
    );

    print('Total unique venues collected: ${uniqueVenues.length}');
    print('Data saved to $filename');

    return filename;
  } catch (e, stackTrace) {
    print('Error: $e');
    rethrow;
  }
}

/// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return this.isEmpty ? this : this[0].toUpperCase() + this.substring(1);
  }
}

void main() async {
  try {
    final outputFile = await collectVenues();
    print(
        'Venue data collection completed. Use $outputFile to import into PostgreSQL.');
  } catch (e) {
    print('Failed to collect venue data: $e');
    exit(1);
  }
}
