import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_app/helpers/db_helper.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repository/weather_repository.dart';

import 'city_cubit.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final _weatherRepository = WeatherRepository();

  // if want to call from other cubit, the external cubit must pass from the widget into here
  WeatherCubit() : super(WeatherInitial());

  final String _tableName = "favorite_city";

  Future<void> fetchWeather(
      {String cityName,
      double lat,
      double long,
      }) async {
    try {
      emit(WeatherLoading());

      final Weather getCurrentWeather = await _weatherRepository.fetchWeather(
        cityName: cityName,
        lat: lat,
        long: long,
      );

      final List<Weather> getForecastWeather =
          await _weatherRepository.fetchFiveDaysForecastWeather(
        cityName: cityName,
        lat: lat,
        long: long,
      );

      emit(
        WeatherLoaded(
          weather: getCurrentWeather,
          weatherList: getForecastWeather,
        ),
      );
    } on FormatException catch (err) {
      emit(WeatherError(err));
    }
  }

  Future<void> addFavoriteWeather() async {
    if (state is WeatherLoaded) {
      final WeatherLoaded weatherLoaded = state as WeatherLoaded;

      DBHelper.insert(_tableName, {
        "city": weatherLoaded.weather.cityName,
        "weather_icon": weatherLoaded.weather.weatherIcon,
        "description": weatherLoaded.weather.description,
        "temp": weatherLoaded.weather.main.temp,
        "date": weatherLoaded.weather.date
      });

      getLocalFavoriteCity();
    }
  }

  Future getLocalFavoriteCity() async {
    
    try {
      emit(FavoriteWeatherLoading());
      final json = await DBHelper.getData(_tableName);
      final weather = json
          .map(
            (e) => Weather(
              date: e["date"],
              cityName: e["city"],
              description: e["description"],
              weatherIcon: e["weather_icon"],
              main: WeatherMain(temp: e["temp"]),
            ),
          )
          .toList();
      emit(FavoriteWeatherLoaded(weather.reversed.toList()));
    } catch (e) {
      emit(FavoriteWeatherError(e));
    }
  }
}
