import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/cubits/weather_cubit.dart';
import 'package:flutter_weather_app/screens/add_city_screen.dart';

class CityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      bloc: context.read<WeatherCubit>(),
      listener: (context, state) {
        if (state is WeatherError) {
          final snackBar = SnackBar(content: Text('${state.error}'));
          return ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      buildWhen: (previous, current) => current is FavoriteWeatherLoaded,
      builder: (context, state) {
        if (state is FavoriteWeatherLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is FavoriteWeatherLoaded) {
          if (state.weatherList.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    "No citys being added",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical:10)
                    ),
                    onPressed: () => Navigator.pushNamed(context, AddCityScreen.routeName),
                    child: Text(
                      "Add city",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.weatherList.length,
            itemBuilder: (context, index) {
              final weather = state.weatherList[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  child: ListTile(
                    title: Text(weather.cityName),
                    leading: Image.network("http://openweathermap.org/img/w/${weather.weatherIcon}.png"),
                    subtitle: Text(weather.description),
                    trailing: Text("${weather.main.temp}°C"),
                  ),
                ),
              );
            },
          );
        }
        return null;
      },
    );
  }
}
