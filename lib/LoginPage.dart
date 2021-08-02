import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crypto_c/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_c/MainPage.dart';
import 'package:crypto_c/server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  Color backgroundColor1 = Colors.blue;
  Color backgroundColor2 = Colors.blue;
  Color highlightColor = Colors.pinkAccent;
  Color foregroundColor = Colors.white;
  TextEditingController emailMob = TextEditingController();
  TextEditingController password = TextEditingController();
  Server server = new Server();
  var userId;

  showAlertDialogSucessSignIn(
    BuildContext context,
  ) {
    // Widget cancelButton = FlatButton(
    //   child: Text(
    //     "Try Again",
    //     style: TextStyle(color: Colors.green, fontSize: 20),
    //   ),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // );

    Widget submitButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
      onPressed: () {},
    );

    // set up the AlertDialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Success',
      desc: 'Login Successfull..',
      // btnOkText: 'Okay',
      // btnOkIcon: Icons.app_registration_rounded,
    )..show();
    // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
  signInPost() async {
    {
      var url = "${server.serverurl}sign_in";
      var body = {
        "secretpass": "ADMIN",
        "secretkey": "ADMIN",
        "email_mob": emailMob.text.toString(),
        "password": password.text.toString(),
      };
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        print('successfully logged in....${response.body}');
        var data = json.decode('${response.body}');
        var responsecode = data[0]['response_code'];
        var status = data[0]['status'];
        print('$responsecode ,$status');
        print('signnnnn');
        if (responsecode == "000" && status == "Invalid Login Credentials !") {
          Fluttertoast.showToast(
              msg: status,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          print('dfdf');
        } else if (responsecode == "001" && status == 'SUCCESS') {
          print('tyuii');
          userId = data[0]['user_id'].toString();
          // userPhn = data[0]['mobile_no'].toString();
          SharedPreferences sp = await SharedPreferences.getInstance();

          sp.setInt('UserID', int.parse(userId));
          // sp.setInt('UserPhn', int.parse(userPhn));
          showAlertDialogSucessSignIn(context);
          await Future<String>.delayed(const Duration(seconds: 2));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Pages()));
          // Navigator.pop(context);


          // SharedPreferences sp = await SharedPreferences.getInstance();
          // print('herrruuuuu');
          // sp.setString('user_id', userId.toString());
        }
        //
        // var userId = parsed['user_id'];
        // print('$username');
      } else {
        Fluttertoast.showToast(
            msg: 'something went wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Failed...${response.statusCode}');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.centerLeft,
                end: new Alignment(1.0, 0.0),
                // 10% of the width, so there are ten blinds.
                colors: [this.backgroundColor1, this.backgroundColor2],
                // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                  child: Center(
                    child: new Column(
                      children: <Widget>[
                        Container(
                            height: 200.0,
                            width: 200.0,
                            child: Image.asset('assets/images/logo.png')),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'LogIn To Your Account',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: this.foregroundColor,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                        child: Icon(
                          Icons.smartphone,
                          color: this.foregroundColor,
                        ),
                      ),
                      new Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          controller: emailMob,
                          cursorHeight: 25,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          cursorColor: Colors.white,
                          // textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.only(top: 10, bottom: 8),
                            border: InputBorder.none,
                            labelText: 'Enter Mobile No.',
                            // hintText: 'Email/Mobile No.',
                            labelStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: this.foregroundColor,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                        child: Icon(
                          Icons.lock_open,
                          color: this.foregroundColor,
                        ),
                      ),
                      new Expanded(
                        child: TextField(
                          controller: password,

                          cursorHeight: 25,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          // controller: ,
                          cursorColor: Colors.white,
                          obscureText: true,
                          // textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, bottom: 8),
                            border: InputBorder.none,
                            labelText: '*********',
                            labelStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 3,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),

                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(

                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          color: this.highlightColor,
                          onPressed: () => {
                            if (emailMob.text.toString() == '')
                              {
                                Fluttertoast.showToast(
                                    msg: "Enter Email/Mobile No.  !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                            else if (emailMob.text.length != 10)
                              {
                                Fluttertoast.showToast(
                                    msg: "Mobile Number must be 10 Digits!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                            else if (password.text.toString() == '')
                              {
                                Fluttertoast.showToast(
                                    msg: "Enter Password  !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                            else
                              {signInPost()}

                            // Navigator.push(
                            //     context, MaterialPageRoute(
                            //     builder: (context) => MyNavigationBar()))
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                color: this.foregroundColor, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          color: Colors.transparent,
                          onPressed: () => {},
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: this.foregroundColor.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Expanded(
                  child: Divider(),
                ),
                // new Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin: const EdgeInsets.only(
                //       left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
                //   alignment: Alignment.center,
                //   child: new Row(
                //     children: <Widget>[
                //       new Expanded(
                //         child: new FlatButton(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 20.0, horizontal: 20.0),
                //           color: Colors.transparent,
                //           onPressed: () => {},
                //           child: Text(
                //             "Don't have an account? Create One",
                //             style: TextStyle(
                //                 color: this.foregroundColor.withOpacity(0.5)),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
