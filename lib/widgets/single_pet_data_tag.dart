import 'package:flutter/material.dart';
import 'package:pet_care_app/utils/colors.dart';

class SinglePetDataTag extends StatelessWidget {
  final String data;
  final String dataName;
  const SinglePetDataTag({super.key, required this.data, required this.dataName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 36,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 6, top: 6),
      decoration: const BoxDecoration(
        color: kOffWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              data.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: kDarkPaynesGrey,
              ),
            ),
          ),
          Text(
            dataName.toUpperCase(),
            style: TextStyle(
                fontSize: 7,
                color: kDarkPaynesGrey.withOpacity(
                  0.7,
                )),
          ),
        ],
      ),
    );
  }
}
