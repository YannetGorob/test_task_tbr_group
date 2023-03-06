import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_task_tbr_group/constants.dart';
import 'package:test_task_tbr_group/models/country_model.dart';

class ListOfCountryCodes extends StatefulWidget {
  final List<CountryModel> originaListCountries;

  const ListOfCountryCodes({super.key, required this.originaListCountries});

  @override
  State<ListOfCountryCodes> createState() => _ListOfCountryCodesState();
}

class _ListOfCountryCodesState extends State<ListOfCountryCodes> {
  List<CountryModel> listCountries = [];

  @override
  void initState() {
    listCountries = widget.originaListCountries;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding, right: kDefaultPadding),
                child: Column(children: [
                  _tittleWithExit(context),
                  const SizedBox(height: 20),
                  _searchCountry(),
                  const SizedBox(height: 24),
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: _countrieListTile()),
                ]),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _countrieListTile() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 60,
          child: ListTile(
              onTap: () {
                setState(() {
                  Navigator.pop(
                    context,
                    listCountries[index].name == 'Russia'
                        ? widget.originaListCountries
                            .firstWhere((element) => element.name == 'Ukraine')
                        : listCountries[index],
                  );
                });
              },
              leading: Container(
                height: 28,
                width: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(listCountries[index].flag),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              title: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "${listCountries[index].countryCode!}   ",
                    style: const TextStyle(
                        color: kActiveTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: listCountries[index].name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))
              ]))),
        );
      },
      itemCount: listCountries.length,
    );
  }

  Widget _tittleWithExit(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Country Code',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
      Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              color: kHelpColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6.0)),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/Union.svg',
            ),
          ))
    ]);
  }

  Widget _searchCountry() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
          color: kHelpColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16.0)),
      child: Row(children: [
        const SizedBox(width: 17),
        SvgPicture.asset(
          'assets/icons/Search.svg',
        ),
        const SizedBox(width: 14),
        Expanded(
            child: TextFormField(
          onChanged: (value) {
            setState(() {
              listCountries = widget.originaListCountries
                  .where((element) =>
                      element.name.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
          style: const TextStyle(fontSize: 16, color: kActiveTextColor),
          cursorColor: kActiveTextColor,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: kHelpColor.withOpacity(0.4),
            hintStyle: const TextStyle(
                fontSize: 16,
                color: kActiveTextColor,
                fontWeight: FontWeight.w500),
            hintText: 'Search',
          ),
        ))
      ]),
    );
  }
}
