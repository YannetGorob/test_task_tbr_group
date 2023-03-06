import 'package:test_task_tbr_group/constants.dart';
import 'dart:convert';

class GeoApi {
  Future<String> getCountry() async {
    final response =
        await AppSettings.client.get(Uri.parse('${AppSettings.geoDomain}?key=tryout'));
    if (response.statusCode == 200) {
       return json.decode(response.body)['location']['country']['name'];
    } else {
      throw Exception(response.body);
    }
  }
}
