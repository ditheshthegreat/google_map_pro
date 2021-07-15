import 'package:flutter/material.dart';
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
  TextEditingController query = TextEditingController();
  late GoogleMapsPro _googleMapsPro;
  GeocodeResponse _geocodeResponse = GeocodeResponse();

  @override
  void initState() {
    super.initState();

    ///Your GOOGLE MAP API key
    _googleMapsPro = GoogleMapsPro('AIzaSyCsjMF12VISe-xks-AbD0Ae9UVmwTiMzyk');
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
              children: [
                AutoCompleteAddressSearch(
                  geocodeResponse: (GeocodeResponse geocodeResponse) {
                    print(geocodeResponse.results!.first.geometry?.location?.toJson());
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      print(query.text.contains(','));
                      if (query.text.length == 6 && query is int) {
                        _geocodeResponse = await _googleMapsPro.getMapDataBy(
                            componentsFilter: ComponentsFilter(postalCode: query.text));
                      } else {
                        if (query.text.contains(',')) {
                          List<String> splittedQuery = query.text.split(',');
                          _geocodeResponse =
                              await _googleMapsPro.getMapDataBy(lat: splittedQuery.first, lng: splittedQuery.last);
                        }
                      }

                      setState(() {});
                    },
                    child: Text('Check')),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_geocodeResponse.results == null
                      ? ''
                      : _geocodeResponse.results!
                          .singleWhere((element) => element.types!.contains('postal_code'))
                          .toJson()
                          .toString()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
