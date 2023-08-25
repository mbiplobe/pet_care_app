import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_care_app/utils/colors.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String species;
  final String imageUrl;
  final double weight;
  final int age;
  VoidCallback onClick;
  VoidCallback onRemove;

  ProfileCard({
    super.key,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.weight,
    required this.age,
    required this.onClick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * (1 - 0.70 / 2),
            height: MediaQuery.of(context).size.height * 0.36,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    imageUrl != '' ? FileImage(File(imageUrl)) as ImageProvider : const AssetImage('images/pettle.png'),
              ),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
          ),
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width * (1 - 0.70 / 2),
              height: MediaQuery.of(context).size.height * 0.18,
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: kMistyRose,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        color: kDarkPaynesGrey,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nohemi',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$species | $age ${age < 2 ? 'year' : 'years'} | $weight kg'.toUpperCase(),
                      style: const TextStyle(
                        color: kDarkPaynesGrey,
                        fontSize: 20,
                        height: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 5,
              child: PopupMenuButton(
                color: kPaynesGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: kMistyRose,
                            size: 24,
                          ),
                          TextButton(
                            onPressed: onRemove,
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 20,
                                color: kMistyRose,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: kDarkPaynesGrey,
                  size: 26,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
