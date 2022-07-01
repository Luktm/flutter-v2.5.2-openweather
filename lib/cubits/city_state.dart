part of 'city_cubit.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {
  const CityLoading();

  @override
  List<Object> get props => [];
}

class CityLoaded extends CityState {
  final List<City> city;

  
  const CityLoaded(this.city);

  @override
  List<Object> get props => [city,];
  
}

class CityError extends CityState {
  final FormatException error;

  const CityError(this.error);

  @override
  List<Object> get props => [error];
}