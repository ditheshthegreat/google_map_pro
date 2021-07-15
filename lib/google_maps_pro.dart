import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_pro/business_logic/api_provider.dart';
import 'package:google_maps_pro/model/auto_complete_model.dart';
import 'package:google_maps_pro/model/components_filter.dart';
import 'package:google_maps_pro/model/geocode_response.dart';

part 'auto_complete.dart';
part 'business_logic/_map_search_cubit.dart';
part 'business_logic/_map_search_state.dart';

class GoogleMapsPro {
  static const MethodChannel _channel = const MethodChannel('google_maps_pro');

  GoogleMapsPro(String apiKey) {
    _apiKey = ApiProvider.mapApiKey = apiKey;
  }

  String _apiKey = '';

  _MapSearchCubit _mapSearchCubit = _MapSearchCubit();

  ///You must supply one, and only one, of the following fields.
  ///
  ///[address] : The address which you want to geocode.
  ///
  ///[lat] and [lng]: The LatLng for which you wish to obtain the closest, human-readable address.
  ///
  ///[placeId] : The place ID of the place for which you wish to obtain the closest, human-readable address.
  ///
  ///[componentsFilter] : You can set the Geocoding Service to return address results restricted to a specific area, by
  /// using a components filter
  ///<https://developers.google.com/maps/documentation/javascript/geocoding#ComponentFiltering>
  Future<GeocodeResponse> getMapDataBy(
      {String address = '',
      String lat = '',
      String lng = '',
      String placeId = '',
      ComponentsFilter? componentsFilter}) async {
    if (lat.isEmpty && lng.isEmpty || lat.isNotEmpty && lng.isNotEmpty) {
      Map<String, dynamic> _queryParameter;
      if (placeId.isEmpty) {
        _queryParameter = <String, dynamic>{
          'key': _apiKey,
          'address': '$address',
          'latlng': '$lat,$lng',
          'components': componentsFilter == null ? '' : componentsFilter.toJson(),
        };
      } else {
        _queryParameter = <String, dynamic>{'key': _apiKey, 'place_id': '$placeId'};
      }
      print(_queryParameter);
      GeocodeResponse _geocodeResponse = await _mapSearchCubit.getGeocodeData(_queryParameter);
      print('ADDRESS :: ');
      print(_geocodeResponse.toJson());
      return _geocodeResponse;
    } else {
      throw ('Either lat & lng should be empty nor lat & lng should fill up');
    }
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
