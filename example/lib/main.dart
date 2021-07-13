import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_pro/google_maps_pro.dart';
import 'package:google_maps_pro/model/geocode_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TextEditingController query = TextEditingController();
  late GoogleMapsPro _googleMapsPro;
  GeocodeResponse _geocodeResponse = GeocodeResponse();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _googleMapsPro = GoogleMapsPro('AIzaSyCsjMF12VISe-xks-AbD0Ae9UVmwTiMzyk');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await GoogleMapsPro.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              TextField(
                controller: query,
              ),
              ElevatedButton(
                  onPressed: () async {
                    print(query.text.contains(','));
                    if (query.text.length == 6) {
                      _geocodeResponse = await _googleMapsPro.getLatLngByZipCode(postalCode: query.text);
                    } else {
                      if (query.text.contains(',')) {
                        List<String> splittedQuery = query.text.split(',');
                        _geocodeResponse =
                            await _googleMapsPro.getLatLngByZipCode(lat: splittedQuery.first, lng: splittedQuery.last);
                      }
                    }
                    setState(() {});
                  },
                  child: Text('Check')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_geocodeResponse.results!
                    .singleWhere((element) => element.types!.contains('postal_code'))
                    .toJson()
                    .toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
