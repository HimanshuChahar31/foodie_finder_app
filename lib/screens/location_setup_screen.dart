import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/google_geocoding_service.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/route_transitions.dart';

class LocationSetupScreen extends StatelessWidget {
  final bool forOrderPlacement;

  const LocationSetupScreen({
    super.key,
    this.forOrderPlacement = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Choose your location', style: AppTextStyles.h2),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          forOrderPlacement
                              ? 'Location is mandatory before placing the order. Enter it manually or use the phone GPS for your current area.'
                              : 'You can enter the address manually or use the phone GPS for your current area.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final saved = await Navigator.of(context).push<bool>(
                              fadeRoute(
                                page: _ManualLocationScreen(
                                  forOrderPlacement: forOrderPlacement,
                                ),
                              ),
                            );
                            if (saved == true && context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          icon: const Icon(Icons.edit_location_alt_rounded),
                          label: const Text('Enter manually'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final saved = await Navigator.of(
                              context,
                            ).push<bool>(
                              fadeRoute(
                                page: _GpsLocationScreen(
                                  forOrderPlacement: forOrderPlacement,
                                ),
                              ),
                            );
                            if (saved == true && context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          icon: const Icon(Icons.gps_fixed_rounded),
                          label: const Text('Use Google GPS'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ManualLocationScreen extends StatefulWidget {
  final bool forOrderPlacement;

  const _ManualLocationScreen({
    required this.forOrderPlacement,
  });

  @override
  State<_ManualLocationScreen> createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<_ManualLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _localityController = TextEditingController();
  final _houseController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _localityController.dispose();
    _houseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final state = _stateController.text.trim();
    final district = _districtController.text.trim();
    final locality = _localityController.text.trim();
    final house = _houseController.text.trim();

    await context.read<AuthProvider>().setLocationDetails(
      location: '$locality, $district, $state',
      address: house,
      locationMode: 'manual',
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manual location',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _AddressField(
                controller: _stateController,
                label: 'State',
                icon: Icons.map_rounded,
              ),
              _AddressField(
                controller: _districtController,
                label: 'District',
                icon: Icons.account_balance_rounded,
              ),
              _AddressField(
                controller: _localityController,
                label: 'Locality',
                icon: Icons.location_city_rounded,
              ),
              _AddressField(
                controller: _houseController,
                label: 'House no. / Building',
                icon: Icons.home_rounded,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving...' : 'Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GpsLocationScreen extends StatefulWidget {
  final bool forOrderPlacement;

  const _GpsLocationScreen({
    required this.forOrderPlacement,
  });

  @override
  State<_GpsLocationScreen> createState() => _GpsLocationScreenState();
}

class _GpsLocationScreenState extends State<_GpsLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _houseController = TextEditingController();
  Placemark? _placemark;
  Position? _position;
  GoogleGeocodingResult? _googleResult;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _houseController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location service is turned off on this device.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required for GPS setup.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      GoogleGeocodingResult? googleResult;
      try {
        googleResult = await GoogleGeocodingService.reverseGeocode(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (_) {
        googleResult = null;
      }

      setState(() {
        _position = position;
        _placemark = placemarks.isNotEmpty ? placemarks.first : null;
        _googleResult = googleResult;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final placemark = _placemark;
    final position = _position;
    if (placemark == null || position == null) {
      setState(() => _error = 'Current location is not ready yet.');
      return;
    }

    setState(() => _saving = true);

    final areaParts = [
      _googleResult?.locationSummary,
      placemark.subLocality,
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();

    await context.read<AuthProvider>().setLocationDetails(
      location: areaParts.first,
      address: _houseController.text.trim(),
      locationMode: 'gps',
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final placemark = _placemark;
    final googleResult = _googleResult;
    final locationLines = <String>[
      if (googleResult?.formattedAddress.trim().isNotEmpty ?? false)
        googleResult!.formattedAddress.trim(),
      if (placemark?.street?.trim().isNotEmpty ?? false)
        placemark!.street!.trim(),
      if (placemark?.subLocality?.trim().isNotEmpty ?? false)
        placemark!.subLocality!.trim(),
      if (placemark?.locality?.trim().isNotEmpty ?? false)
        placemark!.locality!.trim(),
      if (placemark?.subAdministrativeArea?.trim().isNotEmpty ?? false)
        placemark!.subAdministrativeArea!.trim(),
      if (placemark?.administrativeArea?.trim().isNotEmpty ?? false)
        placemark!.administrativeArea!.trim(),
      if (placemark?.postalCode?.trim().isNotEmpty ?? false)
        placemark!.postalCode!.trim(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPS location',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Detected location', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            if (_loading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: AppSpacing.md),
                      Text('Fetching live location...'),
                    ],
                  ),
                ),
              )
            else if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _error!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: _loadCurrentLocation,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...locationLines.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(line, style: AppTextStyles.bodyMedium),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Latitude: ${_position!.latitude.toStringAsFixed(6)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Longitude: ${_position!.longitude.toStringAsFixed(6)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _houseController,
                    decoration: const InputDecoration(
                      labelText: 'House no. / Building',
                      prefixIcon: Icon(Icons.home_rounded),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Enter house or building number'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: _loading || _saving ? null : _save,
                    child: Text(_saving ? 'Saving...' : 'Continue'),
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

class _AddressField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _AddressField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (value) =>
            (value == null || value.trim().isEmpty) ? 'Enter $label' : null,
      ),
    );
  }
}
