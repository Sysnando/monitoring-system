import 'package:climber_monitoring/services/hotel.service.dart';
import 'package:climber_monitoring/views/hotel.view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ClimberApp());

final hotelService = HotelService();

class ClimberApp extends StatelessWidget {
  const ClimberApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Climber Monitoring';

    return const MaterialApp(
      title: appTitle,      
      home: DefaultTabController(
        length: 2,
        child: HotelPage(title: appTitle)                
      )
    );
  }
}