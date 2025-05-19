import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/service/api.dart';

class StudentApi {
  static Future<Pickup> getPickups({Map<String, dynamic>? params}) async {
    final client = await Api.restClient(params: params);
    var data = client.getPickups();
    return data;
  }

  static Future<dynamic> saveChecklist(
      {Map<String, dynamic>? params, required List<Student> students}) async {
    final client = await Api.restClient(params: params);
    var data = client.saveCheckList(students);
    return data;
  }
}
