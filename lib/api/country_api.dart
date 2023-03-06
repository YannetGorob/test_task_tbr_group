import 'package:test_task_tbr_group/constants.dart';
import 'dart:convert';
import 'package:test_task_tbr_group/models/country_model.dart';

class CountryApi {
  Future<List<CountryModel>> getCountry() async {
    final response =
        await AppSettings.client.get(Uri.parse('${AppSettings.domain}v3/all'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      try {
        final result = (responseJson as List)
            .map((e) => CountryModel.fromJson(e))
            .where((element) => element.countryCode != null)
            .toList();
        result.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return result;
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(response.body);
    }
  }
}
