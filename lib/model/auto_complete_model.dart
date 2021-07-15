class AutoCompleteModel {
  List<Predictions>? _predictions;
  String? _status;

  List<Predictions>? get predictions => _predictions;

  String? get status => _status;

  AutoCompleteModel({List<Predictions>? predictions, String? status}) {
    _predictions = predictions;
    _status = status;
  }

  AutoCompleteModel.fromJson(dynamic json) {
    if (json["predictions"] != null) {
      _predictions = [];
      json["predictions"].forEach((v) {
        _predictions?.add(Predictions.fromJson(v));
      });
    }
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_predictions != null) {
      map["predictions"] = _predictions?.map((v) => v.toJson()).toList();
    }
    map["status"] = _status;
    return map;
  }
}

class Predictions {
  String _description = '';
  String? _placeId;
  List<String>? _types;

  String get description => _description;

  String? get placeId => _placeId;

  List<String>? get types => _types;

  Predictions({String description = '', String? placeId, List<String>? types}) {
    _description = description;
    _placeId = placeId;
    _types = types;
  }

  Predictions.fromJson(dynamic json) {
    _description = json["description"];
    _placeId = json["place_id"];
    _types = json["types"] != null ? json["types"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = _description;
    map["place_id"] = _placeId;
    map["types"] = _types;
    return map;
  }

  @override
  String toString() {
    return 'Predictions{_description: $_description, _placeId: $_placeId, _types: $_types}';
  }
}
