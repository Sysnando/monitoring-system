import 'dart:async';

import 'package:climber_monitoring/models/hotel.dart';
import 'package:climber_monitoring/services/hotel.service.dart';
import 'package:flutter/material.dart';

final hotelService = HotelService();

class HotelPage extends StatefulWidget {
  final String title;  
  const HotelPage({ Key? key, required this.title }) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState(this.title);
}

class _HotelPageState extends State<HotelPage> {

  _HotelPageState(this.title);

  int _refreshButtonState = 0;
  final String title;
  List<Hotel> _hotels = hotelService.fetchHotels();

  @override
  Widget build(BuildContext context) {

    return Scaffold(      
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
        bottom: TabBar(tabs: [
          Tab(text: onTab(HotelIntegrationType.KpisCalculatedTime)),
          Tab(text: onTab(HotelIntegrationType.RatesCalculatedTime)),
        ],)
      ),
      body: TabBarView(children: hotelService.buildHotels(_hotels),),      
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
        child: setUpUpdateButton(),
      ),
    );
  }
  
  Widget setUpUpdateButton() {
    if (_refreshButtonState == 0) {
      return const Icon(Icons.update);
    } else if (_refreshButtonState == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  void refresh() {
    setState(() {
      _refreshButtonState = 1;
      hotelService.fetchHotels1().then((value) => {
        _hotels = value,
        _refreshButtonState = 2        
      });
    });

    Timer(const Duration(milliseconds: 3300), () {
      setState(() { _refreshButtonState = 0; });
    });
  }

  String onTab(HotelIntegrationType type){
    switch(type) {
      case HotelIntegrationType.KpisCalculatedTime: 
        return 'PMS (' + hotelService.countByIntegration(_hotels, type).toString() + ')';
      case HotelIntegrationType.RatesCalculatedTime:
        return 'RS (' + hotelService.countByIntegration(_hotels, type).toString() + ')';
      default: {
        return 'Others' + hotelService.countByIntegration(_hotels, type).toString() + ')';
      }  
    }
  }
}

FutureBuilder<List<Hotel>> buildHotelWidget(Future<List<Hotel>> listHotels){
  return FutureBuilder<List<Hotel>>(
      future: listHotels,      
      builder: (context, snapshot) {
        if(snapshot.hasError) { debugPrint(snapshot.error.toString()); return const Center(child: Text('Unexpected error'),); } 
        else if (snapshot.hasData) { return HotelList(hotels: snapshot.data!); } 
        else { return const Center(child: CircularProgressIndicator(),);}
      }
  );
}

class HotelList extends StatelessWidget {
  const HotelList({ Key? key, required this.hotels }) : super(key: key);

  final List<Hotel> hotels;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ), 
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        return HotelStatusCard(hotel: hotels[index]);
      }
    );
  }
}

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
        ],
      ),
    );
  }
}