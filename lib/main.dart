import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/cubits/weather_cubit.dart';
import 'package:flutter_weather_app/screens/add_city_screen.dart';
import 'package:flutter_weather_app/screens/home_screen.dart';

import 'cubits/city_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherCubit(),
        ),
        // * to call WeatherCubit function in CityCubit,
        // * remember pass the BlocProvider.of<AnyCubit>(context) or context.of<AnyCubit>() into it,
        // * don't create another instance!!!
        BlocProvider(
          create: (context) => CityCubit(weatherCubit: BlocProvider.of<WeatherCubit>(context)),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Weather',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          AddCityScreen.routeName: (ctx) => AddCityScreen(),
        },
      ),
    );
  }
}
