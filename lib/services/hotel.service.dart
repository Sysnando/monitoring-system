import 'dart:async';
import 'dart:convert';

import 'package:climber_monitoring/models/hotel.dart';
import 'package:climber_monitoring/views/hotel.view.dart';
import 'package:flutter/material.dart';

class HotelService {

  static const String response = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';
  static const String response2 = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000} , { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS 2", "hotelCode": "BCUOUAAAA2", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN2", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';

  List<Hotel> fetchHotels() {
    return parseHotels(response);
  }

  Future<List<Hotel>> fetchHotels1() {
    return Future.value(parseHotels(response2));
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
