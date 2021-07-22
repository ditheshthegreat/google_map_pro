import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:google_maps_pro/google_maps_pro.dart';
import 'package:google_maps_pro/model/components_filter.dart';
import 'package:google_maps_pro/model/geocode_response.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _query = TextEditingController();

  TextEditingController _latlong = TextEditingController();

  late GoogleMapsPro _googleMapsPro;

  ///Your GOOGLE MAP API key
  String apiKey = 'GOOGLE API KEY';

  List<Results> _geocodeResponse = <Results>[];

  @override
  void initState() {
    super.initState();

    _googleMapsPro = GoogleMapsPro(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoCompleteAddressSearch(
                apiKey: apiKey,
                geocodeResponse: (Results? geoResults) {
                  setState(() {
                    if (geoResults != null) _geocodeResponse.add(geoResults);
                  });
                },
                disableLogo: false,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _query,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter postal code',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () async {
                          print(_query.text);
                          if (_query.text.length == 6) {
                            _geocodeResponse =
                                (await _googleMapsPro.getMapDataBy(
                                        componentsFilter: ComponentsFilter(
                                            postalCode: _query.text)))
                                    .results!;
                          }

                          setState(() {});
                        },
                        child: Text('Get Address')),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _latlong,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'search lat,lng eg: 79.580167,20.634550',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
              ElevatedButton(
                  onPressed: () async {
                    print(_latlong.text.contains(','));
                    List<String> splittedLatLng = _latlong.text.split(',');
                    _geocodeResponse = (await _googleMapsPro.getMapDataBy(
                            lat: splittedLatLng.first,
                            lng: splittedLatLng.last))
                        .results!;

                    setState(() {});
                  },
                  child: Text('Get Address')),
              ElevatedButton(
                  onPressed: () async {
                    showSearchBottomSheet(context, (result) {
                      if (result != null) _geocodeResponse.add(result);
                      setState(() {});
                    });
                  },
                  child: Text('Search Address in Bottom sheet')),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Search Result',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: JsonView.string(json.encode(_geocodeResponse)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showSearchBottomSheet(
      BuildContext context, Function(Results?) result) async {
    await showModalBottomSheet<Results>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
              child: AutoCompleteAddressSearch(
                apiKey: apiKey,
                geocodeResponse: (Results? results) {
                  setState(() {
                    Future<void>.delayed(const Duration(milliseconds: 1000),
                        () {
                      setState(() {
                        result(results);
                      });

                      Navigator.pop(context);
                    });
                  });
                },
                disableLogo: false,
              ),
            );
          });
        });
  }
}
