import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crypto_c/LoginPage.dart';
import 'package:crypto_c/Pan_delivery.dart';
import 'package:crypto_c/PickUp_request.dart';
import 'package:crypto_c/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  Server server = new Server();
  List data=[];
  Future refresh(){
    data.clear();
    return getData();
    // getData();
  }
  var count = 0;
  getData() async {
    var userId;
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getInt('UserID').toString();
    Uri url = Uri.parse(
        "${server.serverurl}pickup_request_list?secretkey=ADMIN&secretpass=ADMIN&user_id=$userId");
    var response = await http.get(url);
    data = jsonDecode(response.body)[0]['Data'];
    print("Data request:$data");
    print('data length|: ${data.length}');
    count = data.length;
    print('count$count');
    sp.setInt('count', count);
    if (data == []) {
      print('empty');
    }
    setState(() {});
    // print(data[0]['agent_name']);
    //return data;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: globalScaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Crypto Charge'),
          actions: [
            Row(
              children: [
                InkWell(
                    onTap: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.clear();
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen2()));
                      Fluttertoast.showToast(
                          msg: 'Logged out successfully..',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // confirmLogout(context);
                      // AwesomeDialog(
                      //   context: context,
                      //   dialogType: DialogType.WARNING,
                      //   animType: AnimType.BOTTOMSLIDE,
                      //   title: 'CONFIRM LOG OUT',
                      //   desc: 'Are You Sure..?',
                      //   btnOkText: 'YES',
                      //   // btnCancelText: 'CANCEL',
                      //   // btnCancelOnPress: (){
                      //   //   Navigator.pop(context);
                      //   // },
                      //   btnOkOnPress: () async{
                      //     SharedPreferences sp = await SharedPreferences.getInstance();
                      //     sp.clear();
                      //     // sp.setBool('OnBoarding', true);
                      //     // showAlertDialogLogout(context, viewModel);
                      //     // await Future<String>.delayed(const Duration(seconds: 2));
                      //     Navigator.pop(context);
                      //
                      //   },
                      //   // btnOkText: 'Okay',
                      //   // btnOkIcon: Icons.app_registration_rounded,
                      // )
                      //   ..show();
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => LoginScreen2()));
                    },
                    child: Icon(Icons.logout)),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
          leading: null,
          
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Container(
            //     height: 200.0,
            //     width: 200.0,
            //     child: Image.asset('assets/images/logo.png')
            // ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PickUp()));
              },
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 150,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                      color: Colors.yellow,
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              15.0) //                 <--- border radius here
                          ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Icon(
                              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                              FontAwesomeIcons.truckPickup,
                              size: 100,
                              color: Colors.black12),
                        ),
                        Text(
                          'PICK-UP',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    // heightFactor: 30,
                    alignment: Alignment.topRight,
                    child: Container(
                      // color: Colors.red,
                      // padding: EdgeInsets.only(bottom: 10,top: 10),
                      // alignment: Alignment.topLeft,
                      height: 32,
                      width: 32,
                      // decoration: BoxDecoration(border: Border.all(width: 1)),

                      // color: Colors.red,
                      child: Badge(
                       borderSide: BorderSide(color: Colors.black45, width: 1),
                        badgeContent: Text(
                          "$count",
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        badgeColor: Colors.pinkAccent,
                        animationType: BadgeAnimationType.scale,
                        animationDuration: Duration(seconds: 1),
                        shape: BadgeShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeliveryPage()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  color: Colors.green,
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          15.0) //                 <--- border radius here
                      ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      child: Icon(
                          // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                          FontAwesomeIcons.storeAlt,
                          size: 100,
                          color: Colors.black12),
                    ),
                    Text(
                      'DELIVERY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
