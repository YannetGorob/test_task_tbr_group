class CountryModel {
  String name;
  String flag;
  CountryCode? countryCode;

  CountryModel(
      {required this.name, required this.flag, required this.countryCode});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    var result = CountryModel(
      name: json['name']['common'],
      flag: (json['flags'] as List)
          .map((e) => e.toString())
          .firstWhere((element) => element.contains('.png')),
      countryCode: json['idd']['root'] == null
          ? null
          : CountryCode.fromJson(json['idd']),
    );
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'flag': flag,
      'idd': countryCode,
    };
  }
}

class CountryCode {
  String root;
  List<String> suffixes;

  CountryCode({required this.root, required this.suffixes});

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      root: json['root'],
      suffixes: (json['suffixes'] as List).map((e) => e.toString()).toList(),
    );
  }

  @override
  String toString() {
    if (suffixes.length == 1) {
      return root + suffixes.first;
    } else {
      return root;
    }
  }
}

