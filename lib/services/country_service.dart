import 'package:test_task_tbr_group/api/country_api.dart';
import 'package:test_task_tbr_group/api/geo_api.dart';
import 'package:test_task_tbr_group/models/get_countries.dart';

class CountryService {
  final CountryApi _countryApi;
  final GeoApi _geoApi;

  CountryService(this._countryApi, this._geoApi);

  Future<GetCountries> getCountries() async {
    var result = await _countryApi.getCountry();
    try {
      var country = await _geoApi.getCountry();
      var myCountry = result.firstWhere(
          (element) => element.name.toLowerCase() == country.toLowerCase());
      return GetCountries(result, myCountry);
    } catch (e) {
      return GetCountries(result, result.first);
    }
  }
}
