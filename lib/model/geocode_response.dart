class GeocodeResponse {
  PlusCode? _plusCode;
  List<Results>? _results;
  String? _status;

  PlusCode? get plusCode => _plusCode;

  List<Results>? get results => _results;

  String? get status => _status;

  GeocodeResponse(
      {PlusCode? plusCode, List<Results>? results, String? status}) {
    _plusCode = plusCode;
    _results = results;
    _status = status;
  }

  GeocodeResponse.fromJson(dynamic json) {
    _plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_plusCode != null) {
      map['plus_code'] = _plusCode?.toJson();
    }
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    return map;
  }

  @override
  String toString() {
    return 'GeocodeResponse{_plusCode: $_plusCode, _results: $_results, _status: $_status}';
  }
}

class Results {
  AddressComponents? _addressComponents;
  String? _formattedAddress;
  Geometry? _geometry;
  String? _placeId;
  List<String>? _types;

  AddressComponents? get addressComponents => _addressComponents;

  String? get formattedAddress => _formattedAddress;

  Geometry? get geometry => _geometry;

  String? get placeId => _placeId;

  List<String>? get types => _types;

  Results(
      {AddressComponents? addressComponents,
      String? formattedAddress,
      Geometry? geometry,
      String? placeId,
      List<String>? types}) {
    _addressComponents = addressComponents;
    _formattedAddress = formattedAddress;
    _geometry = geometry;
    _placeId = placeId;
    _types = types;
  }

  Results.fromJson(dynamic json) {
    _formattedAddress = json['formatted_address'];
    _addressComponents = json['address_components'] != null
        ? AddressComponents.fromJson(json['address_components'])
        : null;

    _geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    _placeId = json['place_id'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['formatted_address'] = _formattedAddress;
    if (_addressComponents != null) {
      map['address_components'] = _addressComponents?.toJson();
    }
    if (_geometry != null) {
      map['geometry'] = _geometry?.toJson();
    }
    map['place_id'] = _placeId;
    map['types'] = _types;
    return map;
  }

  @override
  String toString() {
    return 'Results{_addressComponents: $_addressComponents, _formattedAddress: $_formattedAddress, _geometry: $_geometry, _placeId: $_placeId, _types: $_types}';
  }
}

class Geometry {
  Bounds? _bounds;
  Location? _location;
  String? _locationType;
  Viewport? _viewport;

  Bounds? get bounds => _bounds;

  Location? get location => _location;

  String? get locationType => _locationType;

  Viewport? get viewport => _viewport;

  Geometry(
      {Bounds? bounds,
      Location? location,
      String? locationType,
      Viewport? viewport}) {
    _bounds = bounds;
    _location = location;
    _locationType = locationType;
    _viewport = viewport;
  }

  Geometry.fromJson(dynamic json) {
    _bounds = json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _locationType = json['location_type'];
    _viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_bounds != null) {
      map['bounds'] = _bounds?.toJson();
    }
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['location_type'] = _locationType;
    if (_viewport != null) {
      map['viewport'] = _viewport?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'Geometry{_location: $_location}';
  }
}

class Viewport {
  Location? _northeast;
  Location? _southwest;

  Location? get northeast => _northeast;

  Location? get southwest => _southwest;

  Viewport({Location? northeast, Location? southwest}) {
    _northeast = northeast;
    _southwest = southwest;
  }

  Viewport.fromJson(dynamic json) {
    _northeast =
        json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    _southwest =
        json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }
}

class Location {
  double? _lat;
  double? _lng;

  double? get lat => _lat;

  double? get lng => _lng;

  Location({double? lat, double? lng}) {
    _lat = lat;
    _lng = lng;
  }

  Location.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

  @override
  String toString() {
    return 'Location{_lat: $_lat, _lng: $_lng}';
  }
}

class Bounds {
  Location? _northeast;
  Location? _southwest;

  Location? get northeast => _northeast;

  Location? get southwest => _southwest;

  Bounds({Location? northeast, Location? southwest}) {
    _northeast = northeast;
    _southwest = southwest;
  }

  Bounds.fromJson(dynamic json) {
    _northeast =
        json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    _southwest =
        json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }
}

class AddressComponents {
  PlaceName? home;
  PlaceName? postalCode;
  PlaceName? street;
  PlaceName? region;
  PlaceName? city;
  PlaceName? country;
  PlaceName? plusCode;

  AddressComponents.fromJson(List<dynamic> json) {
    Map<String, PlaceName> _addressComponents = getAddressObject(json);
    this.home = _addressComponents['home'];
    this.postalCode = _addressComponents['postal_code'];
    this.street = _addressComponents['street'];
    this.region = _addressComponents['region'];
    this.city = _addressComponents['city'];
    this.country = _addressComponents['country'];
    this.plusCode = _addressComponents['plus_code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['home'] = home?.toJson() ?? '';
    map['postalCode'] = postalCode?.toJson() ?? '';
    map['street'] = street?.toJson() ?? '';
    map['region'] = region?.toJson() ?? '';
    map['city'] = city?.toJson() ?? '';
    map['country'] = country?.toJson() ?? '';
    map['plus_code'] = plusCode?.toJson() ?? '';
    return map;
  }

  Map<String, PlaceName> getAddressObject(List<dynamic> addressComponents) {
    final Map<String, List<String>> shouldBeComponent = <String, List<String>>{
      'home': <String>['street_number'],
      'postal_code': <String>['postal_code'],
      'street': <String>['street_address', 'route'],
      'region': <String>[
        'administrative_area_level_1',
        'administrative_area_level_2',
        'administrative_area_level_3',
        'administrative_area_level_4',
        'administrative_area_level_5'
      ],
      'city': <String>[
        'political'
            'locality',
        'sublocality',
        'sublocality_level_1',
        'sublocality_level_2',
        'sublocality_level_3',
        'sublocality_level_4'
      ],
      'country': <String>['country'],
      'plus_code': <String>['plus_code']
    };

    final Map<String, PlaceName> address = <String, PlaceName>{};

    for (Map<String, dynamic> element in addressComponents) {
      for (String shouldBe in shouldBeComponent.keys) {
        if (shouldBeComponent[shouldBe]!.contains(element['types']![0])) {
          address[shouldBe] = (PlaceName.fromJson(element));
        }
      }
    }
    return address;
  }

  @override
  String toString() {
    return 'AddressComponents{home: $home, postalCode: $postalCode, street: $street, region: $region, city: $city, country: $country, plusCode: $plusCode}';
  }
}

class PlusCode {
  String? _compoundCode;
  String? _globalCode;

  String? get compoundCode => _compoundCode;

  String? get globalCode => _globalCode;

  PlusCode({String? compoundCode, String? globalCode}) {
    _compoundCode = compoundCode;
    _globalCode = globalCode;
  }

  PlusCode.fromJson(dynamic json) {
    _compoundCode = json['compound_code'];
    _globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['compound_code'] = _compoundCode;
    map['global_code'] = _globalCode;
    return map;
  }

  @override
  String toString() {
    return 'PlusCode{_compoundCode: $_compoundCode, _globalCode: $_globalCode}';
  }
}

class PlaceName {
  PlaceName();

  String longName = '';
  String shortName = '';

  PlaceName.fromJson(dynamic json) {
    longName = json['long_name'];
    shortName = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['long_name'] = longName;
    map['short_name'] = shortName;
    return map;
  }

  @override
  String toString() {
    return '$longName';
  }
}
