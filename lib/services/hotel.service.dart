import 'dart:async';
import 'dart:convert';

import 'package:climber_monitoring/services/auth.service.dart';
import 'package:http/http.dart' as http;
import 'package:climber_monitoring/models/hotel.dart';
import 'package:climber_monitoring/views/hotel.view.dart';
import 'package:flutter/material.dart';

class HotelService {

  //static const String _response = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';
  static const String _uriFetchHotels = 'https://qua-ecs.climberrms.com/api/cs/integrations_sla';
  final _auth = AuthService();

  Future<List<Hotel>> fetchHotels() async {
    String token = await _auth.getToken().then((value) => value ?? '');
    
    final response = await http.get(Uri.parse(_uriFetchHotels),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': token}
    );

    if(response.statusCode != 200) {
      _auth.logout();
      // Navigator.pushReplacement(context, newRoute);
    }

    return parseHotels(response.body);
  }

  List<Hotel> parseHotels(String data) {
    List parsed = jsonDecode(data);
    return  parsed.map<Hotel>((json) => Hotel.fromJson(json)).toList();
  }

  int countByIntegration(List<Hotel> hotelList, HotelIntegrationType integrationType) {
    return hotelList.where((hotel) => hotel.integration.type ==integrationType.name).length;
  }

  List<FutureBuilder<List<Hotel>>> buildHotelList(List<Hotel> hotelList) {
    List<FutureBuilder<List<Hotel>>> listHotelsWidgets = [];

    listHotelsWidgets.add(buildHotelListWidget(Future.value(hotelList.where((hotel) => hotel.integration.type == HotelIntegrationType.KpisCalculatedTime.name).toList())));
    listHotelsWidgets.add(buildHotelListWidget(Future.value(hotelList.where((hotel) => hotel.integration.type == HotelIntegrationType.RatesCalculatedTime.name).toList())));

    return listHotelsWidgets;
  }

  FutureBuilder<List<Hotel>> buildHotelListWidget(Future<List<Hotel>> listHotels){
  return FutureBuilder<List<Hotel>>(
      future: listHotels,      
      builder: (context, snapshot) {
        if(snapshot.hasError) { debugPrint(snapshot.error.toString()); return const Center(child: Text('Unexpected error'),); } 
        else if (snapshot.hasData) { return HotelList(hotels: snapshot.data!); } 
        else { return const Center(child: CircularProgressIndicator(),);}
      }
  );
}
}
