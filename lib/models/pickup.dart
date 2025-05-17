import 'package:bus_tracking/models/model.dart';

class Pickup {
  String? nopol;
  String? driverName;
  List<Student>? students;

  Pickup({this.nopol, this.driverName, this.students});

  Pickup.fromJson(Map<String, dynamic> json) {
    nopol = json['nopol'];
    driverName = json['driverName'];
    if (json['students'] != null) {
      students = <Student>[];
      json['students'].forEach((v) {
        students!.add(Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nopol'] = nopol;
    data['driverName'] = driverName;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
