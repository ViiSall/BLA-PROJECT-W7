import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository/local/local_ride_preferences_repository.dart';
import 'data/repository/mock/mock_locations_repository.dart';
import 'data/repository/mock/mock_rides_repository.dart';
import 'service/locations_service.dart';
import 'service/rides_service.dart';

import 'ui/provider/rides_preferences_provider.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
//import 'service/ride_prefs_service.dart';
import 'ui/theme/theme.dart';

void main() {
  // 1 - Initialize the services
  //RidePrefService.initialize(MockRidePreferencesRepository());
  LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  // 2- Run the UI
  runApp(
    MultiProvider(
      providers: [
        // Provide the RidesPreferencesProvider
        ChangeNotifierProvider(
          create: (_) => RidesPreferencesProvider(
            repository:
                LocalRidePreferencesRepository(), // Pass the mock repository
            ridesRepository: MockRidesRepository(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(body: RidePrefScreen()),
    );
  }
}
