import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/region_model.dart';

class CityPage extends StatelessWidget {
  final Region region;
  final Region selectedRegion;
  final City? selectedCity;
  final void Function(Region) onRegionSelected;
  final void Function(Region, City) onCitySelected;

  const CityPage({
    super.key,
    required this.region,
    required this.selectedRegion,
    required this.selectedCity,
    required this.onRegionSelected,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: LayoutBuilder(builder: (_, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: kPadding20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      size: 32,
                      color: kPrimary,
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                const FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Text(
                    "Quelle ville voulez vous explorer ?",
                    style: kBoldARPDisplay16,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kPadding20),
                Expanded(
                  child: Builder(builder: (_) {
                    List<Widget> children = [
                      Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    region.id == selectedRegion.id && selectedCity == null ? kSecondary : kUnselected,
                              ),
                              onPressed: () {
                                if (selectedRegion.id != region.id || selectedCity != null) {
                                  Navigator.popUntil(context, ModalRoute.withName("/home"));
                                  onRegionSelected(region);
                                }
                              },
                              child: const Text(
                                "Toute la région",
                                style: kBoldNunito16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ];

                    List<City> cities = region.cities;
                    for (int i = 0; i < cities.length; i++) {
                      City city = cities[i];

                      if (city.spotQuantity < 10) {
                        continue;
                      }

                      children.add(Padding(
                        padding: const EdgeInsets.all(kPadding10),
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    selectedCity != null && city.id == selectedCity!.id ? kSecondary : kUnselected,
                              ),
                              onPressed: () {
                                if (selectedCity == null || selectedCity!.id != city.id) {
                                  Navigator.popUntil(context, ModalRoute.withName("/home"));

                                  onCitySelected(region, city);
                                }
                              },
                              child: Text(
                                city.name,
                                style: kBoldNunito16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                    children.add(const SizedBox(height: kPadding20));
                    return Center(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: children,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
