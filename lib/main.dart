import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_care_app/pages/pet_details_page.dart';
import 'package:pet_care_app/pages/pet_profiles_page.dart';
import 'package:pet_care_app/pages/event_details_page.dart';
import 'package:pet_care_app/pages/splash_screen.dart';
import 'package:pet_care_app/pages/upcoming_events_page.dart';
import 'package:pet_care_app/utils/colors.dart';
import 'package:pet_care_app/data/data.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(TreatmentAdapter());
  Hive.registerAdapter(VaccinationAdapter());
  Hive.registerAdapter(DewormingAdapter());
  Hive.registerAdapter(AllergyAdapter());
  Hive.registerAdapter(BirthdayAdapter());
  var box = await Hive.openBox('boxPet');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pettle',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        dialogTheme:
            const DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
        brightness: Brightness.dark,
        primarySwatch: materialMistyRose,
        fontFamily: 'PTRoot',
      ),
      initialRoute: '/splash',
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        PetProfilesPage.routeName: (context) => const PetProfilesPage(),
        UpcomingEventsPage.routeName: (context) => const UpcomingEventsPage(),
        PetDetailsPage.routeName: (context) => const PetDetailsPage(),
        EventDetailsPage.routeName: (context) => const EventDetailsPage(),
      },
    );
  }
}
