import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


class WeatherMain {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  WeatherMain({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.grndLevel,
    this.humidity,
    this.pressure,
    this.seaLevel,
    this.tempMax,
  });

  factory WeatherMain.fromJson(Map<String, dynamic> main) {
    return WeatherMain(
      temp: main["temp"].toDouble(),
      feelsLike: main["feels_like"].toDouble(),
      tempMin: main["temp_min"].toDouble(),
      grndLevel: main["grnd_level"],
      humidity: main["humidity"],
      pressure: main["pressure"],
      seaLevel: main["sea_level"],
      tempMax: main["temp_max"].toDouble(),
    );
  }
}

class Weather {
  final String cityName;
  final WeatherMain main;
  final String description;
  final int date;
  final String weatherIcon;

  Weather({
    this.cityName,
    @required this.main,
    @required this.description,
    @required this.date,
    this.weatherIcon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    
    return Weather(
      cityName: json["name"],
      main: WeatherMain.fromJson(json["main"]),
      description: json["weather"][0]["description"],
      date: json["dt"],
      weatherIcon: json["weather"][0]["icon"],
    );
  }

  String get formatDate {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    return DateFormat.yMMMd().format(dateTime);
  }
}
