import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart' as offer_bloc;
import 'package:hoora/bloc/project/project_bloc.dart' as project_bloc;
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/offer/offers_page.dart';
import 'package:hoora/ui/page/project/projects_page.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;

import '../../bloc/offer/offer_bloc.dart';
import '../../common/alert.dart';
import '../../model/city_model.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  PageController controller = PageController(initialPage: 0);
  int pageIndex = 0;
  final TextEditingController searchController = TextEditingController();
  late OfferBloc offerBloc;
  bool isSuggestionShowed = false;
  List<dynamic> suggestSearch = [];
  @override
  void initState() {
    super.initState();
    offerBloc = context.read<OfferBloc>();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
    context.read<OfferBloc>().add(offer_bloc.FirstTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground2,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<offer_bloc.OfferBloc, offer_bloc.OfferState>(
        listener: (context, state) {
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }

          //if(state is InitSuccess){
          // offerPageState.currentState!.refreshCategories(state.categories);
          //}
          if (state is GetOffersSuccess) {
            if(state.doesFind){
              isSuggestionShowed = false;
              if(state.searchText.isNotEmpty){
                searchController.text = state.searchText;
              }
            }else{
              searchController.clear();
            }
          }
          if (state is GetSuggestionsSuccess ){
            suggestSearch = state.suggestion;
            isSuggestionShowed = true;
          }
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }
          if (state is SuggestionEmptied) {
            setState(() {
              isSuggestionShowed = false;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: kBackground2,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    kPadding20,
                    MediaQuery.of(context).padding.top + kPadding20,
                    kPadding20,
                    kPadding20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dépenser mes\nDiamz",
                        style: kBoldARPDisplay18,
                      ),
                      GemButton(isLight: true, bigGem: true),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding10),
                ///search
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Stack(
                    children: [
                      Center(child: Image.asset("assets/images/searchbar.png", fit: BoxFit.fill, height: 50, width: 500)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  offerBloc.add(SearchOffers(search: searchController.text));
                                  setState(() {
                                    isSuggestionShowed = false;
                                  });
                                },
                                child: const SizedBox(
                                  width: 40,
                                  child: Icon(Icons.search, color: kPrimary),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  controller: searchController,
                                  onChanged: (text) {
                                    if (text.isNotEmpty) {
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        if (!mounted) return;
                                        if (searchController.text.isNotEmpty && text == searchController.text) {
                                          offerBloc.add(GetSuggestions(search: searchController.text));
                                        }
                                      });
                                    } else {
                                      debugPrint("khali shod");
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        debugPrint("Future.delayed");
                                        if (searchController.text.isEmpty) {
                                          debugPrint("khali hast");
                                          offerBloc.add(EmptySuggestions());
                                        }
                                      });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    offerBloc.add(SearchOffers(search: searchController.text));
                                    FocusManager.instance.primaryFocus!.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher ville',
                                    border: InputBorder.none,
                                    hintStyle: kRegularNunito14.copyWith(color: const Color(0xffA0A0A0)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSuggestionShowed)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.topCenter,
                      color: kBackground2,
                      child: ListView.builder(
                        itemCount: suggestSearch.length,
                        itemBuilder: (itemBuilder, index) {
                          return GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              setState(() {
                                isSuggestionShowed = false;
                              });
                              if (suggestSearch[index] is City) {
                                var selectedCity = (suggestSearch[index] as City);
                                searchController.text = selectedCity.name;
                                offerBloc.add(CitySelected(city: selectedCity));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child: Row(
                                children: [
                                  const Icon(size: 24, Icons.location_city_sharp, color: kPrimary),
                                  const SizedBox(width: kPadding20),
                                  Text(
                                    (suggestSearch[index] as City).name,
                                    style: kRegularNunito14.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(kPadding20, kPadding40, kPadding20, kPadding20),
                          child: buildButtons(),
                        ),
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller,
                            children: const [
                              OffersPage(),
                              ProjectsPage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );;
        },
      ),
    );
  }

  Widget buildButtons() {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        height: 30,
        child: Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (pageIndex != 0) {
                  context.read<offer_bloc.OfferBloc>().add(offer_bloc.Init());
                  controller.jumpToPage(0);
                  setState(() {
                    pageIndex = 0;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/offer_gift.svg"),
                      const SizedBox(width: kPadding10),
                      const Text("Cadeaux", style: kRBoldNunito18),
                    ],
                  ),
                  const Spacer(),

                  /// Indictor
                  Container(
                    height: pageIndex == 0 ? 4 : 1,
                    width: constraint.maxWidth / 2,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: pageIndex == 0 ? BorderRadius.circular(kRadius100) : null,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (pageIndex != 1) {
                  context.read<project_bloc.ProjectBloc>().add(project_bloc.Init());
                  controller.jumpToPage(1);
                  setState(() {
                    pageIndex = 1;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/tree.svg"),
                      const SizedBox(width: kPadding10),
                      const Text("Associations", style: kRBoldNunito18),
                    ],
                  ),
                  const Spacer(),

                  /// Indictor
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: pageIndex == 1 ? BorderRadius.circular(kRadius100) : null,
                    ),
                    height: pageIndex == 1 ? 4 : 1,
                    width: constraint.maxWidth / 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
