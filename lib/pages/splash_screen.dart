import 'package:flutter/material.dart';
import 'package:pet_care_app/pages/pet_profiles_page.dart';
import 'package:pet_care_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const PetProfilesPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kMistyRose,
        body: Container(
          child: const Center(
              child: Text(
            'P',
            style: TextStyle(
              fontSize: 100,
              fontFamily: 'Yunga',
              color: kPaynesGrey,
            ),
          )),
        ));
  }
}
