import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/ride/ride_pref.dart';
import '../../dto/ride_preference_dto.dart';

class LocalRidePreferencesRepository {
  static const String _preferencesKey = 'ride_preferences';

  Future<List<RidePreference>> getPastPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addPastPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPreferences = await getPastPreferences();
    existingPreferences.remove(preference);
    existingPreferences.add(preference);
    await prefs.setStringList(
      _preferencesKey,
      existingPreferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }
}
