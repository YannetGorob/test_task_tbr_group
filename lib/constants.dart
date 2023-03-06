import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Colors that we use in our app
const kBackgroundColor = Color(0xFF8EAAFB);
const kHelpColor = Color(0xFFF4F5FF);
const kActiveTextColor = Color(0xFF594C74);
const kHintTextColor = Color(0xFF7886B8);

const double kDefaultPadding = 20.0;

class AppSettings {
  static const String domain = 'https://restcountries.com/';
  static const String geoDomain = 'https://api.ipregistry.co/';

  static http.Client client = http.Client();
}