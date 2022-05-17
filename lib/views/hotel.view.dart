import 'dart:async';

import 'package:climber_monitoring/models/hotel.dart';
import 'package:climber_monitoring/services/hotel.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final hotelService = HotelService();

final dateTimeFormatter = DateFormat('yyyy-MM-dd hh:mm');

class HotelPage extends StatefulWidget {
  
  const HotelPage({ Key? key }) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  List<Hotel> hotels = [];

  _HotelPageState();

  int _refreshButtonState = 0;
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(      
      appBar: AppBar(
        title: const Text('Monitoring'),   
        backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
        bottom: TabBar(tabs: [
          Tab(text: onTab(HotelIntegrationType.KpisCalculatedTime)),
          Tab(text: onTab(HotelIntegrationType.RatesCalculatedTime)),
        ],)
      ),
      body: FutureBuilder(
        future: hotelService.buildHotels(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            //hotels = snapshot.data;
            return TabBarView(children: snapshot.data);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
        child: setUpUpdateButton(),
      ),
    );
  }

  Widget setUpTabBarView() {
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
      hotelService.fetchHotels().then((value) => {
        hotels = value,
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
        return 'PMS (' + hotelService.countByIntegration(hotels, type).toString() + ')';
      case HotelIntegrationType.RatesCalculatedTime:
        return 'RS (' + hotelService.countByIntegration(hotels, type).toString() + ')';
      default: {
        return 'Others' + hotelService.countByIntegration(hotels, type).toString() + ')';
      }  
    }
  }
}

// FutureBuilder<int> buildTabNameWidget(){
//   return FutureBuilder<int>(
//     future: hotelService.countByIntegration(hotels, type).toString(),
//     builder: ,
//   );
// }

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
        crossAxisCount: 3,
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
              title: Text(hotel.code, style: const TextStyle(fontSize: 14)),
              subtitle: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          hotel.name,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 8
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )                      
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        hotel.integration.numberOfDays.toString(),
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        ' Days ago',
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 6),
                      ) 
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Last Updated:',
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 8),
                      )
                    ],
                  ), 
                  Row(
                    children: [
                      Text(
                        dateTimeFormatter.format(hotel.integration.lastUpdated),
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    ],
                  ), 
                ],
              )                                   
            ),        
          ],
        ),
    );
  }
}