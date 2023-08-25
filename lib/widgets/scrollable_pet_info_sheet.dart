import 'package:flutter/material.dart';
import 'package:pet_care_app/utils/colors.dart';

class ScrollablePetInfoSheet extends StatelessWidget {
  final String name;
  final String species;
  final DateTime birthDate;
  final double weight;
  final String color;
  final String? microchipNumber;

  final List<Widget> childrenWidgets;

  const ScrollablePetInfoSheet({
    super.key,
    required this.childrenWidgets,
    required this.name,
    required this.species,
    required this.birthDate,
    required this.weight,
    required this.color,
    required this.microchipNumber,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.88,
      minChildSize: 0.6,
      builder: ((context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: kPaynesGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.zero,
                    height: 5,
                    width: 100,
                    decoration: BoxDecoration(
                      color: kOffWhite.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(60),
                      ),
                    ),
                  ),
                ),
                ...childrenWidgets,
              ]),
            ),
          ),
        );
      }),
    );
  }
}
