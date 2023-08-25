import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_app/utils/colors.dart';
import 'package:pet_care_app/widgets/custom_textfield.dart';
import 'package:pet_care_app/widgets/datePickField.dart';
import 'package:pet_care_app/widgets/full_event_details_widget.dart';
import 'package:pet_care_app/widgets/transparent_appbar.dart';
import '../data/data.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});
  static const routeName = '/events';

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _petBox = Hive.box('boxPet');

  @override
  Widget build(BuildContext context) {
    final firstDateController = TextEditingController();
    firstDateController.text = '';
    final firstTextController = TextEditingController();
    firstTextController.text = '';
    final secondDateController = TextEditingController();
    secondDateController.text = '';
    final secondTextController = TextEditingController();
    secondTextController.text = '';
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Pet petData = arguments['pet'] as Pet;
    final String eventCategoryName = arguments['key'] as String;

    void removeEvent(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: kPaynesGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: const Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kOffWhite,
                  fontSize: 26,
                ),
              ),
              contentPadding: const EdgeInsets.all(20),
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
                              color: kOffWhite,
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
                            setState(
                              () {
                                switch (eventCategoryName) {
                                  case 'treatment':
                                    setState(() {
                                      petData.treatments!.removeAt(index);
                                    });
                                    updatePetData();
                                    updateUpcomingEvents();
                                    updateNotifications();
                                    break;
                                  case 'vaccination':
                                    setState(() {
                                      petData.vaccinations!.removeAt(index);
                                    });
                                    updatePetData();
                                    updateUpcomingEvents();
                                    updateNotifications();
                                    break;
                                  case 'deworming':
                                    setState(() {
                                      petData.dewormings!.removeAt(index);
                                    });
                                    updatePetData();
                                    updateUpcomingEvents();
                                    updateNotifications();
                                    break;
                                  case 'allergy':
                                    setState(() {
                                      petData.allergies!.removeAt(index);
                                    });
                                    updatePetData();
                                    updateUpcomingEvents();
                                    updateNotifications();
                                    break;
                                }

                                Navigator.of(context).pop();
                              },
                            );
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

    void showAlertDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kPaynesGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: eventCategoryName == 'treatment'
                    ? kPrimaryTreatment
                    : eventCategoryName == 'vaccination'
                        ? kPrimaryVaccination
                        : eventCategoryName == 'deworming'
                            ? kPrimaryDeworming
                            : eventCategoryName == 'allergy'
                                ? kPrimaryAllergy
                                : kOffWhite,
                fontSize: 22,
              ),
            ),
            contentPadding: const EdgeInsets.all(40),
          );
        },
      );
    }

    void saveForm() {
      switch (eventCategoryName) {
        case 'treatment':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            final Treatment newTreatment = Treatment(
              diseaseDate: DateFormat('dd/MM/yyyy').parse(firstDateController.text),
              diseaseName: firstTextController.text,
              usedTreatment: secondTextController.text,
            );
            petData.treatments!.add(newTreatment);
            petData.treatments!.sort((a, b) => a.diseaseDate.compareTo(b.diseaseDate));
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
          break;
        case 'vaccination':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty ||
              secondDateController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            final Vaccination newVaccination = Vaccination(
              pet: petData,
              executionDate: DateFormat('dd/MM/yyyy').parse(firstDateController.text),
              againstWhat: firstTextController.text,
              curativeName: secondTextController.text,
              nextTimeDate: DateFormat('dd/MM/yyyy').parse(secondDateController.text),
            );
            petData.vaccinations!.add(newVaccination);
            petData.vaccinations!.sort((a, b) => a.executionDate.compareTo(b.executionDate));
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();

          break;
        case 'deworming':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty ||
              secondDateController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            final Deworming newDeworming = Deworming(
              pet: petData,
              executionDate: DateFormat('dd/MM/yyyy').parse(firstDateController.text),
              againstWhat: firstTextController.text,
              curativeName: secondTextController.text,
              nextTimeDate: DateFormat('dd/MM/yyyy').parse(secondDateController.text),
            );
            petData.dewormings!.add(newDeworming);
            petData.dewormings!.sort((a, b) => a.executionDate.compareTo(b.executionDate));
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
          break;
        case 'allergy':
          if (firstDateController.text.isEmpty || firstTextController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            final Allergy newAllergy = Allergy(
                allergyDate: DateFormat('dd/MM/yyyy').parse(firstDateController.text),
                allergyName: firstTextController.text);
            petData.allergies!.add(newAllergy);
            petData.allergies!.sort((a, b) => a.allergyDate.compareTo(b.allergyDate));
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
      }
      firstDateController.clear();
      firstTextController.clear();
      secondTextController.clear();
      secondDateController.clear();
      Navigator.pop(context);
    }

    void saveEditedForm(int index) {
      switch (eventCategoryName) {
        case 'treatment':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            petData.treatments![index].diseaseDate = DateFormat('dd/MM/yyyy').parse(firstDateController.text);
            petData.treatments![index].diseaseName = firstTextController.text;
            petData.treatments![index].usedTreatment = secondTextController.text;
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
          break;
        case 'vaccination':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty ||
              secondDateController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            petData.vaccinations![index].petName = petData.name;
            petData.vaccinations![index].executionDate = DateFormat('dd/MM/yyyy').parse(firstDateController.text);
            petData.vaccinations![index].againstWhat = firstTextController.text;
            petData.vaccinations![index].curativeName = secondTextController.text;
            petData.vaccinations![index].nextTimeDate = DateFormat('dd/MM/yyyy').parse(secondDateController.text);
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
          break;
        case 'deworming':
          if (firstDateController.text.isEmpty ||
              firstTextController.text.isEmpty ||
              secondTextController.text.isEmpty ||
              secondDateController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            petData.dewormings![index].petName = petData.name;
            petData.dewormings![index].executionDate = DateFormat('dd/MM/yyyy').parse(firstDateController.text);
            petData.dewormings![index].againstWhat = firstTextController.text;
            petData.dewormings![index].curativeName = secondTextController.text;
            petData.dewormings![index].nextTimeDate = DateFormat('dd/MM/yyyy').parse(secondDateController.text);
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
          break;
        case 'allergy':
          if (firstDateController.text.isEmpty || firstTextController.text.isEmpty) {
            showAlertDialog('Not enough data');
            return;
          }
          setState(() {
            petData.allergies![index].allergyDate = DateFormat('dd/MM/yyyy').parse(firstDateController.text);
            petData.allergies![index].allergyName = firstTextController.text;
          });
          updatePetData();
          updateUpcomingEvents();
          updateNotifications();
      }
      firstDateController.clear();
      firstTextController.clear();
      secondTextController.clear();
      secondDateController.clear();
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: eventCategoryName == 'treatment'
          ? kPrimaryTreatment
          : eventCategoryName == 'vaccination'
              ? kPrimaryVaccination
              : eventCategoryName == 'deworming'
                  ? kPrimaryDeworming
                  : eventCategoryName == 'allergy'
                      ? kPrimaryAllergy
                      : kPaynesGrey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.07,
        ),
        child: TransparentAppBar(
          statusIconsColor: SystemUiOverlayStyle.dark,
          iconColor: eventCategoryName == 'treatment'
              ? kSecondaryTreatment
              : eventCategoryName == 'vaccination'
                  ? kSecondaryVaccination
                  : eventCategoryName == 'deworming'
                      ? kSecondaryDeworming
                      : eventCategoryName == 'allergy'
                          ? kSecondaryAllergy
                          : kPaynesGrey,
          actionsIcons: const [],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                eventCategoryName == 'allergy'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${petData.name}'s".toUpperCase(),
                            style: TextStyle(
                              fontSize: 34,
                              color: kPaynesGrey.withOpacity(0.9),
                              fontFamily: 'Cannonade',
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            "allergies".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 34,
                              color: kSecondaryAllergy,
                              fontFamily: 'Cannonade',
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${petData.name}'s".toUpperCase(),
                            style: TextStyle(
                              fontSize: 34,
                              letterSpacing: 1,
                              color: kPaynesGrey.withOpacity(0.8),
                              fontFamily: 'Cannonade',
                            ),
                          ),
                          Text(
                            "${eventCategoryName}s".toUpperCase(),
                            style: TextStyle(
                              fontSize: 34,
                              letterSpacing: 1,
                              fontFamily: 'Cannonade',
                              color: eventCategoryName == 'treatment'
                                  ? kSecondaryTreatment
                                  : eventCategoryName == 'vaccination'
                                      ? kSecondaryVaccination
                                      : eventCategoryName == 'deworming'
                                          ? kSecondaryDeworming
                                          : kPaynesGrey,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 30),
                Center(
                  child: buildAddNewEventButton(context, eventCategoryName, firstDateController, firstTextController,
                      secondTextController, secondDateController, petData, saveForm),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: petData.treatments != null && eventCategoryName == 'treatment'
                        ? petData.treatments!.length
                        : petData.vaccinations != null && eventCategoryName == 'vaccination'
                            ? petData.vaccinations!.length
                            : petData.dewormings != null && eventCategoryName == 'deworming'
                                ? petData.dewormings!.length
                                : petData.allergies != null && eventCategoryName == 'allergy'
                                    ? petData.allergies!.length
                                    : 0,
                    itemBuilder: (BuildContext context, int index) {
                      switch (eventCategoryName) {
                        case 'treatment':
                          return FullEventDetailsWidget(
                            color: kSecondaryTreatment,
                            onRemove: (context) => removeEvent(index),
                            firstDate: petData.treatments![index].diseaseDate,
                            firstText: petData.treatments![index].diseaseName,
                            secondText: petData.treatments![index].usedTreatment,
                            editIcon: buildEditEventButton(
                              context,
                              eventCategoryName,
                              firstDateController,
                              firstTextController,
                              secondTextController,
                              secondDateController,
                              formatDate(petData.treatments![index].diseaseDate, [dd, '/', mm, '/', yyyy]),
                              petData.treatments![index].diseaseName,
                              petData.treatments![index].usedTreatment,
                              '',
                              petData,
                              () => saveEditedForm(index),
                              index,
                            ),
                          );

                        case 'vaccination':
                          return FullEventDetailsWidget(
                            color: kSecondaryVaccination,
                            onRemove: (context) => removeEvent(index),
                            firstDate: petData.vaccinations![index].executionDate,
                            firstText: petData.vaccinations![index].againstWhat,
                            secondText: petData.vaccinations![index].curativeName,
                            secondDate: petData.vaccinations![index].nextTimeDate,
                            editIcon: buildEditEventButton(
                                context,
                                eventCategoryName,
                                firstDateController,
                                firstTextController,
                                secondTextController,
                                secondDateController,
                                formatDate(petData.vaccinations![index].executionDate, [dd, '/', mm, '/', yyyy]),
                                petData.vaccinations![index].againstWhat,
                                petData.vaccinations![index].curativeName,
                                formatDate(petData.vaccinations![index].nextTimeDate, [dd, '/', mm, '/', yyyy]),
                                petData,
                                () => saveEditedForm(index),
                                index),
                          );
                        case 'deworming':
                          return FullEventDetailsWidget(
                            color: kSecondaryDeworming,
                            onRemove: (context) => removeEvent(index),
                            firstDate: petData.dewormings![index].executionDate,
                            firstText: petData.dewormings![index].againstWhat,
                            secondText: petData.dewormings![index].curativeName,
                            secondDate: petData.dewormings![index].nextTimeDate,
                            editIcon: buildEditEventButton(
                                context,
                                eventCategoryName,
                                firstDateController,
                                firstTextController,
                                secondTextController,
                                secondDateController,
                                formatDate(petData.dewormings![index].executionDate, [dd, '/', mm, '/', yyyy]),
                                petData.dewormings![index].againstWhat,
                                petData.dewormings![index].curativeName,
                                formatDate(petData.dewormings![index].nextTimeDate, [dd, '/', mm, '/', yyyy]),
                                petData,
                                () => saveEditedForm(index),
                                index),
                          );
                        case 'allergy':
                          return FullEventDetailsWidget(
                            color: kSecondaryAllergy,
                            onRemove: (context) => removeEvent(index),
                            firstDate: petData.allergies![index].allergyDate,
                            firstText: petData.allergies![index].allergyName,
                            editIcon: buildEditEventButton(
                              context,
                              eventCategoryName,
                              firstDateController,
                              firstTextController,
                              secondTextController,
                              secondDateController,
                              formatDate(petData.allergies![index].allergyDate, [dd, '/', mm, '/', yyyy]),
                              petData.allergies![index].allergyName,
                              '',
                              '',
                              petData,
                              () => saveEditedForm(index),
                              index,
                            ),
                          );
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildAddNewEventButton(
    BuildContext context,
    String eventCategoryName,
    TextEditingController firstDateController,
    TextEditingController firstTextController,
    TextEditingController secondTextController,
    TextEditingController secondDateController,
    Pet pet,
    VoidCallback onConfirm) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
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
                        Text(
                          "new $eventCategoryName".toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            height: 2,
                            color: eventCategoryName == 'treatment'
                                ? kPrimaryTreatment
                                : eventCategoryName == 'vaccination'
                                    ? kPrimaryVaccination
                                    : eventCategoryName == 'deworming'
                                        ? kPrimaryDeworming
                                        : eventCategoryName == 'allergy'
                                            ? kPrimaryAllergy
                                            : kOffWhite,
                          ),
                        ),
                        const SizedBox(height: 30),
                        eventCategoryName == 'vaccination' || eventCategoryName == 'deworming'
                            ? Column(
                                children: [
                                  DatePickField(
                                    inputName: 'date',
                                    controller: firstDateController,
                                    fontColor: eventCategoryName == 'vaccination'
                                        ? kPrimaryVaccination
                                        : eventCategoryName == 'deworming'
                                            ? kPrimaryDeworming
                                            : kMistyRose,
                                    initialDate: DateTime.now(),
                                    firstDate: pet.birthDate,
                                    lastDate: DateTime.now(),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    inputName: 'against'.toUpperCase(),
                                    controller: firstTextController,
                                    isNumericKeyboard: false,
                                    fontColor: eventCategoryName == 'vaccination'
                                        ? kPrimaryVaccination
                                        : eventCategoryName == 'deworming'
                                            ? kPrimaryDeworming
                                            : kMistyRose,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    inputName: 'curative name'.toUpperCase(),
                                    controller: secondTextController,
                                    isNumericKeyboard: false,
                                    fontColor: eventCategoryName == 'vaccination'
                                        ? kPrimaryVaccination
                                        : eventCategoryName == 'deworming'
                                            ? kPrimaryDeworming
                                            : kMistyRose,
                                  ),
                                  const SizedBox(height: 20),
                                  DatePickField(
                                    inputName: 'next time date',
                                    controller: secondDateController,
                                    fontColor: eventCategoryName == 'vaccination'
                                        ? kPrimaryVaccination
                                        : eventCategoryName == 'deworming'
                                            ? kPrimaryDeworming
                                            : kMistyRose,
                                    initialDate: DateTime.now(),
                                    firstDate: pet.birthDate,
                                    lastDate: DateTime.now().add(const Duration(days: 50 * 365)),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                            : Container(),
                        eventCategoryName == 'treatment'
                            ? Column(
                                children: [
                                  DatePickField(
                                    inputName: 'date',
                                    controller: firstDateController,
                                    fontColor: kPrimaryTreatment,
                                    initialDate: DateTime.now(),
                                    firstDate: pet.birthDate,
                                    lastDate: DateTime.now(),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    inputName: 'name'.toUpperCase(),
                                    controller: firstTextController,
                                    isNumericKeyboard: false,
                                    fontColor: kPrimaryTreatment,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    inputName: 'used $eventCategoryName'.toUpperCase(),
                                    controller: secondTextController,
                                    isNumericKeyboard: false,
                                    fontColor: kPrimaryTreatment,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                            : Container(),
                        eventCategoryName == 'allergy'
                            ? Column(
                                children: [
                                  DatePickField(
                                    inputName: 'date',
                                    controller: firstDateController,
                                    fontColor: kPrimaryAllergy,
                                    initialDate: DateTime.now(),
                                    firstDate: pet.birthDate,
                                    lastDate: DateTime.now(),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    inputName: 'name'.toUpperCase(),
                                    controller: firstTextController,
                                    isNumericKeyboard: false,
                                    fontColor: kPrimaryAllergy,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                            : Container(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: eventCategoryName == 'treatment'
                                ? kSecondaryTreatment
                                : eventCategoryName == 'vaccination'
                                    ? kSecondaryVaccination
                                    : eventCategoryName == 'deworming'
                                        ? kSecondaryDeworming
                                        : eventCategoryName == 'allergy'
                                            ? kSecondaryAllergy
                                            : kOffWhite,
                            elevation: 0,
                            foregroundColor: kOffWhite,
                            padding: const EdgeInsets.all(22),
                          ),
                          onPressed: onConfirm,
                          child: const Text(
                            'CONFIRM',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width * (1 - 0.40 / 2),
      decoration: BoxDecoration(
        color: eventCategoryName == 'treatment'
            ? kSecondaryTreatment
            : eventCategoryName == 'vaccination'
                ? kSecondaryVaccination
                : eventCategoryName == 'deworming'
                    ? kSecondaryDeworming
                    : eventCategoryName == 'allergy'
                        ? kSecondaryAllergy
                        : kPaynesGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.add,
              size: 30,
              color: kOffWhite,
            ),
            Text(
              'new $eventCategoryName'.toUpperCase(),
              style: TextStyle(
                color: eventCategoryName == 'treatment'
                    ? kPrimaryTreatment
                    : eventCategoryName == 'vaccination'
                        ? kPrimaryVaccination
                        : eventCategoryName == 'deworming'
                            ? kPrimaryDeworming
                            : eventCategoryName == 'allergy'
                                ? kPrimaryAllergy
                                : kPaynesGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

buildEditEventButton(
    BuildContext context,
    String eventCategoryName,
    TextEditingController firstDateController,
    TextEditingController firstTextController,
    TextEditingController secondTextController,
    TextEditingController secondDateController,
    String firstDateControllerText,
    String firstTextControllerText,
    String secondTextControllerText,
    String secondDateControllerText,
    Pet pet,
    VoidCallback onConfirm,
    int idx) {
  return IconButton(
    icon: const Icon(
      IconlyBold.editSquare,
      size: 34,
      color: kOffWhite,
    ),
    onPressed: () {
      firstDateController.text = firstDateControllerText;
      firstTextController.text = firstTextControllerText;
      secondTextController.text = secondTextControllerText;
      secondDateController.text = secondDateControllerText;
      showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
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
                          Text(
                            "edit $eventCategoryName".toUpperCase(),
                            style: TextStyle(
                              fontSize: 30,
                              color: eventCategoryName == 'treatment'
                                  ? kPrimaryTreatment
                                  : eventCategoryName == 'vaccination'
                                      ? kPrimaryVaccination
                                      : eventCategoryName == 'deworming'
                                          ? kPrimaryDeworming
                                          : eventCategoryName == 'allergy'
                                              ? kPrimaryAllergy
                                              : kOffWhite,
                            ),
                          ),
                          const SizedBox(height: 30),
                          eventCategoryName == 'vaccination' || eventCategoryName == 'deworming'
                              ? Column(
                                  children: [
                                    DatePickField(
                                      inputName: 'date',
                                      controller: firstDateController,
                                      fontColor: eventCategoryName == 'vaccination'
                                          ? kPrimaryVaccination
                                          : eventCategoryName == 'deworming'
                                              ? kPrimaryDeworming
                                              : kMistyRose,
                                      initialDate: eventCategoryName == 'vaccination'
                                          ? pet.vaccinations![idx].executionDate
                                          : eventCategoryName == 'deworming'
                                              ? pet.dewormings![idx].executionDate
                                              : DateTime.now(),
                                      firstDate: pet.birthDate,
                                      lastDate: DateTime.now(),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      inputName: 'against'.toUpperCase(),
                                      controller: firstTextController,
                                      isNumericKeyboard: false,
                                      fontColor: eventCategoryName == 'vaccination'
                                          ? kPrimaryVaccination
                                          : eventCategoryName == 'deworming'
                                              ? kPrimaryDeworming
                                              : kMistyRose,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      inputName: 'curative name'.toUpperCase(),
                                      controller: secondTextController,
                                      isNumericKeyboard: false,
                                      fontColor: eventCategoryName == 'vaccination'
                                          ? kPrimaryVaccination
                                          : eventCategoryName == 'deworming'
                                              ? kPrimaryDeworming
                                              : kMistyRose,
                                    ),
                                    const SizedBox(height: 20),
                                    DatePickField(
                                      inputName: 'next time date',
                                      controller: secondDateController,
                                      fontColor: eventCategoryName == 'vaccination'
                                          ? kPrimaryVaccination
                                          : eventCategoryName == 'deworming'
                                              ? kPrimaryDeworming
                                              : kMistyRose,
                                      initialDate: eventCategoryName == 'vaccination'
                                          ? pet.vaccinations![idx].nextTimeDate
                                          : eventCategoryName == 'deworming'
                                              ? pet.dewormings![idx].nextTimeDate
                                              : DateTime.now(),
                                      firstDate: pet.birthDate,
                                      lastDate: DateTime.now().add(const Duration(days: 50 * 365)),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(),
                          eventCategoryName == 'treatment'
                              ? Column(
                                  children: [
                                    DatePickField(
                                      inputName: 'date',
                                      controller: firstDateController,
                                      fontColor: kPrimaryTreatment,
                                      initialDate: pet.treatments![idx].diseaseDate,
                                      firstDate: pet.birthDate,
                                      lastDate: DateTime.now(),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      inputName: 'name'.toUpperCase(),
                                      controller: firstTextController,
                                      isNumericKeyboard: false,
                                      fontColor: kPrimaryTreatment,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      inputName: 'used $eventCategoryName'.toUpperCase(),
                                      controller: secondTextController,
                                      isNumericKeyboard: false,
                                      fontColor: kPrimaryTreatment,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(),
                          eventCategoryName == 'allergy'
                              ? Column(
                                  children: [
                                    DatePickField(
                                      inputName: 'date',
                                      controller: firstDateController,
                                      fontColor: kPrimaryAllergy,
                                      initialDate: pet.allergies![idx].allergyDate,
                                      firstDate: pet.birthDate,
                                      lastDate: DateTime.now(),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      inputName: 'name'.toUpperCase(),
                                      controller: firstTextController,
                                      isNumericKeyboard: false,
                                      fontColor: kPrimaryAllergy,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: eventCategoryName == 'treatment'
                                  ? kSecondaryTreatment
                                  : eventCategoryName == 'vaccination'
                                      ? kSecondaryVaccination
                                      : eventCategoryName == 'deworming'
                                          ? kSecondaryDeworming
                                          : eventCategoryName == 'allergy'
                                              ? kSecondaryAllergy
                                              : kOffWhite,
                              elevation: 0,
                              foregroundColor: kOffWhite,
                              padding: const EdgeInsets.all(22),
                            ),
                            onPressed: onConfirm,
                            child: const Text(
                              'CONFIRM',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    },
  );
}
