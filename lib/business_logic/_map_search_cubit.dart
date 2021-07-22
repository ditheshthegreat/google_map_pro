part of '../google_maps_pro.dart';

class _MapSearchCubit extends Cubit<_MapSearchState> {
  _MapSearchCubit() : super(MapSearchInitial());

  Future<GeocodeResponse> getGeocodeData(
      Map<String, dynamic> queryParameters) async {
    try {
      Response response = await Dio()
          .get(ApiProvider.geocodeFinder, queryParameters: queryParameters);
      if (response.data?['status'] == 'REQUEST_DENIED') {
        throw (response.data['error_message']);
      } else {
        print('getGeocodeData :::');
        print(response.realUri);
        print(response.data);
        return GeocodeResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      throwException(e);
    }

    throw ('Something went wrong');
  }

  Future<void> getAutoSearchData(Map<String, dynamic> queryParameters) async {
    emit(MapSearchLoading());
    try {
      Response response = await Dio().get(ApiProvider.autocompleteSearch,
          queryParameters: queryParameters);

      if (response.data?['status'] == 'REQUEST_DENIED') {
        throw (response.data['error_message']);
      } else {
        print('getAutoSearchData :::');
        print(response.realUri);
        print(response.data);
        emit(AutoCompleteSearchResponse(
            AutoCompleteModel.fromJson(response.data)));
      }
    } on DioError catch (e) {
      emit(MapSearchError(throwException(e)));
    }
  }

  Exception throwException(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        return TimeoutException('${e.error}');
      case DioErrorType.sendTimeout:
        return TimeoutException('${e.error}');
      case DioErrorType.receiveTimeout:
        return TimeoutException('${e.error}');
      case DioErrorType.response:
        return Exception('${e.error}');
      case DioErrorType.cancel:
        return Exception('${e.error}');
      case DioErrorType.other:
        return Exception('${e.error}');
    }
  }
}
