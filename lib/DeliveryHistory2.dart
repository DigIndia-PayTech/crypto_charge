import 'dart:convert';
import 'package:crypto_c/LandingPage.dart';
import 'package:crypto_c/MainPage.dart';
import 'package:crypto_c/Pan_delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_c/server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryHistory2 extends StatefulWidget {
  const DeliveryHistory2({Key key}) : super(key: key);

  @override
  _DeliveryHistory2State createState() => _DeliveryHistory2State();
}

class _DeliveryHistory2State extends State<DeliveryHistory2> {

  List<dynamic> data=[];
  Widget content = Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
    ),
  );
  Future refresh(){
    data.clear();
    return getData();
    // getData();
  }
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
        "${server.serverurl}delivery_history?secretkey=ADMIN&secretpass=ADMIN&user_id=$userId");
    var response = await http.get(url);
    data = jsonDecode(response.body)[0]['Data'];
    print("Data delivery history:$data");
    // print(data[0]['agent_name']);
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
  }
  Widget getContent(){
    // if(data==null){
    //   return Container(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     color: Colors.white,
    //     child: Column(children: [
    //       SizedBox(height: 200,),
    //       Icon(Icons.warning_outlined, size: 100,color: Colors.black26,),
    //       Text('No Data Found', style: TextStyle(fontSize: 30, color: Colors.black26),)
    //     ],),
    //   );
    // }
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
          children: [
            Expanded(
              child:
              FutureBuilder(
                future: getData(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapShot.data.length,
                      itemBuilder: (context, index) {
                        return pillCards(snapShot.data[index]);
                      },
                      shrinkWrap: true,
                    );
                  }
                 // else if(snapShot.data.length==0 ){
                 //    return  Center(
                 //      child: CircularProgressIndicator(color: Colors.red,),
                 //    );
                 //  }
                 // else if (snapShot.connectionState != ConnectionState.done) {
                 //    return  Container(
                 //      height: MediaQuery.of(context).size.height,
                 //      width: MediaQuery.of(context).size.width,
                 //      color: Colors.white,
                 //      child: Column(children: [
                 //        SizedBox(height: 200,),
                 //        Icon(Icons.warning_outlined, size: 100,color: Colors.black26,),
                 //        Text('No Data Found', style: TextStyle(fontSize: 30, color: Colors.black26),)
                 //      ],),
                 //    );
                 //  }
                  else
                    return Center(
                      child:
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 5,
                        semanticsLabel: 'Please Wait',
                      ),
                    );
                },
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      );
    }
  Widget pillCards(data) {
    String retailer = data['agent_name'];
    String agentId = data['agent_id'];
    String name = data['name_on_card'];
    String ack_no = data['ack_no'];
    String dateTime = data['delivery_time'];
    String status = data['status'];
    String url = data['agent_img'];
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 155,
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
                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                padding: EdgeInsets.all(2),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38, //                   <--- border color
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all( Radius.circular(30),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover
                  ),
                  color: Color(0xffe8f1fe),
                ),
                // child:
                // Image.asset(
                //
                //   fit: BoxFit.cover,
                //   // color: Colors.blue,
                //   height: 10,
                // )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$retailer',
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
                            fontSize: 13.0),
                        textAlign: TextAlign.start),
                  ],
                ),
              ),


              // Rectangle 88

            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:
                  Container(
                    // padding: Ed,
                    // color: Colors.red,
                    padding: EdgeInsets.only(top: 5),
                    child: // Daily/ 8:00 Am - 12:00 Pm - 9:00Pm
                    // Until/6-12-2021
                    Row(
                      children: [
                        Text('ACK NO:'),
                        SizedBox(width: 5,),
                        Text(ack_no,
                            style: TextStyle(
                                color: Color(0xff9c9b9f),
                                fontWeight: FontWeight.w700,
                                // fontFamily: "Oxygen",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),


                      ],
                    ),

                  ),
                ),
              )],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:
                  Container(
                    // color: Colors.red,
                    padding: EdgeInsets.only(top: 5),
                    child: // Daily/ 8:00 Am - 12:00 Pm - 9:00Pm
                    // Until/6-12-2021
                    Row(
                      children: [
                        Text('Name on Card:'),
                        SizedBox(width: 5,),
                        Text(name,
                            style: TextStyle(
                                color: Color(0xff9c9b9f),
                                fontWeight: FontWeight.w700,
                                // fontFamily: "Oxygen",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                      ],
                    ),

                  ),
                ),
              )],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  // color: Colors.red,
                  padding: EdgeInsets.only(top: 5),
                  child: // Daily/ 8:00 Am - 12:00 Pm - 9:00Pm
                  // Until/6-12-2021
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Colors.black,size: 15,),
                      SizedBox(width: 5,),
                      Text("${dateTime}",
                          style: TextStyle(
                              color: Color(0xff9c9b9f),
                              fontWeight: FontWeight.w700,
                              // fontFamily: "Oxygen",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.left),
                    ],
                  ),),

              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 40,),
                height: 30,
                // width: 80,
                decoration: BoxDecoration(
                  // color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                alignment: Alignment.centerRight,
                child:  Row(
                  children: [
                    Text(status,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            // fontFamily: "Oxygen",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0),
                        textAlign: TextAlign.left),
                  ],
                ),
              ),
              SizedBox(width: 15,)
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 20),
          //         child:
          //         Container(
          //           // color: Colors.red,
          //           // padding: EdgeInsets.only(top: 5),
          //           child: // Daily/ 8:00 Am - 12:00 Pm - 9:00Pm
          //           // Until/6-12-2021
          //           Row(
          //             children: [
          //               Icon(Icons.timer_sharp, color: Colors.black45,size: 15,),
          //               SizedBox(width: 5,),
          //               Text("${dateTime.substring(11)}",
          //                   style: TextStyle(
          //                       color: Color(0xff9c9b9f),
          //                       fontWeight: FontWeight.w700,
          //                       // fontFamily: "Oxygen",
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 12.0),
          //                   textAlign: TextAlign.left),
          //             ],
          //           ),
          //
          //         ),
          //       ),
          //     )],
          // ),

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async=>false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PAN Delivery History', style:TextStyle(fontSize: 17),),
          leading: IconButton(
             icon: Icon(Icons.arrow_back,),
            onPressed: (){
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MyNavigationBar()));
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DeliveryPage()));
                  } ,
                  child: Icon(Icons.add, size: 35,)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.notifications),
            ),
          ],
        ),
        body:
        // data.length==0?
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   color: Colors.white,
        //   child: Column(children: [
        //     SizedBox(height: 200,),
        //     Icon(Icons.warning_outlined, size: 100,color: Colors.black26,),
        //     Text('No Data Found', style: TextStyle(fontSize: 30, color: Colors.black26),)
        //   ],),
        // ):
        content,
      ),
    );
  }
}
