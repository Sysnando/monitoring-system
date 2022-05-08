import 'package:flutter/material.dart';

// {
//   "hotelId": 1001160,
//   "hotelName": "BT Garden Bauru",
//   "hotelCode": "BRBAUBGB",
//   "integrationSLA": "KpisCalculatedTime",
//   "lastUpdate": "2022-04-23T01:47:01.000+0000",
//   "integrationStatus": 0,
//   "hpId": 1000000
// },
class Hotel {
  final int id;
  final String code;
  final String name;
  final int status;
  final HotelIntegration integration;

  getColor() {
    switch (HotelStatus.values[integration.status]) {
      case HotelStatus.critical:
        return Colors.red;
      case HotelStatus.warning:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  const Hotel({
      required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.integration
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    print(json);
    return Hotel(
      id: json['hotelId'] as int,
      code: json['hotelCode'] as String,
      name: json['hotelName'] as String,
      status: 0,
      integration: HotelIntegration.fromJson(json) 
    );
  }

  
}

class HotelIntegration {
  final String type;
  final DateTime lastUpdated;
  final int status;
  
  int get numberOfDays { return lastUpdated.difference(DateTime.now()).inDays; }

  const HotelIntegration({
    required this.type,
    required this.lastUpdated,
    required this.status
  }); 

  factory HotelIntegration.fromJson(Map<String, dynamic> json) {
    return HotelIntegration(
      type: json['integrationSLA'], 
      lastUpdated: DateTime.parse(json['lastUpdate']), 
      status: HotelStatus.values[json['integrationStatus']].index
    );
  }
}

enum HotelIntegrationType {
  KpisCalculatedTime, RatesCalculatedTime
}

enum HotelStatus {
  ok, warning, critical
}