import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'logger.dart';
import 'model/enum.dart';
import 'utils.dart';

class NetworkProvider extends ChangeNotifier {
  NetworkProvider._();

  /// Singleton instance
  static final NetworkProvider instance = NetworkProvider._();


  /// Loading state
  bool _loading = false;

  /// Getter for loading state
  bool get loading => _loading;

  /// Search networks using PostgreSQL full-text search
  Future<List<Network>> searchNetworks(String term) async {
    if (term.trim().isEmpty) return [];
    if (term.length < 2) return []; // Minimum search length

    _loading = true;
    notifyListeners();

    try {
      // Try Vietnamese full-text search first
      List<Network> networks = [];
      
      try {
        final vietnameseResponse = await supabase
            .from('network')
            .select('id, name, category')
            .textSearch('name', term, config: 'simple') // 'simple' works better for Vietnamese
            .order('name')
            .limit(20);
        
        networks = (vietnameseResponse as List).map((each) {
          return Network(
            id: each['id'],
            name: each['name'],
            category: NetworkCategory.fromString(each['category']),
          );
        }).toList();
      } catch (e) {
        AppLogger.d('Vietnamese FTS failed, trying English: $e');
        
        // Try English full-text search if Vietnamese fails
        final englishResponse = await supabase
            .from('network')
            .select('id, name, category')
            .textSearch('name', term, config: 'english')
            .order('name')
            .limit(20);
        
        networks = (englishResponse as List).map((each) {
          return Network(
            id: each['id'],
            name: each['name'],
            category: NetworkCategory.fromString(each['category']),
          );
        }).toList();
      }

      return networks;
    } catch (e, stackTrace) {
      AppLogger.d('Error searching networks with FTS: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
      
      // Fallback to ILIKE search for both Vietnamese and English
      return _fallbackSearch(term);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Fallback search using ILIKE for partial matching (supports Vietnamese)
  Future<List<Network>> _fallbackSearch(String term) async {
    try {
      // First try with unaccent for Vietnamese text (if extension is available)
      List<Network> networks = [];
      
      try {
        // Use unaccent to handle Vietnamese diacritics
        final unaccentResponse = await supabase
            .rpc('search_networks_unaccent', params: {
              'search_term': term,
              'result_limit': 20
            });

        networks = (unaccentResponse as List).map((each) {
          return Network(
            id: each['id'],
            name: each['name'],
            category: NetworkCategory.fromString(each['category']),
          );
        }).toList();
      } catch (e) {
        AppLogger.d('Unaccent search failed, trying simple function: $e');
        
        try {
          // Try simple search function
          final simpleResponse = await supabase
              .rpc('search_networks_simple', params: {
                'search_term': term,
                'result_limit': 20
              });

          networks = (simpleResponse as List).map((each) {
            return Network(
              id: each['id'],
              name: each['name'],
              category: NetworkCategory.fromString(each['category']),
            );
          }).toList();
        } catch (e2) {
          AppLogger.d('Simple search function failed, using basic ILIKE: $e2');
          
          // Final fallback: basic ILIKE
          final response = await supabase
              .from('network')
              .select('id, name, category')
              .ilike('name', '%$term%')
              .order('name')
              .limit(20);

          networks = (response as List).map((each) {
            return Network(
              id: each['id'],
              name: each['name'],
              category: NetworkCategory.fromString(each['category']),
            );
          }).toList();
        }
      }

      return networks;
    } catch (e, stackTrace) {
      AppLogger.d('Error in fallback search: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Find a network by ID (direct database query)
  Future<Network?> findNetworkById(int id) async {
    try {
      final response = await supabase
          .from('network')
          .select('id, name, category')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Network(
        id: response['id'],
        name: response['name'],
        category: NetworkCategory.fromString(response['category']),
      );
    } catch (e, stackTrace) {
      AppLogger.d('Error finding network by ID: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Get popular networks (for suggestions)
  Future<List<Network>> getPopularNetworks({int limit = 10}) async {
    try {
      // Query networks with most users
      final response = await supabase
          .rpc('get_popular_networks', params: {'limit_count': limit});

      return (response as List).map((each) {
        return Network(
          id: each['id'],
          name: each['name'],
          category: NetworkCategory.fromString(each['category']),
        );
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.d('Error fetching popular networks: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Clear any internal state (if needed)
  void clearState() {
    _loading = false;
    notifyListeners();
  }
}