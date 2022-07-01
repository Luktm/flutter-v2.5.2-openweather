import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_app/cubits/weather_cubit.dart';
import 'package:flutter_weather_app/models/city.dart';
import 'package:flutter_weather_app/repository/city_repository.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  final _cityRepository = CityRepository();

  final WeatherCubit weatherCubit;

  CityCubit({this.weatherCubit}) : super(CityInitial());

  Future<void> fetchCity() async {
    try {
      emit(CityLoading());
      final List<City> city = await _cityRepository.fetchCity();
      emit(CityLoaded(city));
      // * call cubit function must call from widget/component, 
      // * if want to call nested cubit, please also pass BlocProvider/context.read<cubit>() from component/widget.
      weatherCubit.fetchWeather(
        cityName: city[0].city,
        lat: city[0].lat,
        long: city[0].lng,
      );
    } catch (e) {
      emit(CityError(e));
    }
  }
}
