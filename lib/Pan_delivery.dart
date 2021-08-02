import 'dart:convert';
import 'dart:ui';
import 'package:crypto_c/DeliveryHistory.dart';
import 'package:crypto_c/MainPage.dart';
import 'package:crypto_c/PickUp_request.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_c/DeliveryHistory2.dart';
import 'package:crypto_c/server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  bool loaded=false;
  String _scanBarcode = '';
  @override
  void initState(){
    getRetailers();
    super.initState();

  }
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print('scanned result is : $barcodeScanRes');
      if(barcodeScanRes=='-1'){
        ackNo.text = '';
      }
      else{
        ackNo.text = barcodeScanRes;
      }
      return barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
  @override
  void dispose() {
    ackNo.dispose();
    name.dispose();
    super.dispose();
  }
  var selected;
  List <dynamic> data=[];
  TextEditingController ackNo = TextEditingController();
  TextEditingController name = TextEditingController();
  Server server = new Server();
  getRetailers() async{
    var userId;
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getInt('UserID').toString();
    Uri url = Uri.parse(
        "${server.serverurl}/retailers_list?secretkey=ADMIN&secretpass=ADMIN&user_id=$userId");
    var response = await http.get(url);
    data = jsonDecode(response.body)[0]['Data'];
    print("Data retailerss:$data");
    String retailers = data[0]['agent_id'];
    // int retailerIndex = data['retailer_index'];
    print(retailers);
    setState(() {
      loaded=true;
    });
    // print(data[0]['agent_name']);
    //return data;
  }
  List<dynamic> retailers;

  deliveryPost(ackNo, name, selected) async {
    var userId;
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getInt('UserID').toString();
    {
      var url = "${server.serverurl}pan_delivery";
      var body = {
        "secretpass": "ADMIN",
        "secretkey": "ADMIN",
        'user_id': userId,
        "ack_no": ackNo.text.toString(),
        "name_on_card": name.text.toString(),
        'retailer_index': selected
      };
      var response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        print('successfull post${response.body}');
        var data = json.decode('${response.body}');
        var responsecode = data[0]['response_code'];
        var status = data[0]['status'];
        print('$responsecode ,$status');
        print('signnnnn');
        if (responsecode == "000") {
          Fluttertoast.showToast(
              msg: "Something went wrong!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          print('dfdf');
        } else if (responsecode == "002") {
          Fluttertoast.showToast(
              msg: "Delivery Added Successfully..",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          print('tyuii');
          // userId = data[0]['user_id'].toString();
          // // userPhn = data[0]['mobile_no'].toString();
          // SharedPreferences sp = await SharedPreferences.getInstance();
          // sp.setInt('UserID', int.parse(userId));
          // // sp.setInt('UserPhn', int.parse(userPhn));
          // showAlertDialogSucessSignIn(context);
          // await Future<String>.delayed(const Duration(seconds: 2));
          await Future<String>.delayed(const Duration(seconds: 1));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DeliveryHistory2()));

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAN Delivery'),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DeliveryHistory2()));
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: loaded?[
         Container(
           margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
           height: 370,
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

           child: Column(children: [
             Container(

               // color: Colors.,
               margin: EdgeInsets.fromLTRB(0,20,0,10 ),
               child: Text('ADD DELIVERY',
               style: TextStyle(
                 color: Colors.teal,
                 fontSize: 20,
                 fontWeight: FontWeight.bold
               ),
               textAlign: TextAlign.center,
               ),
             ),
             ListTile(
               leading: Icon(Icons.format_list_numbered),
               trailing: InkWell(
                   onTap: (){
                     scanBarcodeNormal();
                   },
                   child: Icon(Icons.document_scanner, size: 40,)),
               title: TextField(
                 keyboardType: TextInputType.number,
                 textInputAction: TextInputAction.next,
                 controller: ackNo,
                 decoration: InputDecoration(
                     labelText: 'Acknowledge No.'
                 ),
                 // onSaved: (input)=>name=input,
               ),
               ),

             ListTile(
               leading: Icon(Icons.drive_file_rename_outline),

               title: TextFormField(
                 textInputAction: TextInputAction.done,
                 controller: name,
                 decoration: InputDecoration(
                     labelText: 'Name on card'
                 ),
                 // onSaved: (input)=>name=input,
               ),
             ),
             ListTile(
               leading: Icon(Icons.person_add),
               title: DropdownButton(
                 hint: Text('Select Retailer'), // Not necessary for Option 1
                 value: selected,
                 iconEnabledColor: Colors.black,
                 icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.black,),
                 isExpanded: true,
                 onChanged: (newValue) {
                   setState(() {
                     selected = newValue;
                     print(selected);
                   });
                 },
                 items: data.map((item) {
                   return DropdownMenuItem(
                     child: new Text('${item['name']}-(${item['agent_id']})'),
                     value: item['retailer_index'],
                   );
                 }).toList(),
               ),
             ),
             Container(
               width: 300,
                 // height: 20,
                 padding: EdgeInsets.all(20.0),

                 child: ElevatedButton(
                   child: Text('SUBMIT'),
                   style: ButtonStyle(
                       backgroundColor:
                       MaterialStateProperty.resolveWith<Color>(
                             (Set<MaterialState> states) {
                           if (states.contains(MaterialState.pressed))
                             return Theme.of(context)
                                 .colorScheme
                                 .primary
                                 .withOpacity(0.5);
                           else if (states.contains(MaterialState.disabled))
                             return Colors.pinkAccent;
                           return Colors.pinkAccent; // Use the component's default.
                         },
                       ),
                       shape:
                       MaterialStateProperty.all<RoundedRectangleBorder>(
                           RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(40.0),
                           ))),
                   onPressed:
                       () async {
                         FocusScopeNode currentFocus = FocusScope.of(context);
                         if (!currentFocus.hasPrimaryFocus) {
                           currentFocus.unfocus();
                         }
                         if(ackNo.text.toString() =='' ){
                           return  Fluttertoast.showToast(
                               msg: "Enter Ack No.!",
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.red,
                               textColor: Colors.white,
                               fontSize: 16.0
                           );
                         }
                         else if(name.text.toString() =='' ){
                           return  Fluttertoast.showToast(
                               msg: "Enter the Name on card.!",
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.red,
                               textColor: Colors.white,
                               fontSize: 16.0
                           );
                         }
                         else if(selected == null ){
                           return  Fluttertoast.showToast(
                               msg: "Select Retailer",
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.red,
                               textColor: Colors.white,
                               fontSize: 16.0
                           );
                         }
                         else{
                           deliveryPost(ackNo, name, selected);
                         }


                   }

                 )),
           ],),
         ),
            SizedBox(height: 30,)

        ]:[CircularProgressIndicator(color: Colors.white,)],),
      ),

    );
  }
}
