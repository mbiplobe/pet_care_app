import 'package:flutter/material.dart';

const kDarkPaynesGrey = Color(0xFF1D252D);
const kPaynesGrey = Color(0xFF3A4454);
const kLightGrey = Color(0xFFB9B5B5);
const kOffWhite = Color(0xFFCFDBD5);
const kMistyRose = Color(0xFFF5DDDD);

MaterialColor materialMistyRose = MaterialColor(kMistyRose.value, {
  50: kMistyRose.withOpacity(0.1),
  100: kMistyRose.withOpacity(0.2),
  200: kMistyRose.withOpacity(0.3),
  300: kMistyRose.withOpacity(0.4),
  400: kMistyRose.withOpacity(0.5),
  500: kMistyRose.withOpacity(0.6),
  600: kMistyRose.withOpacity(0.7),
  700: kMistyRose.withOpacity(0.8),
  800: kMistyRose.withOpacity(0.9),
  900: kMistyRose.withOpacity(1),
});

const kPrimaryTreatment = Color(0xFFE7BDEF);
const kSecondaryTreatment = Color(0xFFC86CAF);

const kPrimaryVaccination = Color(0xFF6399FF);
const kSecondaryVaccination = Color(0xFF5638FF);

const kPrimaryDeworming = Color(0xFFFF9238);
const kSecondaryDeworming = Color(0xFFA43400);

const kPrimaryAllergy = Color(0xFF48D390);
const kSecondaryAllergy = Color(0xFF145133);
