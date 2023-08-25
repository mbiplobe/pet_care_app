import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_app/data/data.dart';
import 'package:pet_care_app/utils/colors.dart';
import 'package:pet_care_app/widgets/transparent_appbar.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});
  static const routeName = '/upcoming';

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  // late final LocalNotificationService service;

  @override
  // void initState() {
  //  // service = LocalNotificationService();
  //   //service.intialize();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final petBox = Hive.box('boxPet');
    //List<dynamic> upcomingEvents = [];

    // void updateUpcomingEvents() {
    //   for (Birthday birthday in birthdays) {
    //     if (birthday.nextTimeDate.year < DateTime.now().year) {
    //       birthday.nextTimeDate = DateTime(DateTime.now().year, birthday.nextTimeDate.month, birthday.nextTimeDate.day);
    //       if (birthday.nextTimeDate.isBefore(DateTime.now())) {
    //         birthday.nextTimeDate = birthday.nextTimeDate.add(const Duration(days: 365));
    //       }
    //     }
    //     if (birthday.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
    //         birthday.nextTimeDate.isAfter(DateTime.now())) {
    //       upcomingEvents.add(birthday);
    //     }
    //   }
    //   for (Pet pet in petData) {
    //     for (Deworming deworming in pet.dewormings!) {
    //       if (deworming.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
    //           deworming.nextTimeDate.isAfter(DateTime.now())) {
    //         upcomingEvents.add(deworming);
    //       }
    //     }

    //     for (Vaccination vaccination in pet.vaccinations!) {
    //       if (vaccination.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
    //           vaccination.nextTimeDate.isAfter(DateTime.now())) {
    //         upcomingEvents.add(vaccination);
    //       }
    //     }
    //   }
    //   upcomingEvents.sort((a, b) => a.nextTimeDate.compareTo(b.nextTimeDate));
    // }

    // updateUpcomingEvents();
    // print(upcomingEvents.toList());

    // // Future<void> sendScheduledNotifications() async {
    // int notificationID = 0;
    // for (dynamic event in upcomingEvents) {
    //   if (event is Birthday || event is Deworming || event is Vaccination) {
    //     service.showScheduledNotification(
    //         id: notificationID,
    //         title: 'Mark Your calendar',
    //         body: "${event.petName}'s ${event.eventName} is just a week away",
    //         notificationDate: event.nextTimeDate);
    //     notificationID++;
    //   }
    // }
    // // }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.07,
        ),
        child: const TransparentAppBar(
          statusIconsColor: SystemUiOverlayStyle.dark,
          iconColor: kDarkPaynesGrey,
          actionsIcons: [],
        ),
      ),
      backgroundColor: kMistyRose,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildStartText(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Center(
            //   child: ElevatedButton(
            //       onPressed: () async {
            //         service.showScheduledNotification(id: 0, title: 'SENTINO', body: 'RATATATA', seconds: 4);
            //       },
            //       child: const Text('ZAPLANUJ POWIADOMIENIE')),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.74,
                child: upcomingEvents.isNotEmpty
                    ? buildUpcomingEventsList(upcomingEvents)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/nocalendar.png',
                            color: kDarkPaynesGrey.withOpacity(0.4),
                            height: MediaQuery.of(context).size.height * 0.74,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildUpcomingEventsList(List<dynamic> upcomingEvents) {
    return ListView.builder(
      itemCount: upcomingEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (DateFormat.yMMMMEEEEd().format(upcomingEvents[index].nextTimeDate)),
                  style: const TextStyle(
                    fontSize: 26,
                    color: kDarkPaynesGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (upcomingEvents[index] is Birthday
                      ? "${upcomingEvents[index].petName}'s ${upcomingEvents[index].eventName}"
                      : "${upcomingEvents[index].petName}'s ${upcomingEvents[index].eventName} for ${upcomingEvents[index].againstWhat}"),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkPaynesGrey,
                    height: 1,
                  ),
                ),
                Text(
                  '${(upcomingEvents[index].nextTimeDate.difference(DateTime.now()).inDays)} days ${(upcomingEvents[index].nextTimeDate.difference(DateTime.now()).inHours % 24)} hours ${(upcomingEvents[index].nextTimeDate.difference(DateTime.now()).inMinutes % 60)} minutes to go'
                      .toLowerCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'PTRoot',
                    fontWeight: FontWeight.bold,
                    color: kDarkPaynesGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.zero,
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: kDarkPaynesGrey,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildStartText() {
    return const Text(
      'UPCOMING \nEVENTS',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: kDarkPaynesGrey,
        fontFamily: 'Nohemi',
        letterSpacing: 2,
      ),
    );
  }
}
