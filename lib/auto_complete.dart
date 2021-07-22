part of 'google_maps_pro.dart';

class AutoCompleteAddressSearch extends StatefulWidget {
  AutoCompleteAddressSearch({
    Key? key,
    required this.apiKey,
    required this.geocodeResponse,
    this.optionsViewBuilder,
    this.types = 'geocode',
    this.componentsFilter,
    this.sessionToken,
    this.offset,
    this.inputDecoration,
    this.disableLogo = false,
  }) : super(key: key) {
    ApiProvider.mapApiKey = this.apiKey;
  }

  final String apiKey;

  /// If not provided, will build a standard Material-style list of results by
  /// default.
  final AutocompleteOptionsViewBuilder<Predictions>? optionsViewBuilder;

  ///The types of place results to return.
  ///See [Place Types] <https://developers.google.com/maps/documentation/places/web-service/autocomplete#place_types>
  ///
  ///If no type is specified, all types will be returned.
  final String types;

  /// You can set the Geocoding Service to return address results restricted to a specific area, by
  /// using a components filter
  ///<https://developers.google.com/maps/documentation/javascript/geocoding#ComponentFiltering>
  final ComponentsFilter? componentsFilter;

  ///Set Decoration for [TextField]
  final InputDecoration? inputDecoration;

  ///<https://developers.google.com/maps/documentation/places/web-service/autocomplete#session_tokens>
  final dynamic sessionToken;

  ///The position, in the input term, of the last character that the service uses to match predictions.
  ///For example, if the input is 'Google' and the offset is 3, the service will match on 'Goo'.
  ///The string determined by the offset is matched against the first word in the input term only.
  ///For example, if the input term is 'Google abc' and the offset is 3, the service will attempt to match against 'Goo abc'.
  ///If no offset is supplied, the service will use the whole term.
  ///The offset should generally be set to the position of the text caret.
  final int? offset;

  /// This will return the full details of search address
  final Function(Results?) geocodeResponse;

  ///Google logo will be displayed in the search list due to policy
  ///<https://developers.google.com/maps/documentation/places/web-service/policies#powered>
  ///
  /// *If you set to true this package is not responsible for it.
  final bool disableLogo;

  @override
  _AutoCompleteAddressSearchState createState() =>
      _AutoCompleteAddressSearchState();
}

class _AutoCompleteAddressSearchState extends State<AutoCompleteAddressSearch> {
  final _MapSearchCubit _mapSearchCubit = _MapSearchCubit();

  Iterable<Predictions> _prediction = const Iterable<Predictions>.empty();

  static String _displayStringForOption(Predictions option) =>
      option.description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<_MapSearchCubit, _MapSearchState>(
      bloc: _mapSearchCubit,
      listener: (context, state) {
        if (state is AutoCompleteSearchResponse) {
          print('STATE ::');

          _prediction =
              state.autoCompleteModel.predictions!.whereType<Predictions>();
          print(
              List<String>.from(_prediction.map((e) => '${e.description}\n')));

          setState(() {});
        }
      },
      child: _AddressAutoComplete<Predictions>(
        context: context,
        displayStringForOption: _displayStringForOption,
        onSelected: (Predictions onSelected) async {
          print('onSelected :::');
          print(onSelected);
          Map<String, dynamic> _queryParameter = <String, dynamic>{
            'key': ApiProvider.mapApiKey,
            'place_id': '${onSelected.placeId}'
          };
          widget.geocodeResponse(
              (await _mapSearchCubit.getGeocodeData(_queryParameter))
                  .results
                  ?.first);
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isNotEmpty &&
              textEditingValue.text.length >= 3) {
            _mapSearchCubit.getAutoSearchData({
              'types': widget.types,
              'components': widget.componentsFilter == null
                  ? ''
                  : widget.componentsFilter!.toJson(),
              'input': textEditingValue.text,
              'offset': widget.offset,
              'sessiontoken':
                  widget.sessionToken ?? DateTime.now().microsecondsSinceEpoch,
              'key': ApiProvider.mapApiKey
            });
          }

          return _prediction;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return _AutocompleteField(
            focusNode: focusNode,
            textEditingController: textEditingController,
            onFieldSubmitted: onFieldSubmitted,
            inputDecoration: widget.inputDecoration,
          );
        },
        optionsViewBuilder: widget.optionsViewBuilder ??
            (BuildContext context,
                AutocompleteOnSelected<Predictions> onSelected,
                Iterable<Predictions> options) {
              return _AutocompleteOptions<Predictions>(
                displayStringForOption: _displayStringForOption,
                onSelected: onSelected,
                options: options,
                disableLogo: widget.disableLogo,
              );
            },
      ),
    );
  }
}
