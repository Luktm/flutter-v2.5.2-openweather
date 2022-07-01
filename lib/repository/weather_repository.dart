import 'dart:convert';

import 'package:flutter_weather_app/helpers/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather_app/models/weather.dart';

class WeatherRepository {
  final String _baseUrl = "http://api.openweathermap.org/data/2.5";
  final String _appId = "2778451ca473d0e827cf301f662fc188";
  final String _units = "metric";

  Future<Weather> fetchWeather({
    String cityName,
    double lat,
    double long,
  }) async {
    try {
        String url = "$_baseUrl/weather?lat=$lat&lon=$long&appid=$_appId&units=$_units";

      if (cityName != null) {
        url =  "$url&q=$cityName";
      }

      // current location or selected location
      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final weather = Weather.fromJson(json);
      return weather;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Weather>> fetchFiveDaysForecastWeather({
    String cityName,
    double lat,
    double long,
  }) async {
    try {

      String url =  "$_baseUrl/forecast?lat=$lat&lon=$long&appid=$_appId&units=$_units";

      if(cityName != null) {
        url = url + "&q=$cityName";
      }

      final Uri uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body)["list"] as List;

      final weathers =
          json.map((weather) => Weather.fromJson(weather)).toList();
      return weathers;
    } catch (e) {
      return Future.error(e);
    }
  }
}
