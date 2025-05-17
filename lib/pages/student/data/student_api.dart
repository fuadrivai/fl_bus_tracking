import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/service/api.dart';

class StudentApi {
  static Future<List<Pickup>> getPickups({Map<String, dynamic>? params}) async {
    final client = await Api.restClient(params: params);
    var data = client.getPickups();
    return data;
  }
}
