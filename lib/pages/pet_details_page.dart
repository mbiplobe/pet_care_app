import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_care_app/data/data.dart';
import 'package:pet_care_app/pages/event_details_page.dart';
import 'package:pet_care_app/utils/colors.dart';
import 'package:pet_care_app/widgets/custom_textfield.dart';
import 'package:pet_care_app/widgets/datePickField.dart';
import 'package:pet_care_app/widgets/last_event_from_category_widget.dart';
import 'package:pet_care_app/widgets/scrollable_pet_info_sheet.dart';
import 'package:pet_care_app/widgets/single_pet_data_tag.dart';
import 'package:pet_care_app/widgets/transparent_appbar.dart';
import 'package:path/path.dart' as Path;

class PetDetailsPage extends StatefulWidget {
  const PetDetailsPage({super.key});
  static const routeName = '/pet';

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  final _petBox = Hive.box('boxPet');

  @override
  Widget build(BuildContext context) {
    final petData = ModalRoute.of(context)!.settings.arguments as Pet;
    final nameController = TextEditingController(text: petData.name);
    final speciesController = TextEditingController(text: petData.species);
    final birthDateController = TextEditingController(text: formatDate(petData.birthDate, [dd, '/', mm, '/', yyyy]));
    final weightController = TextEditingController(text: petData.weight.toString());
    final colorController = TextEditingController(text: petData.color);
    String? genderController = petData.gender;
    final microchipNumberController = TextEditingController(
        text: petData.microchipNumber != null ? petData.microchipNumber! : petData.microchipNumber);
    String? newImagePath = petData.imageUrl;

    Future<void> saveEditedForm() async {
      Birthday? matchingBirthday;
      for (Birthday birthday in birthdays) {
        if (birthday.petName == petData.name) {
          matchingBirthday = birthday;
          break;
        }
      }

      for (Deworming deworming in petData.dewormings!) {
        if (deworming.petName == petData.name) {
          setState(() {
            deworming.petName = nameController.text;
          });
        }
      }

      for (Vaccination vaccination in petData.vaccinations!) {
        if (vaccination.petName == petData.name) {
          setState(() {
            vaccination.petName = nameController.text;
          });
        }
      }
      nameController.text.isEmpty ||
              birthDateController.text.isEmpty ||
              speciesController.text.isEmpty ||
              birthDateController.text.isEmpty ||
              weightController.text.isEmpty ||
              colorController.text.isEmpty
          ? showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kPaynesGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  content: const Text(
                    'Not enough data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kMistyRose,
                      fontSize: 22,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(40),
                );
              },
            )
          : setState(() {
              petData.name = nameController.text;
              petData.species = speciesController.text;
              petData.birthDate = DateFormat('dd/MM/yyyy').parse(birthDateController.text);
              petData.weight = double.parse(weightController.text.replaceAll(',', '.'));
              petData.color = colorController.text;
              petData.gender = genderController.toString();
              try {
                if (newImagePath!.isNotEmpty) {
                  petData.imageUrl = newImagePath!;
                }
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Text(
                          'Picture error',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    });
              }
              petData.microchipNumber = microchipNumberController.text.isEmpty ? null : microchipNumberController.text;

              if (matchingBirthday != null) {
                matchingBirthday.petName = nameController.text;
                matchingBirthday.nextTimeDate =
                    DateTime(DateTime.now().year, petData.birthDate.month, petData.birthDate.day);
                if (matchingBirthday.nextTimeDate.isBefore(DateTime.now())) {
                  matchingBirthday.nextTimeDate = matchingBirthday.nextTimeDate.add(const Duration(days: 365));
                }
              }
              Navigator.pop(context);
            });
      updatePetData();
      updateUpcomingEvents();
      updateNotifications();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.07,
        ),
        child: TransparentAppBar(
          statusIconsColor: SystemUiOverlayStyle.light,
          iconColor: Colors.black.withOpacity(0.8),
          actionsIcons: [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              icon: Icon(
                TablerIcons.adjustments,
                size: 32,
                color: Colors.black.withOpacity(0.8),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            Future getImage() async {
                              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (image == null) return;

                              final directory = await getApplicationDocumentsDirectory();
                              final name = Path.basename(image.path);
                              final imageFile = File('${directory.path}/$name');
                              await File(image.path).copy(imageFile.path);

                              setState(() {
                                newImagePath = imageFile.path;
                              });
                            }

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              decoration: const BoxDecoration(
                                color: kPaynesGrey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.zero,
                                    height: 5,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: kOffWhite.withOpacity(0.3),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        InkWell(
                                          onTap: getImage,
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              color: kMistyRose,
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30.0),
                                              child: Image.file(
                                                File(newImagePath!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          inputName: 'name',
                                          controller: nameController,
                                          isNumericKeyboard: false,
                                          fontColor: kMistyRose,
                                        ),
                                        const SizedBox(height: 10),
                                        DatePickField(
                                          inputName: 'date of birth',
                                          controller: birthDateController,
                                          fontColor: kMistyRose,
                                          initialDate: petData.birthDate,
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime.now(),
                                        ),
                                        const SizedBox(height: 10),
                                        DropdownButtonFormField(
                                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                                            dropdownColor: kDarkPaynesGrey,
                                            style:
                                                const TextStyle(fontSize: 14, color: kMistyRose, fontFamily: 'PTRoot'),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(14),
                                              hintStyle: const TextStyle(fontSize: 16, color: kOffWhite),
                                              hintText: 'gender',
                                              fillColor: kDarkPaynesGrey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                            ),
                                            value: genderController,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'male',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.male_rounded,
                                                      size: 14,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Male',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: 'female',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.female_rounded,
                                                      size: 14,
                                                      color: Colors.pinkAccent,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Female',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onChanged: (choosedGender) {
                                              genderController = choosedGender!;
                                            }),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          inputName: 'species',
                                          controller: speciesController,
                                          isNumericKeyboard: false,
                                          fontColor: kMistyRose,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          inputName: 'weight',
                                          controller: weightController,
                                          isNumericKeyboard: true,
                                          fontColor: kMistyRose,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          inputName: 'color',
                                          controller: colorController,
                                          isNumericKeyboard: false,
                                          fontColor: kMistyRose,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          inputName: 'microchip number',
                                          controller: microchipNumberController,
                                          isNumericKeyboard: false,
                                          fontColor: kMistyRose,
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            backgroundColor: kMistyRose,
                                            elevation: 0,
                                            foregroundColor: kDarkPaynesGrey,
                                            padding: const EdgeInsets.all(22),
                                          ),
                                          onPressed: saveEditedForm,
                                          child: Text(
                                            'Update profile'.toUpperCase(),
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: newImagePath != ''
                ? Image.file(
                    File(petData.imageUrl),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/pettle.png',
                    fit: BoxFit.cover,
                  ),
          ),
          ScrollablePetInfoSheet(
            name: petData.name,
            species: petData.species,
            birthDate: petData.birthDate,
            weight: petData.weight,
            color: petData.color,
            microchipNumber: petData.microchipNumber,
            childrenWidgets: [
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          petData.name.toUpperCase(),
                          style: const TextStyle(
                            color: kOffWhite,
                            fontSize: 46,
                            fontFamily: 'Cannonade',
                          ),
                        ),
                        const SizedBox(width: 5),
                        petData.gender == 'male'
                            ? const Icon(
                                Icons.male_rounded,
                                size: 32,
                                color: Colors.blueAccent,
                              )
                            : petData.gender == 'female'
                                ? const Icon(
                                    Icons.female_rounded,
                                    size: 32,
                                    color: Colors.pinkAccent,
                                  )
                                : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              petData.microchipNumber == null
                  ? Container()
                  : Text(
                      '#${((petData.microchipNumber).toString())}'.toUpperCase(),
                      style: const TextStyle(
                        color: kOffWhite,
                        fontSize: 24,
                        letterSpacing: 4,
                      ),
                    ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SinglePetDataTag(data: petData.color, dataName: 'color'),
                  SinglePetDataTag(data: petData.species, dataName: 'species'),
                  SinglePetDataTag(
                    data:
                        '${(DateTime.now().difference(petData.birthDate).inDays ~/ 365).toString()} ${(DateTime.now().difference(petData.birthDate).inDays ~/ 365) < 2 ? 'year' : 'years'}',
                    dataName: 'age',
                  ),
                  SinglePetDataTag(data: '${petData.weight.toString()} kg', dataName: 'weight'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'LATEST EVENTS',
                style: TextStyle(
                  color: kOffWhite.withOpacity(0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LastEventFromCategoryWidget(
                    color: kPrimaryTreatment,
                    textColor: kSecondaryTreatment,
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        EventDetailsPage.routeName,
                        arguments: {
                          'pet': petData,
                          'key': 'treatment',
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    eventDetailDate:
                        petData.treatments!.isNotEmpty ? petData.treatments!.last.diseaseDate : DateTime(0),
                    eventDetailName: petData.treatments!.isNotEmpty ? petData.treatments!.last.diseaseName : '',
                    imageName: 'images/treatment.png',
                  ),
                  const SizedBox(height: 30),
                  LastEventFromCategoryWidget(
                    color: kPrimaryVaccination,
                    textColor: kSecondaryVaccination,
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        EventDetailsPage.routeName,
                        arguments: {
                          'pet': petData,
                          'key': 'vaccination',
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    eventDetailDate:
                        petData.vaccinations!.isNotEmpty ? petData.vaccinations!.last.executionDate : DateTime(0),
                    eventDetailName: petData.vaccinations!.isNotEmpty ? petData.vaccinations!.last.againstWhat : '',
                    imageName: 'images/vaccination.png',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LastEventFromCategoryWidget(
                    color: kPrimaryDeworming,
                    textColor: kSecondaryDeworming,
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        EventDetailsPage.routeName,
                        arguments: {
                          'pet': petData,
                          'key': 'deworming',
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    eventDetailDate:
                        petData.dewormings!.isNotEmpty ? petData.dewormings!.last.executionDate : DateTime(0),
                    eventDetailName: petData.dewormings!.isNotEmpty ? petData.dewormings!.last.againstWhat : '',
                    imageName: 'images/deworming.png',
                  ),
                  const SizedBox(height: 30),
                  LastEventFromCategoryWidget(
                    color: kPrimaryAllergy,
                    textColor: kSecondaryAllergy,
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        EventDetailsPage.routeName,
                        arguments: {
                          'pet': petData,
                          'key': 'allergy',
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    eventDetailDate: petData.allergies!.isNotEmpty ? petData.allergies!.last.allergyDate : DateTime(0),
                    eventDetailName: petData.allergies!.isNotEmpty ? petData.allergies!.last.allergyName : '',
                    imageName: 'images/allergy.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
