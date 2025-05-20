import 'package:bus_tracking/models/model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("")
  Future<Pickup> getPickups();

  @POST("")
  Future<dynamic> postAppScript(@Body() dynamic data);
}
