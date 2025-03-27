import 'package:flutter/material.dart';

import '../../model/ride/ride.dart';
import '../../model/ride/ride_filter.dart';
import '../../model/ride/ride_pref.dart';
import '../../repository/ride_preferences_repository.dart';
import '../../repository/rides_repository.dart';


class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  final List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;
  final RidesRepository ridesRepository;

  RidesPreferencesProvider({
    required this.repository,
    required this.ridesRepository,
  }) {
    _pastPreferences.addAll(repository.getPastPreferences());
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference == pref) return;
    _currentPreference = pref;
    _addPreference(pref);
    notifyListeners();
  }

  void _addPreference(RidePreference preference) {
    _pastPreferences.remove(preference); // Ensure uniqueness
    _pastPreferences.insert(
        _pastPreferences.length, preference); // Add to the end
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

  List<Ride> getRidesFor(RidePreference pref, RideFilter? filter) {
    return ridesRepository.getRidesFor(pref, filter);
  }
}