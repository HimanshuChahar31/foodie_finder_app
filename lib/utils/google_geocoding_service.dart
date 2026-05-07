import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class GoogleGeocodingResult {
  final String formattedAddress;
  final String locationSummary;

  const GoogleGeocodingResult({
    required this.formattedAddress,
    required this.locationSummary,
  });
}

class GoogleGeocodingService {
  static const MethodChannel _channel = MethodChannel(
    'foodie_finder/native_config',
  );
  static bool _serviceUnavailable = false;

  static Future<GoogleGeocodingResult> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    if (_serviceUnavailable) {
      throw Exception('Google geocoding is unavailable.');
    }

    final apiKey = await _channel.invokeMethod<String>('getGoogleApiKey');
    if (apiKey == null || apiKey.trim().isEmpty) {
      _serviceUnavailable = true;
      throw Exception('Google API key is not configured on Android.');
    }

    final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '$latitude,$longitude',
      'key': apiKey,
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('Google geocoding request failed.');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final status = payload['status'] as String? ?? 'UNKNOWN_ERROR';
    if (status != 'OK') {
      if (status == 'REQUEST_DENIED') {
        _serviceUnavailable = true;
      }
      throw Exception('Google geocoding returned $status.');
    }

    final results = payload['results'] as List<dynamic>;
    if (results.isEmpty) {
      throw Exception('Google geocoding did not return any address.');
    }

    final primary = results.first as Map<String, dynamic>;
    final formattedAddress = primary['formatted_address'] as String? ?? '';
    final locationSummary = _buildLocationSummary(
      primary['address_components'] as List<dynamic>? ?? const [],
      formattedAddress,
    );

    return GoogleGeocodingResult(
      formattedAddress: formattedAddress,
      locationSummary: locationSummary,
    );
  }

  static String _buildLocationSummary(
    List<dynamic> addressComponents,
    String formattedAddress,
  ) {
    String? locality;
    String? district;
    String? state;

    for (final entry in addressComponents) {
      final component = entry as Map<String, dynamic>;
      final types = (component['types'] as List<dynamic>).cast<String>();
      final longName = component['long_name'] as String? ?? '';
      if (longName.isEmpty) continue;

      if (locality == null &&
          (types.contains('sublocality') ||
              types.contains('sublocality_level_1') ||
              types.contains('locality'))) {
        locality = longName;
      }

      if (district == null &&
          (types.contains('administrative_area_level_2') ||
              types.contains('administrative_area_level_3'))) {
        district = longName;
      }

      if (state == null && types.contains('administrative_area_level_1')) {
        state = longName;
      }
    }

    final parts = [
      locality,
      district,
      state,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(', ') : formattedAddress;
  }
}
