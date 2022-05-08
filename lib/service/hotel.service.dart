import 'dart:convert';

import 'package:climber_monitoring/model/hotel.dart';
import 'package:flutter/material.dart';

class HotelService {

  static const String response = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';
  static const String response2 = '[{ "hotelId": 1001160, "hotelName": "BT Garden Bauru", "hotelCode": "BRBAUBGB", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 2, "hpId": 1000000}, { "hotelId": 100116099, "hotelName": "Blue Balls", "hotelCode": "XXXXNNNN", "integrationSLA": "RatesCalculatedTime", "lastUpdate": "2022-04-23T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}, { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000} , { "hotelId": 100999099, "hotelName": "KPIS BLUE BALLS", "hotelCode": "BCUOUAAAA", "integrationSLA": "KpisCalculatedTime", "lastUpdate": "2022-04-01T01:47:01.000+0000", "integrationStatus": 1, "hpId": 1000000}]';

  List<Hotel> fetchHotels() {
    return parseHotels(response);
  }

    List<Hotel> fetchHotels1() {
    return parseHotels(response2);
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

//-----Widgets-----

FutureBuilder<List<Hotel>> buildHotelWidget(Future<List<Hotel>> listHotels){
  return FutureBuilder<List<Hotel>>(
      future: listHotels,      
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(
            child: Text('Unexpected error 1'),
          );
        } else if (snapshot.hasData) {
          return HotelList(hotels: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
  );
}

class HotelList extends StatefulWidget {

  final List<Hotel> hotels;
  const HotelList({ Key? key, required this.hotels  }) : super(key: key);

  @override
  State<HotelList> createState() => _HotelListState(this.hotels);
}

class _HotelListState extends State<HotelList> {
  final hotelService = HotelService();
  List<Hotel> hotels;

  _HotelListState(this.hotels);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          updateData();
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ), 
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            return HotelStatusCard(hotel: hotels[index]);
          }
        ),
        color: Colors.white,
        backgroundColor: Colors.purple,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
      );
  }
  void updateData(){
    hotels = hotelService.fetchHotels1();      
    setState(() {});
  }
}

// class HotelList extends StatelessWidget {
//   const HotelList({ Key? key, required this.hotels }) : super(key: key);

//   final List<Hotel> hotels;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ), 
//       itemCount: hotels.length,
//       itemBuilder: (context, index) {
//         return HotelStatusCard(hotel: hotels[index]);
//       }
//     );
//   }
// }

class HotelStatusCard extends StatelessWidget {
  const HotelStatusCard({ Key? key, required this.hotel }) : super(key: key);

  final Hotel hotel;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: hotel.getColor(),
      child: Column (
        children: [
          ListTile(
            title: Text(hotel.name),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotel.code,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                Text(
                  hotel.integration.numberOfDays.toString(),
                  style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                )
              ],
            ),            
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Delayed days: ' + hotel.integration.numberOfDays.toString(),
          //     style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 10),              
          //   ),
          // )
        ],
      ),
    );
  }
}