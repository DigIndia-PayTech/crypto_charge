import 'package:connectivity/connectivity.dart';
import 'package:crypto_c/LandingPage.dart';
import 'package:crypto_c/LoginPage.dart';
import 'package:crypto_c/MainPage.dart';
import 'package:crypto_c/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

SharedPreferences sp;
String userId = sp.getInt('UserID').toString();



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  runApp(new MaterialApp(
    title: 'Crypto Charge',
    theme: ThemeData(
      fontFamily: 'Prompt',
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {


  // SharedPreferences sp = await SharedPreferences.getInstance();
  String userId = sp.getInt('UserID').toString();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              // color: Colors.blueGrey,
              //   width: MediaQuery.of(context).size.width,
              child: Image.asset(
            'assets/images/logo.png',
            height: 250,
            width: 250,
          )),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SplashScreen(
                seconds: 5,
                navigateAfterSeconds: getPage(userId),
                // imageBackground: AssetImage(
                //   'assets/images/logo.png',),
                image: new Image.asset(
                  'assets/images/loader.gif',
                  height: 60,
                  width: 70,
                ),
                title: new Text(
                  '    Welcome To \nCRYPTO CHARGE',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                      fontSize: 25.0),
                ),
                backgroundColor: Colors.black,
                styleTextUnderTheLoader: new TextStyle(),
                photoSize: 150.0,
                onClick: () => print("Flutter Egypt"),
                loaderColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Crypto Charge',
//       theme: ThemeData(fontFamily: 'Lora',
//
//         primarySwatch: Colors.blue,
//       ),
//       home:
//       // LoginScreen2()
//       getPage(userId),
//     );
//   }
// }
 connection()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.mobile) {
    Fluttertoast.showToast(
        msg: 'CHECK YOUR INTERNET CONNECTION..!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
// I am connected to a mobile network.
  } else if (connectivityResult != ConnectivityResult.wifi) {
    Fluttertoast.showToast(
        msg: 'CHECK YOUR INTERNET CONNECTION..!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);}
  else{
    getPage(userId);
// I am connected to a wifi network.
  }}
getPage(userId) {
  String user = userId;
  print(user);
  if (userId == 'null') {
    return LoginScreen2();
  } else {
    return Pages();
  }
}
