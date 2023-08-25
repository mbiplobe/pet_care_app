// import 'package:pet_care_app/data/data.dart';

// class UpcomingEvents {
//   List<dynamic> upcomingEvents = [];

//   void updateUpcomingEvents() {
//     for (Birthday birthday in birthdays) {
//       if (birthday.nextTimeDate.year < DateTime.now().year) {
//         birthday.nextTimeDate = DateTime(DateTime.now().year, birthday.nextTimeDate.month, birthday.nextTimeDate.day);
//         if (birthday.nextTimeDate.isBefore(DateTime.now())) {
//           birthday.nextTimeDate = birthday.nextTimeDate.add(const Duration(days: 365));
//         }
//       }
//       if (birthday.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
//           birthday.nextTimeDate.isAfter(DateTime.now())) {
//         upcomingEvents.add(birthday);
//       }
//     }
//     for (Pet pet in petData) {
//       for (Deworming deworming in pet.dewormings!) {
//         if (deworming.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
//             deworming.nextTimeDate.isAfter(DateTime.now())) {
//           upcomingEvents.add(deworming);
//         }
//       }

//       for (Vaccination vaccination in pet.vaccinations!) {
//         if (vaccination.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
//             vaccination.nextTimeDate.isAfter(DateTime.now())) {
//           upcomingEvents.add(vaccination);
//         }
//       }
//     }
//     upcomingEvents.sort((a, b) => a.nextTimeDate.compareTo(b.nextTimeDate));
//   }

//   // updateUpcomingEvents();
//   // print(upcomingEvents.toList());

//   // Future<void> sendScheduledNotifications() async {
//   // int notificationID = 0;
//   // for (dynamic event in upcomingEvents) {
//   //   if (event is Birthday || event is Deworming || event is Vaccination) {
//   //     service.showScheduledNotification(
//   //         id: notificationID,
//   //         title: 'Mark Your calendar',
//   //         body: "${event.petName}'s ${event.eventName} is just a week away",
//   //         notificationDate: event.nextTimeDate);
//   //     notificationID++;
//   //   }
//   // }
//   // }
// }
