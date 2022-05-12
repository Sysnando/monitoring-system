import 'package:climber_monitoring/services/hotel.service.dart';
import 'package:climber_monitoring/views/login.view.dart';
import 'package:flutter/material.dart';

ColorScheme scheme = const ColorScheme(
  primary: Color(0xff19c0ff),
  secondary: Color(0xff03DAC6),
  surface: Color(0xff181818),
  background: Color(0xfff2fbfe),
  error: Color(0xffCF6679),
  onPrimary: Color(0xffffffff),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.light,
);

void main() => runApp(const ClimberApp());

final hotelService = HotelService();

class ClimberApp extends StatelessWidget {
  const ClimberApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climber',      
      theme: ThemeData(
        colorScheme: scheme,
        primarySwatch: Colors.blue
      ),
      home: const LoginPage()
    );
  }
}

enum Environment {
  prod, qa, dev
}