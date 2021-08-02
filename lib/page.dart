import 'package:crypto_c/DeliveryHistory.dart';
import 'package:crypto_c/LandingPage.dart';
import 'package:crypto_c/PickUp_history.dart';
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  @override
  createState() => new PagesState();
}

class PagesState extends State<Pages> {
  // @override
  // void initState(){
  //   Navigator.pop(context);
  //   super.initState();
  // }
  int pageIndex = 1;

  pageChooser() {
    switch (this.pageIndex) {
      case 0:
        return new PickupHistory();
        break;

      case 1:
        return new LandingPage();
        break;

      case 2:
        return new DeliveryHistory();
        break;

      default:
        return new Container(
          child: new Center(
              child: new Text('No page found by page chooser.',
                  style: new TextStyle(fontSize: 30.0))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
            body: pageChooser(),
            bottomNavigationBar: new BottomNavigationBar(
              backgroundColor: Colors.white70,
              iconSize: 35,
              currentIndex: pageIndex,
              onTap: (int tappedIndex) {
                //Toggle pageChooser and rebuild state with the index that was tapped in bottom navbar
                setState(() {
                  this.pageIndex = tappedIndex;
                });
              },
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    title: new Text('PICK-UP HISTORY'),
                    icon: new Icon(Icons.history)),
                new BottomNavigationBarItem(
                    title: new Text('HOME'), icon: new Icon(Icons.home)),
                new BottomNavigationBarItem(
                    title: new Text(
                      'DELIVERY HISTORY',
                      style: TextStyle(fontSize: 13),
                    ),
                    icon: new Icon(Icons.history))
              ],
              type: BottomNavigationBarType.fixed,
            ));
  }
}
