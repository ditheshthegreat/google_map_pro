import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_pro/model/geocode_response.dart';

class GoogleMapsPro {
  static const MethodChannel _channel = const MethodChannel('google_maps_pro');

  GoogleMapsPro(this.apiKey);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  final String apiKey;
  Dio _dio = Dio();

  Future<GeocodeResponse> getLatLngByZipCode({String postalCode = '', String lat = '', String lng = ''}) async {
    final Response<Map<String, dynamic>> response = await _dio.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: <String, dynamic>{
          'key': apiKey,
          'latlng': '$lat,$lng',
          'components': 'postal_code:$postalCode'
        });
    print(response.realUri);
    print(response.data);
    GeocodeResponse _geocodeResponse = GeocodeResponse.fromJson(response.data);
    print('ADDRESS :: ');
    print(_geocodeResponse.toJson());
    return _geocodeResponse;
  }
}
