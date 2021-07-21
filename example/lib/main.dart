import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:google_maps_pro/google_maps_pro.dart';
import 'package:google_maps_pro/model/components_filter.dart';
import 'package:google_maps_pro/model/geocode_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _query = TextEditingController();
  TextEditingController _latlong = TextEditingController();
  late GoogleMapsPro _googleMapsPro;
  GeocodeResponse _geocodeResponse = GeocodeResponse();

  @override
  void initState() {
    super.initState();

    ///Your GOOGLE MAP API key
    _googleMapsPro = GoogleMapsPro('GOOGLE MAP API KEY');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  geocodeResponse: (GeocodeResponse geocodeResponse) {
                    setState(() {
                      _geocodeResponse = geocodeResponse;
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () async {
                            print(_query.text);
                            if (_query.text.length == 6) {
                              _geocodeResponse = await _googleMapsPro.getMapDataBy(
                                  componentsFilter: ComponentsFilter(postalCode: _query.text));
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                ),
                ElevatedButton(
                    onPressed: () async {
                      print(_latlong.text.contains(','));
                      List<String> splittedLatLng = _latlong.text.split(',');
                      _geocodeResponse =
                          await _googleMapsPro.getMapDataBy(lat: splittedLatLng.first, lng: splittedLatLng.last);

                      setState(() {});
                    },
                    child: Text('Get Address')),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child: JsonView.map(_geocodeResponse.toJson())),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
