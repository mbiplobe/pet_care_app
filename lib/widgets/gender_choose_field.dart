import 'package:flutter/material.dart';
import 'package:pet_care_app/utils/colors.dart';

class GenderChooseField extends StatefulWidget {
  String? genderController;
  GenderChooseField({super.key, required this.genderController});

  @override
  State<GenderChooseField> createState() => _GenderChooseFieldState();
}

class _GenderChooseFieldState extends State<GenderChooseField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        dropdownColor: kDarkPaynesGrey,
        style: const TextStyle(fontSize: 16, color: kMistyRose, fontFamily: 'PTRoot'),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          hintStyle: const TextStyle(fontSize: 16, color: kOffWhite),
          hintText: 'gender',
          fillColor: kDarkPaynesGrey,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        value: widget.genderController,
        items: const [
          DropdownMenuItem(
            value: 'male',
            child: Text('Male'),
          ),
          DropdownMenuItem(
            value: 'female',
            child: Text('Female'),
          ),
        ],
        onChanged: (choosedGender) {
          widget.genderController = choosedGender!;
        });
  }
}
