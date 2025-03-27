import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../provider/async_value.dart';
import '../../provider/rides_preferences_provider.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../../widgets/errors/bla_error_screen.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final ridePreference =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    ridePreference.setCurrentPreference(newPreference);
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ridePreference = Provider.of<RidesPreferencesProvider>(context);
    final RidePreference? currentRidePreference =
        ridePreference.currentPreference;
    final AsyncValue<List<RidePreference>> pastPreferences =
        ridePreference.pastPreferences;
    if (pastPreferences.state == AsyncValueState.error) {
      return BlaError(message: "No connection. Try Later");
    } else if (pastPreferences.state == AsyncValueState.loading) {
      return const BlaError(message: "Loading...");
    } else {
      final List<RidePreference> preferences =
          pastPreferences.data!.reversed.toList();
      return Stack(
        children: [
          const BlaBackground(),
          Column(
            children: [
              const SizedBox(height: BlaSpacings.m),
              Text(
                "Your pick of rides at low price",
                style: BlaTextStyles.heading.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPreference) =>
                          onRidePrefSelected(context, newPreference),
                    ),
                    const SizedBox(height: BlaSpacings.m),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: preferences.length,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: preferences[index],
                          onPressed: () => onRidePrefSelected(
                              context, pastPreferences.data![index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
