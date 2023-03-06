import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:test_task_tbr_group/api/country_api.dart';
import 'package:test_task_tbr_group/api/geo_api.dart';
import 'package:test_task_tbr_group/constants.dart';
import 'package:test_task_tbr_group/models/country_model.dart';
import 'package:test_task_tbr_group/models/get_countries.dart';
import 'package:test_task_tbr_group/services/country_service.dart';
import 'package:test_task_tbr_group/widgets/list_of_country_codes.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController phoneNumberController = TextEditingController();
  GetCountries? getCountries;
  Future? future;
  bool _isBottomActive = false;

  @override
  void initState() {
    future = CountryService(CountryApi(), GeoApi()).getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (getCountries == null) {
                getCountries = snapshot.data!;
              }
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      top: 48,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tittle(),
                      const SizedBox(height: 160),
                      _phoneForm(context),
                    ],
                  ),
                ),
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: _confirmButton(),
    );
  }

  Widget _tittle() {
    return const Text(
      'Get Started',
      style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
    );
  }

  Widget _phoneForm(BuildContext context) {
    return Form(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _countryCodeButton(context),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: _phoneField())
      ],
    ));
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await showMaterialModalBottomSheet(
        expand: true,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ListOfCountryCodes(
            originaListCountries: getCountries!.listCountries,
          );
        });
    if (result is CountryModel) {
      setState(() {
        getCountries!.activeCountry = result;
      });
    }
  }

  Widget _countryCodeButton(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: kHelpColor.withOpacity(0.4),
        ),
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: 24,
                width: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(getCountries!.activeCountry.flag),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                getCountries!.activeCountry.countryCode!.toString(),
                style: const TextStyle(fontSize: 15, color: kActiveTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      onChanged: (value) {
        _changeButton(value);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        MaskPhoneNumber(),
      ],
      controller: phoneNumberController,
      cursorColor: kActiveTextColor,
      keyboardType: TextInputType.number,
      style: const TextStyle(
          color: kActiveTextColor, fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: kHelpColor.withOpacity(0.4),
        hintText: '(123) 123-1234',
        hintStyle: const TextStyle(fontSize: 16, color: kHintTextColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      height: 48.0,
      width: 48.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            disabledBackgroundColor: kHelpColor.withOpacity(0.4),
            backgroundColor: Colors.white),
        onPressed: _isBottomActive
            ? () {
                showAlertDialog(context, phoneNumberController.text);
              }
            : null,
        child: SvgPicture.asset('assets/icons/Fill 4.svg'),
      ),
    );
  }

  void _changeButton(String value) {
    if (value.length == 14 && !_isBottomActive) {
      _setIsActiveButton(true);
    } else if (value.length != 14 && _isBottomActive) {
      _setIsActiveButton(false);
    }
  }

  void _setIsActiveButton(bool value) {
    setState(() {
      _isBottomActive = value;
    });
  }

  showAlertDialog(BuildContext context, String phoneNumber) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Entered phone number",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(
          '${getCountries!.activeCountry.countryCode!} $phoneNumber',
          style: const TextStyle(fontSize: 16)),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class MaskPhoneNumber extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String mask = '(xxx) xxx-xxxx';
    int position = newValue.selection.end;
    var listnumbers = newValue.text.split('');
    for (var element in listnumbers) {
      mask = mask.replaceFirst('x', element);
    }

    if (listnumbers.isNotEmpty) position++;

    if (listnumbers.length > 3) position += 2;

    if (listnumbers.length > 6) position++;

    if (listnumbers.length >= 10) position = mask.length;

    if (listnumbers.isEmpty) {
      mask = '';
    } else if (mask.contains('x')) {
      mask = mask.substring(0, mask.indexOf('x'));
      if (mask.endsWith('-')) {
        mask = mask.substring(0, mask.indexOf('-'));
      }
    }

    return TextEditingValue(
        text: mask, selection: TextSelection.collapsed(offset: position));
  }
}
