import 'package:bus_tracking/service/api.dart';

class HomeApi {
  static Future<dynamic> clockin(
      {Map<String, dynamic>? params,
      required Map<String, dynamic>? map}) async {
    final client = await Api.restClient(params: params);
    var data = client.postAppScript(map);
    return data;
  }
}
