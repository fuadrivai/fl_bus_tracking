import 'package:bus_tracking/injector/injector.dart';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/service/restclient.dart';
import 'package:dio/dio.dart';

class Api {
  static const String baseUrl =
      "https://script.google.com/macros/s/AKfycbyA6FiaIikGHjaLZolIiuFAHQztPArWeaiEAtCttOnJQrGtOTQgKD-cOXt6zOSomMidBg/exec";

  static restClient({Map<String, dynamic>? params, String? baseurl}) async {
    final dio = Dio();
    dio.interceptors.clear();
    dio.interceptors.add(DioInterceptors(dio));
    dio.options.headers["Authorization"] = await Session.get("token");
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Accept"] = "*/*";
    dio.options.queryParameters = params ?? {};
    return RestClient(dio, baseUrl: baseurl ?? baseUrl);
  }
}
