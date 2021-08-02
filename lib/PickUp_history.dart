import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_c/server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickupHistory extends StatefulWidget {
  const PickupHistory({Key key}) : super(key: key);

  @override
  _PickupHistoryState createState() => _PickupHistoryState();
}

class _PickupHistoryState extends State<PickupHistory> {
  List data= [];
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
  Future refresh(){
    data.clear();
    return getData();
    // getData();
  }
  getData() async {
    var userId;
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getInt('UserID').toString();
    Uri url = Uri.parse(
        "${server
            .serverurl}pickup_history?secretkey=ADMIN&secretpass=ADMIN&user_id=$userId");
    var response = await http.get(url);
    data = jsonDecode(response.body)[0]['Data'];
    // if(data == null)
    //   print('empty');
    print("Data pickup history: $data");
    setState(() {
      if (data.length == 0) {
        content = Container(
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
        content = Container(
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
  }

  Widget pillCards(data) {
    String name = data['agent_name'];
    String agentId = data['agent_id'];
    String address = data['address'];
    String dateTime = data['pickup_time'];
    String mobile = data['mobile_no'];
    var total = data['total_picked'];
    String req1 = data['new_pan'];
    var rec1 = data['new_pan_picked'];
    String req2 = data['corr_pan'];
    var rec2 = data['corr_pan_picked'];
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
                                text:"($rec1 + ${rec2})",
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
                    _displayTextInputDialog(
                        context, req1, rec1, req2, rec2);
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
                    child: Text('Details',
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

  Future<void> _displayTextInputDialog(BuildContext context,
      req1,
      rec1,
      req2,
      rec2,) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Pick-Up Details',
              textAlign: TextAlign.center,
            ),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.23,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 25,
              child: Column(
                // mainAxisAlignment: Mai,
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'New PAN Applications:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Requested : $req1',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Received    : $rec1',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Corr. PAN Applications:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Requested : $req2',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Received    : $rec2',
                    style: TextStyle(fontSize: 15),
                  ),
                  // TextFormField(
                  //   textAlign: TextAlign.center,
                  //   initialValue: newPan,
                  //   // onChanged: (value) {
                  //   //   setState(() {
                  //   //     valueText = value;
                  //   //   });
                  //   // },
                  //   // controller: newPan.text,
                  //   decoration: InputDecoration(
                  //     border: new OutlineInputBorder(
                  //         borderSide: new BorderSide(color: Colors.teal)),
                  //     // hintText: 'Tell us about yourself',
                  //
                  //     labelText: 'New Pan Applications',
                  //   ),
                  // ),

                  // TextFormField(
                  //   textAlign: TextAlign.center,
                  //   initialValue: corrPan,
                  //   // onChanged: (value) {
                  //   //   setState(() {
                  //   //     valueText = value;
                  //   //   });
                  //   // },
                  //   // controller: newPan.text,
                  //   decoration: InputDecoration(
                  //     border: new OutlineInputBorder(
                  //         borderSide: new BorderSide(color: Colors.teal)),
                  //     // hintText: 'Tell us about yourself',
                  //     labelText: 'Corr. Pan Applications',
                  //   ),
                  // ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: FlatButton(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.pinkAccent,
                  textColor: Colors.white,
                  child: Text('CLOSE'),
                  onPressed: () {
                    setState(() {
                      // codeDialog = valueText;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: null,
            title: Text('PickUp History'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications),
              )
            ],
          ),
          body: content),
    );
  }
}
