// import 'package:crypto_c/DeliveryHistory.dart';
// import 'package:crypto_c/DeliveryHistory2.dart';
// import 'package:crypto_c/LandingPage.dart';
// import 'package:crypto_c/LoginPage.dart';
// import 'package:crypto_c/PickUp_history.dart';
// import 'package:crypto_c/PickUp_request.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyNavigationBar extends StatefulWidget {
//   MyNavigationBar ({Key key}) : super(key: key);
//   @override
//   _MyNavigationBarState createState() => _MyNavigationBarState();
// }
// class _MyNavigationBarState extends State<MyNavigationBar > {
//   int _selectedIndex = 1;
//
//   @override
//   void initState(){
//
//     super.initState();
//   }
//   // static const List<Widget> _options = <Widget>[
//   //   DeliveryHistory(),
//   //   LandingPage(),
//   //   PickupHistory(),
//   // ];
//   List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>()
//   ];
//   void _onItemTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//
//     });
//   }
//   @override
//   Widget build(BuildContext context){
//     return WillPopScope(
//       onWillPop: () async  {
//     final isFirstRouteInCurrentTab =
//     !await _navigatorKeys[_selectedIndex].currentState.maybePop();
//
//     // let system handle back button if we're on the first route
//     return isFirstRouteInCurrentTab;
//     },
//       child: Scaffold(
//           bottomNavigationBar:  BottomNavigationBar(
//               items:[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.history),
//                   label: 'Delivery History',
//                   // backgroundColor: Colors.teal
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Home',
//                   // backgroundColor: Colors.cyan
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.history),
//                   label: 'Pick-Up History',
//                   // backgroundColor: Colors.lightBlue,
//                 ),
//               ],
//               // type: BottomNavigationBarType.shifting,
//               currentIndex: _selectedIndex,
//               selectedItemColor: Colors.blue,
//               unselectedItemColor: Colors.grey,
//               showUnselectedLabels: true,
//               showSelectedLabels:  true,
//               iconSize: 40,
//               onTap: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//               elevation: 20
//           ),
//         body:
//         Stack(
//           children: [
//             _buildOffstageNavigator(0),
//             _buildOffstageNavigator(1),
//             _buildOffstageNavigator(2),
//           ],
//         ),
//         //
//       ),
//     );
//   }
//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
//     return {
//       '/': (context) {
//         return [
//           DeliveryHistory(),
//           LandingPage(
//             onNext: _next,
//           ),
//           PickupHistory(),
//         ].elementAt(index);
//       },
//     };
//   }
//   void _next() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen2()));
//   }
//   Widget _buildOffstageNavigator(int index) {
//     var routeBuilders = _routeBuilders(context, index);
//     return Offstage(
//         offstage: _selectedIndex != index,
//         child: Navigator(
//         key: _navigatorKeys[index],
//         onGenerateRoute: (routeSettings) {
//       return MaterialPageRoute(
//         builder: (context) => routeBuilders[routeSettings.name](context),
//       );
//     },));
// }}