import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/ui/page/explore/city_page.dart';

class RegionPage extends StatelessWidget {
  final List<Region> regions;
  final Region selectedRegion;
  final City? selectedCity;
  final void Function(Region) onRegionSelected;
  final void Function(Region, City) onCitySelected;

  const RegionPage({
    super.key,
    required this.regions,
    required this.selectedRegion,
    required this.selectedCity,
    required this.onRegionSelected,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: LayoutBuilder(builder: (_, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  "Choisissez la zone à explorer",
                  style: kBoldARPDisplay16,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Builder(builder: (_) {
                  List<Widget> children = [];
                  for (int i = 0; i < regions.length; i++) {
                    Region region = regions[i];

                    children.add(Padding(
                      padding: const EdgeInsets.all(kPadding10),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: region.id == selectedRegion.id ? kSecondary : kUnselected,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityPage(
                                  onCitySelected: onCitySelected,
                                  onRegionSelected: onRegionSelected,
                                  region: region,
                                  selectedCity: selectedCity,
                                  selectedRegion: selectedRegion,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            region.name,
                            style: kBoldNunito16,
                          ),
                        ),
                      ),
                    ));
                  }
                  return Column(children: children);
                }),
              ),
              const Spacer(),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Certaines régions sont actuellement en préparation et seront bientôt disponibles",
                  style: kRegularNunito12,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
            ],
          );
        }),
      )),
    );
  }
}
