import 'dart:convert';
import 'package:crypto_c/PickUp_history2.dart';
import 'package:crypto_c/server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_c/PickUp_history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickUp extends StatefulWidget {
  const PickUp({Key key}) : super(key: key);

  @override
  _PickUpState createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  List<dynamic> data = [];
  Future refresh(){
    data.clear();
    return getData();
    // getData();
  }
  TextEditingController newPanController = TextEditingController();
  TextEditingController corrPanController = TextEditingController();
  Widget content = Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
    ),
  );

  @override
  void initState() {
    getData();
    super.initState();
  }
  Server server = new Server();
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
    var count = data.length;
    print('count$count');
    sp.setInt('count', count);

    if (data == []) {
      print('empty');
    }
    setState(() {
      if (data.length == 0) {
        content= Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_outlined,
                size: 100,
                color: Colors.black26,
              ),
              Text(
                'No Data Found',
                style: TextStyle(fontSize: 30, color: Colors.black26),
              )
            ],
          ),
        );
      } else {
        content= Container(
          color: Colors.blue,
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return pillCards(data[index]);
              },
            ),
          ),
        );
      }
    });
    // print(data[0]['agent_name']);
    //return data;
  }

  // Widget getContent() {
  //   if (data == null) {
  //     return Center(
  //       child: CircularProgressIndicator(
  //         color: Colors.blue,
  //       ),
  //     );
  //   } else if (data.length == 0) {
  //     return Container(
  //       color: Colors.white,
  //       alignment: Alignment.center,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.warning_outlined,
  //             size: 100,
  //             color: Colors.black26,
  //           ),
  //           Text(
  //             'No Data Found',
  //             style: TextStyle(fontSize: 30, color: Colors.black26),
  //           )
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       color: Colors.blue,
  //       child: ListView.builder(
  //         itemCount: data.length,
  //         itemBuilder: (context, index) {
  //           return pillCards(data[index]);
  //         },
  //       ),
  //     );
  //   }
  //
  //   // else if(data.isEmpty){
  //   //   return Container(
  //   //     height: MediaQuery.of(context).size.height,
  //   //     width: MediaQuery.of(context).size.width,
  //   //     color: Colors.white,
  //   //     child: Column(children: [
  //   //       SizedBox(height: 200,),
  //   //       Icon(Icons.warning_outlined, size: 100,color: Colors.black26,),
  //   //       Text('No Data Found', style: TextStyle(fontSize: 30, color: Colors.black26),)
  //   //     ],),
  //   //   );
  //   // }
  // }

  pickUpPost(reqId, newPanController, corrPanController) async {
    {
      var url = "${server.serverurl}approve_pickup";
      var body = {
        "secretpass": "ADMIN",
        "secretkey": "ADMIN",
        "request_id": reqId,
        "new_pan": newPanController.text.toString(),
        "corr_pan": corrPanController.text.toString(),
      };
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        print('successfully  posted....${response.body}');
        var data = json.decode('${response.body}');
        var responsecode = data[0]['response_code'];
        var status = data[0]['status'];
        print('$responsecode ,$status');
        print('signnnnn');
        if (responsecode == "000") {
          Fluttertoast.showToast(
              msg: "Something went wrong  !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          print('dfdf');
        } else if (responsecode == "001") {
          print('tyuii');
          Fluttertoast.showToast(
              msg: "PICKED UP SUCCESSFULLY !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          // Navigator.pop(context);
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PickUp()));

          // userId = data[0]['user_id'].toString();
          // userPhn = data[0]['mobile_no'].toString();
          // SharedPreferences sp = await SharedPreferences.getInstance();
          // sp.setInt('UserID', int.parse(userId));
          // // sp.setInt('UserPhn', int.parse(userPhn));
          // showAlertDialogSucessSignIn(context);
          // await Future<String>.delayed(const Duration(seconds: 2));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MyNavigationBar()));

          // SharedPreferences sp = await SharedPreferences.getInstance();
          // print('herrruuuuu');
          // sp.setString('user_id', userId.toString());
        }
        //
        // var userId = parsed['user_id'];
        // print('$username');
      } else {
        print('Failed...${response.statusCode}');
      }
    }
  }

  Widget pillCards(data) {
    String name = data['agent_name'];
    String address = data['address'];
    String dateTime = data['req_time'];
    String mobile = data['mobile_no'];
    newPanController.text = data['new_pan'];
    corrPanController.text = data['corr_pan'];
    var total = data['total'];
    var newPan = data['new_pan'];
    // var corrPan = data['new_pan_picked'];
    var corrPan = data['corr_pan'];
    // var rec2 = data['corr_pan_picked'];
    String agentId = data['agent_id'];

    String reqId = data['request_id'];
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10.0,
            )
          ],
          color: Color(0xffffffff),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    padding: EdgeInsets.all(2),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xffe8f1fe),
                    ),
                    child: Image.asset(
                      'assets/images/pickup.png',
                      fit: BoxFit.cover,
                      color: Colors.blue,
                      height: 10,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Oxygen",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.start),
                      Text('($agentId)',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Oxygen",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.start),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  decoration: BoxDecoration(
                    // color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  // alignment: Alignment.center,
                  child:
                  RichText(
                    text: TextSpan(
                      text: " $total\n",
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.w700,
                          // fontFamily: "Oxygen",
                          fontStyle: FontStyle.normal,
                          fontSize: 30.0),
                      children: <TextSpan>[
                        TextSpan(
                            text:"($newPan + ${corrPan})",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w700,
                                // fontFamily: "Oxygen",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0)),
                      ],
                    ),
                  ),

                ),
                SizedBox(width: 10,)

                // Rectangle 88
              ],
            ),
            // SizedBox(height: 5,),
            Row(
              children: [
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black45,
                    size: 15,
                  ),
                ),
                Text(
                    "${address.substring(0, 28)}\n${address.substring(51)}",
                    style: TextStyle(
                        color: Color(0xff9c9b9f),
                        fontWeight: FontWeight.w700,
                        // fontFamily: "Oxygen",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
                SizedBox(
                  height: 5,
                ),

              ],
            ),
            SizedBox(height: 5,),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black45,
                    size: 15,
                  ),
                ),
                Text("${dateTime.substring(0, 10)}",
                    style: TextStyle(
                        color: Color(0xff9c9b9f),
                        fontWeight: FontWeight.w700,
                        // fontFamily: "Oxygen",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
                Spacer(),
                Icon(
                  Icons.phone,
                  color: Colors.black45,
                  size: 15,
                ),
                Text("$mobile",
                    style: TextStyle(
                        color: Color(0xff9c9b9f),
                        fontWeight: FontWeight.w700,
                        // fontFamily: "Oxygen",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
                SizedBox(
                  width: 25,
                ),
              ],
            ),

            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Icon(
                    Icons.timer_sharp,
                    color: Colors.black45,
                    size: 15,
                  ),
                ),
                Text("${dateTime.substring(12)}",
                    style: TextStyle(
                        color: Color(0xff9c9b9f),
                        fontWeight: FontWeight.w700,
                        // fontFamily: "Oxygen",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
                Spacer(),
                InkWell(
                  onTap: () {
                    _displayTextInputDialog(context,reqId, newPan, corrPan);
                  },
                  child: Container(
                    // margin: EdgeInsets.only(left: 130),
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text('PickUp',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Oxygen",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.center),
                  ),
                ),
                SizedBox(width: 25,)
              ],
            )
          ],
        ));
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, reqId, newPan, corrPan) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Pick-Up'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 25,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    // initialValue: newPan,
                    // onChanged: (value) {
                    //   setState(() {
                    //     valueText = value;
                    //   });
                    // },
                    controller: newPanController,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      // hintText: 'Tell us about yourself',
                      labelText: 'New Pan Applications',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    // initialValue: corrPan,
                    // onChanged: (value) {
                    //   setState(() {
                    //     valueText = value;
                    //   });
                    // },
                    controller: corrPanController,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      // hintText: 'Tell us about yourself',
                      labelText: 'Corr. Pan Applications',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('SUBMIT'),
                onPressed: () {
                  pickUpPost(reqId, newPanController, corrPanController);
                  // setState(() {
                  //   Navigator.pop(context);
                  // });
                },
              ),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    // codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PickUp Request'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PickupHistory2()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.history),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.notifications),
            ),
          ],
        ),
        body: content);
  }
}
