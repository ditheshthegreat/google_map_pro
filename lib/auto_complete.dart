part of 'google_maps_pro.dart';

class AutoCompleteAddressSearch extends StatefulWidget {
  const AutoCompleteAddressSearch({Key? key, required this.geocodeResponse}) : super(key: key);
  final Function(GeocodeResponse) geocodeResponse;

  @override
  _AutoCompleteAddressSearchState createState() => _AutoCompleteAddressSearchState();
}

class _AutoCompleteAddressSearchState extends State<AutoCompleteAddressSearch> {
  static String _displayStringForOption(Predictions option) => option.description;
  final _MapSearchCubit _mapSearchCubit = _MapSearchCubit();
  Iterable<Predictions> _prediction = const Iterable<Predictions>.empty();

  @override
  Widget build(BuildContext context) {
    return BlocListener<_MapSearchCubit, _MapSearchState>(
      bloc: _mapSearchCubit,
      listener: (context, state) {
        if (state is AutoCompleteSearchResponse) {
          print('STATE ::');
          print(state.autoCompleteModel.predictions!.toList());
          _prediction = state.autoCompleteModel.predictions!.whereType<Predictions>();
          setState(() {});
        }
      },
      child: Autocomplete<Predictions>(
          displayStringForOption: _displayStringForOption,
          onSelected: (Predictions onSelected) async {
            print('onSelected :::');
            print(onSelected);
            Map<String, dynamic> _queryParameter = <String, dynamic>{
              'key': ApiProvider.mapApiKey,
              'place_id': '${onSelected.placeId}'
            };
            widget.geocodeResponse(await _mapSearchCubit.getGeocodeData(_queryParameter));
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isNotEmpty && textEditingValue.text.length >= 3) {
              _mapSearchCubit.getAutoSearchData({
                'types': 'geocode',
                'input': textEditingValue.text,
                'offset': 3,
                'sessiontoken': DateTime.now().microsecondsSinceEpoch,
                'key': ApiProvider.mapApiKey
              });
            }

            return _prediction;
          }),
    );
  }
}
