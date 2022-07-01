part of 'weather_cubit.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {
  final Weather weather;
  final List<Weather> weatherList;

  const WeatherInitial({this.weather, this.weatherList});

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();

  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<Weather> weatherList;

  const WeatherLoaded({this.weather, this.weatherList});

  @override
  List<Object> get props => [weather, weatherList];
}

class WeatherError extends WeatherState {
  final FormatException error;

  const WeatherError(this.error);

  @override
  List<Object> get props => [error];
}

class FavoriteWeatherLoading extends WeatherState {
  const FavoriteWeatherLoading();

  @override
  List<Object> get props => [];
}

class FavoriteWeatherLoaded extends WeatherState {
  final List<Weather> weatherList;

  const FavoriteWeatherLoaded(this.weatherList);

  @override
  List<Object> get props => [weatherList];
}

class FavoriteWeatherError extends WeatherState {
  final String err;

  const FavoriteWeatherError(this.err);

  @override
  List<Object> get props => [err];
}
