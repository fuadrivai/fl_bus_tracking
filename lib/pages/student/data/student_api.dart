import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/service/api.dart';

class StudentApi {
  static Future<Pickup> getPickups({Map<String, dynamic>? params}) async {
    final client = await Api.restClient(params: params);
    var data = client.getPickups();
    return data;
  }

  static Future<dynamic> saveChecklist(
      {Map<String, dynamic>? params,
      required List<Map<String, dynamic>> students}) async {
    final client = await Api.restClient(params: params);
    var data = client.postAppScript(students);
    return data;
  }

  static Future<dynamic> startTracking(
      {Map<String, dynamic>? params,
      required Map<String, dynamic> location}) async {
    final client = await Api.restClient(params: params);
    var data = client.postAppScript(location);
    return data;
  }
}
