import 'package:hive/hive.dart';
import 'package:pet_care_app/services/notifications.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Pet {
  @HiveField(0)
  String name;
  @HiveField(1)
  String species;
  @HiveField(2)
  DateTime birthDate;
  @HiveField(3)
  double weight;
  @HiveField(4)
  String color;
  @HiveField(5)
  String gender;
  @HiveField(6)
  String imageUrl;
  @HiveField(7)
  String? microchipNumber;
  @HiveField(8)
  List<Treatment>? treatments;
  @HiveField(9)
  List<Vaccination>? vaccinations;
  @HiveField(10)
  List<Deworming>? dewormings;
  @HiveField(11)
  List<Allergy>? allergies;

  Pet({
    required this.name,
    required this.species,
    required this.birthDate,
    required this.weight,
    required this.color,
    required this.gender,
    required this.imageUrl,
    this.microchipNumber,
    this.vaccinations,
    this.dewormings,
    this.allergies,
    this.treatments,
  });
}

@HiveType(typeId: 1)
class Treatment {
  @HiveField(0)
  DateTime diseaseDate;
  @HiveField(1)
  String diseaseName;
  @HiveField(2)
  String usedTreatment;

  Treatment({
    required this.diseaseDate,
    required this.diseaseName,
    required this.usedTreatment,
  });
}

@HiveType(typeId: 2)
class Vaccination {
  @HiveField(0)
  String eventName;
  @HiveField(1)
  String? petName;
  @HiveField(2)
  DateTime executionDate;
  @HiveField(3)
  String curativeName;
  @HiveField(4)
  String againstWhat;
  @HiveField(5)
  DateTime nextTimeDate;
  Pet? pet;
  Vaccination({
    this.pet,
    required this.executionDate,
    required this.curativeName,
    required this.againstWhat,
    required this.nextTimeDate,
  })  : petName = pet?.name,
        eventName = 'vaccination';
}

@HiveType(typeId: 3)
class Deworming {
  @HiveField(0)
  String eventName;
  @HiveField(1)
  String? petName;
  @HiveField(2)
  DateTime executionDate;
  @HiveField(3)
  String curativeName;
  @HiveField(4)
  String againstWhat;
  @HiveField(5)
  DateTime nextTimeDate;
  Pet? pet;
  Deworming({
    this.pet,
    required this.executionDate,
    required this.curativeName,
    required this.againstWhat,
    required this.nextTimeDate,
  })  : petName = pet?.name,
        eventName = 'deworming';
}

@HiveType(typeId: 4)
class Allergy {
  @HiveField(0)
  DateTime allergyDate;
  @HiveField(1)
  String allergyName;

  Allergy({
    required this.allergyDate,
    required this.allergyName,
  });
}

@HiveType(typeId: 5)
class Birthday {
  @HiveField(0)
  String eventName;
  @HiveField(1)
  String? petName;
  @HiveField(2)
  DateTime nextTimeDate;
  Pet? pet;
  Birthday({this.pet})
      : petName = pet?.name,
        eventName = 'birthday',
        nextTimeDate = DateTime(DateTime.now().year, pet?.birthDate.month ?? 1, pet?.birthDate.day ?? 1);
}

List<Birthday> birthdays = [];
List<Pet> petData = [];
List<dynamic> upcomingEvents = [];

final _petBox = Hive.box('boxPet');

void loadPetData() {
  var petBox = Hive.box('boxPet');
  petData = List<Pet>.from(petBox.get('pettle', defaultValue: <dynamic>[]));
  birthdays = List<Birthday>.from(petBox.get('birthday', defaultValue: <dynamic>[]));
}

updatePetData() async {
  await _petBox.put('pettle', petData);
  await _petBox.put('birthday', birthdays);
}

Future<void> updateUpcomingEvents() async {
  upcomingEvents.clear();
  for (Birthday birthday in birthdays) {
    if (birthday.nextTimeDate.year < DateTime.now().year) {
      birthday.nextTimeDate = DateTime(DateTime.now().year, birthday.nextTimeDate.month, birthday.nextTimeDate.day);
      if (birthday.nextTimeDate.isBefore(DateTime.now())) {
        birthday.nextTimeDate = birthday.nextTimeDate.add(const Duration(days: 365));
      }
    }
    if (birthday.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
        birthday.nextTimeDate.isAfter(DateTime.now())) {
      upcomingEvents.add(birthday);
    }
  }
  for (Pet pet in petData) {
    for (Deworming deworming in pet.dewormings!) {
      if (deworming.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
          deworming.nextTimeDate.isAfter(DateTime.now())) {
        upcomingEvents.add(deworming);
      }
    }

    for (Vaccination vaccination in pet.vaccinations!) {
      if (vaccination.nextTimeDate.isBefore(DateTime.now().add(const Duration(days: 6 * 30))) &&
          vaccination.nextTimeDate.isAfter(DateTime.now())) {
        upcomingEvents.add(vaccination);
      }
    }
  }
  upcomingEvents.sort((a, b) => a.nextTimeDate.compareTo(b.nextTimeDate));
  print(upcomingEvents.toString());
}

Future<void> updateNotifications() async {
  LocalNotificationService service = LocalNotificationService();
  int notificationID = 0;
  for (dynamic event in upcomingEvents) {
    if (event is Birthday || event is Deworming || event is Vaccination) {
      if (event.nextTimeDate.difference(DateTime.now()).inHours >= 157) {
        service.showScheduledNotification(
            id: notificationID,
            title: 'MARK YOUR CALENDAR',
            body: "${event.petName}'s ${event.eventName} is just a week away",
            notificationDate: event.nextTimeDate);
        notificationID++;
        print(notificationID);
      }
    }
  }
}
