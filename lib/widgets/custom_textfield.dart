import 'package:flutter/material.dart';
import 'package:pet_care_app/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String inputName;
  final TextEditingController controller;
  final String? initialValue;
  final Color fontColor;
  bool isNumericKeyboard;

  CustomTextField({
    super.key,
    required this.inputName,
    required this.controller,
    this.initialValue,
    required this.isNumericKeyboard,
    required this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 32,
      scrollPadding: const EdgeInsets.only(bottom: 80),
      controller: controller,
      style: TextStyle(
        color: fontColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(14),
        hintStyle: const TextStyle(fontSize: 14, color: kOffWhite),
        hintText: inputName.toLowerCase(),
        counterText: '',
        fillColor: kDarkPaynesGrey,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      keyboardType: isNumericKeyboard ? TextInputType.number : TextInputType.text,
    );
  }
}
