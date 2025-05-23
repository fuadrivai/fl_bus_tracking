import 'package:floor/floor.dart';

@Entity(tableName: 'Students')
class Student {
  @primaryKey
  String? childID;
  String? childName;
  String? childDivision;
  String? childDriver;
  String? mode;
  @ColumnInfo(name: 'action')
  String? action;

  Student({
    this.childName,
    this.childID,
    this.childDivision,
    this.childDriver,
    this.mode,
    this.action,
  });

  Student.fromJson(Map<String, dynamic> json) {
    childName = json['childName'];
    childID = json['childID'];
    childDivision = json['childDivision'];
    childDriver = json['childDriver'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['childName'] = childName;
    data['childID'] = childID;
    data['childDivision'] = childDivision;
    data['childDriver'] = childDriver;
    data['action'] = action;
    return data;
  }
}
