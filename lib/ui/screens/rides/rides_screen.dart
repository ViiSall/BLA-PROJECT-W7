import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import '../../provider/rides_preferences_provider.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  // Current filter for rides
  final RideFilter currentFilter = RideFilter();
  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final ridePreference =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    ridePreference.setCurrentPreference(newPreference);
  }

  void onPreferencePressed(
      BuildContext context, RidePreference? currentPreference) async {
    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      onRidePrefSelected(context, newPreference);
    }
  }

  void onFilterPressed() {}

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ridePreference = Provider.of<RidesPreferencesProvider>(context);
    final RidePreference? currentRidePreference =
        ridePreference.currentPreference;

    final List<Ride> matchingRides = ridePreference.getRidesFor(
      currentRidePreference!,
      currentFilter,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            RidePrefBar(
              ridePreference: currentRidePreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentRidePreference),
              onFilterPressed: onFilterPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
