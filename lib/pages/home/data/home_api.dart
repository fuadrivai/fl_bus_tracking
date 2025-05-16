import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/service/api.dart';

class ClockInPrayerApi {
  static Future<List<Pickup>> getPickups() async {
    final client = await Api.restClient();
    var data = client.getPickups();
    return data;
  }
}
