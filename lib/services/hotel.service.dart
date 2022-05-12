import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:climber_monitoring/models/hotel.dart';
import 'package:climber_monitoring/views/hotel.view.dart';
import 'package:flutter/material.dart';

class HotelService {

  static const String response = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';
  
  static const String _url_env_prod = 'https://app.climberrms.com';
  static const String _url_env_qa = 'https://ecs-qua.climberrms.com';

  static const String _sla_endpoint = '/api/cs/integrations_sla';

  List<Hotel> fetchHotels() {
    return parseHotels(response);
  }

  Future<List<Hotel>> fetchHotels1(String url) async {
    final response = await http.get(Uri.parse(_url_env_qa + _sla_endpoint));
    return parseHotels(response.body);
  }

  List<Hotel> parseHotels(String data) {
    List parsed = jsonDecode(data);
    return  parsed.map<Hotel>((json) => Hotel.fromJson(json)).toList();
  }

  int countByIntegration(List<Hotel> hotelList, HotelIntegrationType integrationType) {
    return hotelList.where((hotel) => hotel.integration.type ==integrationType.name).length;
  }

  List<FutureBuilder<List<Hotel>>> buildHotels(List<Hotel> hotelList) {
    List<FutureBuilder<List<Hotel>>> listHotelsWidgets = [];
    listHotelsWidgets.add(buildHotelWidget(Future.value(hotelList.where((hotel) => hotel.integration.type == HotelIntegrationType.KpisCalculatedTime.name).toList())));
    listHotelsWidgets.add(buildHotelWidget(Future.value(hotelList.where((hotel) => hotel.integration.type == HotelIntegrationType.RatesCalculatedTime.name).toList())));
    return listHotelsWidgets;
  }
}
