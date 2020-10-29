import 'package:eqzine/webview.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: Myapp(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ));

String result = "";
String scanned = "none";

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  Future scanQR() async {
    try {
      String barcode = await BarcodeScanner.scan();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Details(url: barcode)));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
          result = 'The user did not grant the camera permission!';
          showtoast(result);
      } else {
          result = 'Unknown error: $e';
          showtoast(result);
      }
    } on FormatException {
        result =
            'null (User returned using the "back"-button before scanning anything. Result)';
        showtoast(result);
    } catch (e) {
        result = 'Unknown error: $e';
        showtoast(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("static/banner.png"), fit: BoxFit.cover)),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              "eQzine",
              style: TextStyle(
                fontSize: 72,
                color: Colors.white,
              ),
            ),
          ),
          // Stack(children: [
          //   Container(
          //     child: Text(""),
          //     width: MediaQuery.of(context).size.width * 0.7,
          //     height: MediaQuery.of(context).size.height * 0.3,
          //     decoration: BoxDecoration(
          //       color: Colors.yellow,
          //       borderRadius: BorderRadius.circular(800),
          //     ),
          //   ),
          //   Image.asset(
          //     "static/logo.png",
          //     width: MediaQuery.of(context).size.width * 0.7,
          //     height: MediaQuery.of(context).size.height * 0.3,
          //   )
          // ]),
          Image.asset(
            "static/title.png",
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: roundbutton(scanQR, "Scan QR", context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Text(
              "Powered By: DataRitz Technologies",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )
        ]),
      ),
    );
  }
}

Widget roundbutton(func, String text, BuildContext context) {
  return MaterialButton(
    minWidth: double.infinity,
    height: 60,
    onPressed: () {
      func();
      if (scanned == "done") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Details(url: result)));
      } else {

      }
    },
    shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(50)),
    child: Text(
      text,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
    ),
  );
}

void showtoast(String text) {
    Fluttertoast.showToast(
            msg: text,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
}