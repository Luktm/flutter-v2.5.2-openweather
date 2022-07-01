import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/cubits/city_cubit.dart';
import 'package:flutter_weather_app/cubits/weather_cubit.dart';
import 'package:flutter_weather_app/services/geolocator_service.dart';

class AddCityScreen extends StatefulWidget {
  static const routeName = '/add-city-screen';

  @override
  _AddCityScreenState createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  WeatherCubit weatherCubit;
  CityCubit cityCubit;

  @override
  void initState() {
    weatherCubit = context.read<WeatherCubit>();
    cityCubit = context.read<CityCubit>();
    cityCubit.fetchCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await weatherCubit.addFavoriteWeather();
              Navigator.pop(context);
            },
            child: Text(
              "Add to list",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: () async {
              final GeolocatorService instanceGeolocation =
                  new GeolocatorService();

              try {
                final getCurrentLocation =
                    await instanceGeolocation.determinePosition();

                final lat = getCurrentLocation.latitude;
                final long = getCurrentLocation.longitude;

                weatherCubit.fetchWeather(
                  lat: lat,
                  long: long,
                );
              } catch (err) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Cannot access your location"),
                      content: Text(err.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            instanceGeolocation.openAppSettings();
                          },
                          child: Text("Open location setting"),
                        ),
                      ]),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Theme(
            data: ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocConsumer<CityCubit, CityState>(
                bloc: context.read<CityCubit>(),
                listener: (context, state) {},
                builder: (context, cityState) {
                  if (cityState is CityLoaded) {
                    return BlocBuilder<WeatherCubit, WeatherState>(
                      builder: (context, weatherState) {
                        return DropdownButtonFormField(
                          value: weatherState is WeatherLoaded
                              ? weatherState.weather.cityName
                              : null,
                          onChanged: (value) {
                            print(value);
                            final weatherCubit = context.read<WeatherCubit>();
                            weatherCubit.fetchWeather(cityName: value);
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: cityState.city
                              .map((c) => DropdownMenuItem(
                                  value: c.city, child: Text(c.city)))
                              .toList(),
                        );
                      },
                    );
                  }

                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherError) {
                return Text(state.error.message);
              } else if (state is WeatherLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        state.weather.cityName,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${state.weather.main.temp.toString()}°C",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${state.weather.description.toString()}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text("Forecast for 5 days with data every 3 hours"),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.weatherList.length,
                          itemBuilder: (context, index) {
                            final weather = state.weatherList[index];

                            return Card(
                                child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${weather.description}",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${weather.main.temp}°C",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    weather.formatDate,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: 30),
                                  Image.network(
                                      "http://openweathermap.org/img/w/${weather.weatherIcon}.png",
                                      width: 90),
                                ],
                              ),
                            ));
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
