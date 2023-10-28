
import 'package:cloud_firestore/cloud_firestore.dart';

class PregnancyInfoModel {
  final String babyName;
  final DateTime dueDate;
  final String gender;

  const PregnancyInfoModel({
    required this.babyName,
    required this.dueDate,
    required this.gender,
  });

  factory PregnancyInfoModel.fromJson(Map<String, dynamic> json) {
    Timestamp timestamp =json["DueDate"] as Timestamp;
    final DateTime dateTime = timestamp.toDate();
    return PregnancyInfoModel(
      babyName: json["Baby's name"],
      dueDate: DateTime.parse(dateTime.toString()),
      gender: json["Gender"],
    );
  }
//

//
}
