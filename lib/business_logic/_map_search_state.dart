part of '../google_maps_pro.dart';

abstract class _MapSearchState extends Equatable {
  const _MapSearchState();
}

class MapSearchInitial extends _MapSearchState {
  @override
  List<Object> get props => [];
}

class MapSearchLoading extends _MapSearchState {
  @override
  List<Object> get props => [];
}

class MapSearchError extends _MapSearchState {
  final Exception error;

  MapSearchError(this.error);

  @override
  List<Object> get props => [this.error];
}

class GeocodeSearchResponse extends _MapSearchState {
  final GeocodeResponse geocodeResponse;

  GeocodeSearchResponse(this.geocodeResponse);

  @override
  List<Object> get props => [this.geocodeResponse];
}

class AutoCompleteSearchResponse extends _MapSearchState {
  final AutoCompleteModel autoCompleteModel;

  AutoCompleteSearchResponse(this.autoCompleteModel);

  @override
  List<Object> get props => [this.autoCompleteModel];
}
