// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetAdapter extends TypeAdapter<Pet> {
  @override
  final int typeId = 0;

  @override
  Pet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pet(
      name: fields[0] as String,
      species: fields[1] as String,
      birthDate: fields[2] as DateTime,
      weight: fields[3] as double,
      color: fields[4] as String,
      gender: fields[5] as String,
      imageUrl: fields[6] as String,
      microchipNumber: fields[7] as String?,
      vaccinations: (fields[9] as List?)?.cast<Vaccination>(),
      dewormings: (fields[10] as List?)?.cast<Deworming>(),
      allergies: (fields[11] as List?)?.cast<Allergy>(),
      treatments: (fields[8] as List?)?.cast<Treatment>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pet obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.species)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.microchipNumber)
      ..writeByte(8)
      ..write(obj.treatments)
      ..writeByte(9)
      ..write(obj.vaccinations)
      ..writeByte(10)
      ..write(obj.dewormings)
      ..writeByte(11)
      ..write(obj.allergies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TreatmentAdapter extends TypeAdapter<Treatment> {
  @override
  final int typeId = 1;

  @override
  Treatment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Treatment(
      diseaseDate: fields[0] as DateTime,
      diseaseName: fields[1] as String,
      usedTreatment: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Treatment obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.diseaseDate)
      ..writeByte(1)
      ..write(obj.diseaseName)
      ..writeByte(2)
      ..write(obj.usedTreatment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreatmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VaccinationAdapter extends TypeAdapter<Vaccination> {
  @override
  final int typeId = 2;

  @override
  Vaccination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vaccination(
      executionDate: fields[2] as DateTime,
      curativeName: fields[3] as String,
      againstWhat: fields[4] as String,
      nextTimeDate: fields[5] as DateTime,
    )
      ..eventName = fields[0] as String
      ..petName = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Vaccination obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.petName)
      ..writeByte(2)
      ..write(obj.executionDate)
      ..writeByte(3)
      ..write(obj.curativeName)
      ..writeByte(4)
      ..write(obj.againstWhat)
      ..writeByte(5)
      ..write(obj.nextTimeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaccinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DewormingAdapter extends TypeAdapter<Deworming> {
  @override
  final int typeId = 3;

  @override
  Deworming read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deworming(
      executionDate: fields[2] as DateTime,
      curativeName: fields[3] as String,
      againstWhat: fields[4] as String,
      nextTimeDate: fields[5] as DateTime,
    )
      ..eventName = fields[0] as String
      ..petName = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Deworming obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.petName)
      ..writeByte(2)
      ..write(obj.executionDate)
      ..writeByte(3)
      ..write(obj.curativeName)
      ..writeByte(4)
      ..write(obj.againstWhat)
      ..writeByte(5)
      ..write(obj.nextTimeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DewormingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllergyAdapter extends TypeAdapter<Allergy> {
  @override
  final int typeId = 4;

  @override
  Allergy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Allergy(
      allergyDate: fields[0] as DateTime,
      allergyName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Allergy obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.allergyDate)
      ..writeByte(1)
      ..write(obj.allergyName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BirthdayAdapter extends TypeAdapter<Birthday> {
  @override
  final int typeId = 5;

  @override
  Birthday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Birthday()
      ..eventName = fields[0] as String
      ..petName = fields[1] as String?
      ..nextTimeDate = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Birthday obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.petName)
      ..writeByte(2)
      ..write(obj.nextTimeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
