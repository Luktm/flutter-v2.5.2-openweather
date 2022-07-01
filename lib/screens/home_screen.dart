import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/cubits/city_cubit.dart';
import 'package:flutter_weather_app/cubits/weather_cubit.dart';
import 'package:flutter_weather_app/screens/add_city_screen.dart';
import 'package:flutter_weather_app/screens/city_screen.dart';
import 'package:flutter_weather_app/services/geolocator_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  WeatherCubit _weatherCubit;

  TabController _tc;

  @override
  void initState() {
    _tc = TabController(vsync: this, length: 2);
    _tc.addListener(() {
      setState(() {});
    });

    _weatherCubit = context.read<WeatherCubit>();
    _weatherCubit.getLocalFavoriteCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, AddCityScreen.routeName),
          )
        ],
      ),
      body: CityScreen(),
    );
  }
}
