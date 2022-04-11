import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/helpers/httpHelper.dart';

import 'package:stuffd/thing/thing.dart';
import 'package:stuffd/thing/thing_form.dart';
import 'package:stuffd/thing/upc_response.dart';
import 'package:stuffd/utils/database_manager.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ThingUPC extends StatelessWidget {
  // In the constructor, require a Todo.
  ThingUPC({Key? key, this.thing}) : super(key: key);

  final Thing? thing;

  final _formKey = GlobalKey<FormBuilderState>();
  var db = DatabaseManager.instance;

  String UpcValue = "";
  UpcResponse? response;
  String title = "";

  @override
  Widget build(BuildContext context) {
    Future lookUpUpc() async {
      if (UpcValue != "") {
        var url = Uri.parse(
            "https://api.upcitemdb.com/prod/trial/lookup?upc=" + UpcValue);
        var r = await httpGet(url);
        var info = UpcResponse.fromJson(jsonDecode(r.body));
        var limit = r.headers["x-ratelimit-remaining"];
        title = info.items![0].title!;
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ThingForm(
            thingResponse: info,
          ),
        ));
      }
    }

    Future tryScan() async {
      try {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Nope", true, ScanMode.BARCODE);
        UpcValue = barcodeScanRes;
        lookUpUpc();
      } catch (e) {}
    }

//check for camera
    if (Platform.isAndroid || Platform.isIOS) {
      tryScan();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Add thing",textScaleFactor: 2.4,),
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.chevron_circle_left, size: 40),
            tooltip: "Back",
            color: NordColors.frost.lightest,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          toolbarHeight: 125,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(LineAwesomeIcons.barcode),
                    label: Text("UPC")),
                autofocus: true,
                enableSuggestions: false,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  UpcValue = text;
                },
              ),
              Expanded(child: Container()),
              ListTile(
                contentPadding: EdgeInsets.all(50),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: NordColors.$2),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => ThingForm(),
                              ));
                            },
                            child: Text("Enter it Manually",
                                textScaleFactor: 2.5)),
                      ),
                        const SizedBox(width: 50),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: NordColors.$2),
                            onPressed: lookUpUpc,
                            child: Text("Look it up!", textScaleFactor: 2.5)),
                      )
                    ]),
              )
            ])));
  }
}
