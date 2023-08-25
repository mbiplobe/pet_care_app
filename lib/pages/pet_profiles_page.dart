import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_care_app/data/data.dart';
import 'package:pet_care_app/pages/pet_details_page.dart';
import 'package:pet_care_app/pages/upcoming_events_page.dart';
import 'package:pet_care_app/utils/colors.dart';
import 'package:pet_care_app/widgets/custom_textfield.dart';
import 'package:pet_care_app/widgets/datePickField.dart';
import 'package:pet_care_app/widgets/profile_card.dart';
import 'package:pet_care_app/services/notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'dart:async';

class PetProfilesPage extends StatefulWidget {
  const PetProfilesPage({super.key});
  static const routeName = '/profiles';

  @override
  State<PetProfilesPage> createState() => _PetProfilesPageState();
}

class _PetProfilesPageState extends State<PetProfilesPage> {
  late final LocalNotificationService service;
  final _petBox = Hive.box('boxPet');
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    if (_petBox.get('pettle') != null) {
      loadPetData();
    }
    super.initState();
  }

  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  final birthDateController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final microchipNumberController = TextEditingController();
  String? genderController;
  final ScrollController _scrollController = ScrollController();

  String imagePath = '';

  void removePet(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kPaynesGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Text(
              "Are you sure you want delete ${petData[index].name}'s profile with all data?",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kOffWhite,
                fontSize: 26,
              ),
            ),
            contentPadding: const EdgeInsets.all(40),
            actions: <Widget>[
              ButtonBar(
                buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: <Widget>[
                  Column(
                    children: [
                      TextButton(
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 22,
                            color: kOffWhite,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Container(
                          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: kMistyRose,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 22,
                              color: kDarkPaynesGrey,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            petData.removeAt(index);
                            birthdays.removeAt(index);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                          updatePetData();
                          updateUpcomingEvents();
                          updateNotifications();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> saveForm() async {
    nameController.text.isEmpty ||
            speciesController.text.isEmpty ||
            birthDateController.text.isEmpty ||
            weightController.text.isEmpty ||
            colorController.text.isEmpty ||
            genderController == null ||
            imagePath.isEmpty
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
        : setState(
            () {
              final Pet newPet = Pet(
                name: nameController.text,
                species: speciesController.text,
                birthDate: DateFormat('dd/MM/yyyy').parse(birthDateController.text),
                weight: double.parse(weightController.text.replaceAll(',', '.')),
                color: colorController.text,
                gender: genderController.toString(),
                imageUrl: imagePath,
                microchipNumber: microchipNumberController.text.isEmpty ? null : microchipNumberController.text,
                vaccinations: [],
                dewormings: [],
                allergies: [],
                treatments: [],
              );
              petData.add(newPet);

              nameController.clear();
              speciesController.clear();
              birthDateController.clear();
              weightController.clear();
              colorController.clear();
              microchipNumberController.clear();

              setState(() {
                genderController = null;
              });

              final Birthday birthday = Birthday(pet: newPet);
              birthdays.add(birthday);

              Future.delayed(const Duration(milliseconds: 200), () {
                _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 2000), curve: Curves.fastOutSlowIn);
              });
              Future.delayed(const Duration(milliseconds: 0), () {
                _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 2000), curve: Curves.fastOutSlowIn);
              });
              Navigator.pop(context);
            },
          );
    updatePetData();
    updateUpcomingEvents();
    updateNotifications();
  }

  @override
  Widget build(BuildContext context) {
    updateUpcomingEvents();
    updateNotifications();
    // int notificationID = 0;
    // for (dynamic event in upcomingEvents) {
    //   if (event is Birthday || event is Deworming || event is Vaccination) {
    //     service.showScheduledNotification(
    //         id: notificationID,
    //         title: 'Mark Your calendar',
    //         body: "${event.petName}'s ${event.eventName} is just a week away",
    //         notificationDate: event.nextTimeDate);
    //     notificationID++;
    //     print(notificationID);
    //   }
    // }
    // print(notificationID);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: kPaynesGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: buildUpcomingButton(context),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: buildStartText(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.175),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.54,
                child: buildProfilePicker(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Center(child: buildAddNewProfileCardButton(context)),
          ],
        ),
      ),
    );
  }

  Widget buildUpcomingButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          UpcomingEventsPage.routeName,
        ).then((_) {
          setState(() {});
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: kMistyRose,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const ImageIcon(
                AssetImage('images/calendar.png'),
                color: kDarkPaynesGrey,
                size: 28,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'UPCOMING:',
                    style: TextStyle(
                      color: kDarkPaynesGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cannonade',
                    ),
                  ),
                  //const SizedBox(height: 15),
                  // Container(
                  //   padding: EdgeInsets.zero,
                  //   height: 2,
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   decoration: const BoxDecoration(
                  //     color: kDarkPaynesGrey,
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(60),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 15),
                  Text(
                    upcomingEvents.isEmpty ? "" : "${upcomingEvents[0].petName}'s ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kDarkPaynesGrey,
                      fontSize: 16,
                      fontFamily: 'Cannonade',
                    ),
                  ),
                  Text(
                    upcomingEvents.isEmpty ? "" : "${upcomingEvents[0].eventName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kDarkPaynesGrey,
                      fontSize: 16,
                      fontFamily: 'Cannonade',
                    ),
                  ),
                ],
              ),
              const Icon(
                TablerIcons.arrow_right,
                color: kDarkPaynesGrey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStartText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHOOSE A PET,',
          style: TextStyle(
            color: kOffWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 0.6,
            fontFamily: 'Cannonade',
            //letterSpacing: 3,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'THAT YOU WANT TO TAKE CARE OF',
          style: TextStyle(
            color: kMistyRose,
            fontSize: 12,
            height: 1,
            fontFamily: 'Nohemi',
          ),
        ),
      ],
    );
  }

  Widget buildProfilePicker() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: petData.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(right: index == petData.length - 1 ? 0.0 : 40.0),
          child: ProfileCard(
            onRemove: () {
              removePet(index);
            },
            onClick: () {
              Navigator.pushNamed(
                context,
                PetDetailsPage.routeName,
                arguments: petData[index],
              ).then((_) {
                setState(() {});
              });
            },
            name: petData[index].name,
            species: petData[index].species,
            imageUrl: petData[index].imageUrl,
            weight: petData[index].weight,
            age: DateTime.now().difference(petData[index].birthDate).inDays ~/ 365,
          ),
        );
      },
    );
  }

  Widget buildAddNewProfileCardButton(BuildContext context) {
    return InkWell(
      onTap: () {
        imagePath = '';

        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                reverse: true,
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
                        imagePath = imageFile.path;
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
                                    child: imagePath != ''
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(30.0),
                                            child: Image.file(
                                              File(imagePath),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            TablerIcons.photo_edit,
                                            size: 60,
                                            color: kDarkPaynesGrey,
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
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now(),
                                ),
                                const SizedBox(height: 10),
                                buildGenderChooseField(),
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
                                  onPressed: saveForm,
                                  child: Text(
                                    'Add profile'.toUpperCase(),
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
      child: Container(
        width: MediaQuery.of(context).size.width * (1 - 0.70 / 2),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, width: 3, color: kOffWhite),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                TablerIcons.plus,
                size: 22,
                color: kOffWhite,
              ),
              Text(
                'NEW PROFILE',
                style: TextStyle(
                  color: kMistyRose,
                  fontSize: 20,
                  height: 1,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildGenderChooseField() {
    return DropdownButtonFormField(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        dropdownColor: kDarkPaynesGrey,
        style: const TextStyle(fontSize: 16, color: kMistyRose, fontFamily: 'PTRoot'),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          hintStyle: const TextStyle(fontSize: 14, color: kOffWhite),
          hintText: 'gender',
          fillColor: kDarkPaynesGrey,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
        });
  }
}
