class ComponentsFilter {
  /// matches long or short name of a route.
  final String route;

  ///matches against locality and sublocality types.
  final String locality;

  /// matches all the levels of administrative area.
  final String administrativeArea;

  /// matches postal codes and postal code prefixes.
  final String postalCode;

  /// matches a country name or a two letter ISO 3166-1 country code. Note: The API follows the ISO standard for defining countries,
  /// and the filtering works best when using the corresponding ISO code of the country.
  final String country;

  ComponentsFilter(
      {this.route = '', this.locality = '', this.administrativeArea = '', this.postalCode = '', this.country = ''});

  String toJson() {
    return 'route:$route|locality:$locality|administrative_area:$administrativeArea|postal_code:$postalCode|country'
        ':$country';
  }
}
