import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_app/utils/colors.dart';

class DatePickField extends StatelessWidget {
  final String inputName;
  final TextEditingController controller;
  final Color fontColor;
  final String? initialValue;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  const DatePickField(
      {super.key,
      required this.inputName,
      required this.controller,
      this.initialValue,
      required this.firstDate,
      required this.lastDate,
      required this.initialDate,
      required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        fillColor: kDarkPaynesGrey,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            locale: const Locale('en', 'GB'),
            initialEntryMode: DatePickerEntryMode.calendarOnly);
        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          controller.text = formattedDate;
        }
      },
      keyboardType: TextInputType.none,
      enableInteractiveSelection: false,
      showCursor: false,
    );
  }
}
