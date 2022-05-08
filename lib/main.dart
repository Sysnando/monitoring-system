import 'package:climber_monitoring/model/hotel.dart';
import 'package:climber_monitoring/service/hotel.service.dart';
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
        child: HomePage(title: appTitle)        
        
      )
    );
  }
}


// class HomePage extends StatefulWidget {
  
//   final String title;
//   const HomePage({ Key? key, required this.title}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState(title: title);
// }

// class _HomePageState extends State<HomePage> {
  
//   _HomePageState({ required this.title});

//   final String title;  
//   List<Hotel> hotelList = hotelService.fetchHotels();  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(      
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
//         bottom: TabBar(tabs: [
//           Tab(text: 'PMS (' + hotelService.countByIntegration(hotelList, HotelIntegrationType.KpisCalculatedTime).toString() + ')'),
//           Tab(text: 'RS (' + hotelService.countByIntegration(hotelList, HotelIntegrationType.RatesCalculatedTime).toString() + ')'),
//         ],)
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           print('entrou aqui 2');
//           await Future.delayed(Duration(seconds: 2));
//           updateData();
//         },
//         child: TabBarView(children: hotelService.buildHotels(hotelList)),
//         color: Colors.white,
//         backgroundColor: Colors.purple,
//         triggerMode: RefreshIndicatorTriggerMode.anywhere,
//       )
//     );
//   }

//   void updateData(){
//     print('entrou aqui ');
//     hotelList = hotelService.fetchHotels1();  

//     setState(() {});
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({ Key? key, required this.title}) : super(key: key);

  final String title;  

  @override
  Widget build(BuildContext context) {

    List<Hotel> hotelList = hotelService.fetchHotels();

    return Scaffold(      
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromRGBO(25, 192, 255, 1),
        bottom: TabBar(tabs: [
          Tab(text: 'PMS (' + hotelService.countByIntegration(hotelList, HotelIntegrationType.KpisCalculatedTime).toString() + ')'),
          Tab(text: 'RS (' + hotelService.countByIntegration(hotelList, HotelIntegrationType.RatesCalculatedTime).toString() + ')')
        ],)
      ),
      body: TabBarView(children: hotelService.buildHotels(hotelList),
      )
    );
  }
}

// class HotelTitle extends StatefulWidget {

//   final List<Hotel> hotelList;
//   final String integrationType;

//   const HotelTitle({ Key? key, required this.hotelList, required this.integrationType }) : super(key: key);

//   @override
//   State<HotelTitle> createState() => _HotelTitleState(hotelList, this.integrationType);
// }

// class _HotelTitleState extends State<HotelTitle> {
//   String _count = "";
//   final List<Hotel> hotelList;
//   final HotelIntegrationType integrationType;

//   _HotelTitleState(this.hotelList, this.integrationType);

//   void sum() {
//     setState(() {
//       _count = this.integrationType.name + '(' + hotelService.countByIntegration(this.hotelList, this.integrationType).toString() + ')';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 18,
//       child: SizedBox(
//         child: Text(_count),
//       ),
//     );
//   }
// }


// class FavoriteWidget extends StatefulWidget {
//   const FavoriteWidget({Key? key}) : super(key: key);

//   @override
//   _FavoriteWidgetState createState() => _FavoriteWidgetState();
  
// }

// class _FavoriteWidgetState extends State<FavoriteWidget> {
//   bool _isFavorited = true;
//   int _favoriteCount = 41;

//   void _toggleFavorite() {
//     setState(() {
//       if (_isFavorited) {
//         _favoriteCount -= 1;
//         _isFavorited = false;
//       } else {
//         _favoriteCount += 1;
//         _isFavorited = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(0),
//           child: IconButton(
//             padding: const EdgeInsets.all(0),
//             alignment: Alignment.centerRight,
//             icon: (_isFavorited
//                 ? const Icon(Icons.star)
//                 : const Icon(Icons.star_border)),
//             color: Colors.red[500],
//             onPressed: _toggleFavorite,
//           ),
//         ),
//         SizedBox(
//           width: 18,
//           child: SizedBox(
//             child: Text('$_favoriteCount'),
//           ),
//         ),
//       ],
//     );
//   }
// }