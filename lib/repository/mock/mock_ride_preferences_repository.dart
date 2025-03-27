import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

import '../../dummy_data/dummy_data.dart';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = fakeRidePrefs;

  @override
  Future<List<RidePreference>> getPastPreferences() {
    return Future.value(_pastPreferences);
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    _pastPreferences.add(preference);
  }

  @override
  Future<void> savePreference(RidePreference preference) async {
    _pastPreferences.add(preference);
  }
}

//I'm Choosing the first one because it's to easy for the admin need to update the data in the database 
//so when we fetch the data from the database it will be updated up to date.
//If we use the second one, we need to update the data in the code and then push it to the repository. 
//It's not efficient for the admin to update the data in the code and then push it to the repository. 
//So, the first one is the best choice for this case.