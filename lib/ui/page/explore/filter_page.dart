import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/user/settings/help_page.dart';

DateTime today = DateTime.now();

class FilterPage extends StatefulWidget {
  DateTime selectedDate;
  String sortingType;
  String zone;
  bool openSpots = true;
  final void Function(DateTime,String,String,bool) onSubmit;

   FilterPage({super.key,required this.openSpots, required this.selectedDate,required this.sortingType,required this.zone, required this.onSubmit});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    //await addLocationsOffers();
    //await addLocationsOffers();
    //await removeLatLngOffers();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        if(didPop){
          return;
        }
        Navigator.pop(context);
        widget.onSubmit(widget.selectedDate,widget.zone,widget.sortingType,widget.openSpots);
      },
      child: Scaffold(
        backgroundColor: kBlackGreen,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,0,),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: kPadding20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onSubmit(widget.selectedDate,widget.zone,widget.sortingType,widget.openSpots);
                              },
                              icon: SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: Colors.white,height: 24,width: 24,) ,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (builder)=>const HelpPage()));
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(kRadius10))
                                ),
                                child: Center(
                                  child: Text(
                                    "?",
                                    style: kRBoldNunito32.copyWith(color:kBlackGreen),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(kPadding30,kPadding20,0,kPadding20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: kPadding20),
                            FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Text(
                                "Filtres",
                                style: kBoldARPDisplay16.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: kPadding40),
          
                            Text(
                              "Quel jour de visite",
                              style: kRegularNunito14.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: kPadding10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width/2.85,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 0))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today.add(const Duration(days: 0)).day != widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 0));
                                            });
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 0)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,0,0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/2.85,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 4))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today.add(const Duration(days: 4)).day != widget.selectedDate.day) {
                                              setState(() {
                                                widget.selectedDate = today.add(const Duration(days: 4));
                                              });
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today.add(const Duration(days: 4))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 4)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width/2.85,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 1))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today
                                              .add(const Duration(days: 1))
                                              .day !=
                                              widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 1));
                                            });
          
                                          }
                                        },
                                        child:  Text(
                                          _getWeekday(today.add(const Duration(days: 1))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 1)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding10,0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/2.85,
                                      height: 40,
                                      child: ElevatedButton(
          
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 5))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today
                                              .add(const Duration(days: 5))
                                              .day !=
                                              widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 5));
                                            });
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today.add(const Duration(days: 5))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 5)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width/2.85,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 2))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today
                                              .add(const Duration(days: 2))
                                              .day !=
                                              widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 2));
                                            });
          
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today.add(const Duration(days: 2))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 2)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding10,0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/2.85,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 6))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today
                                              .add(const Duration(days: 6))
                                              .day !=
                                              widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 6));
                                            });
          
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today.add(const Duration(days: 6))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 6)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,0,0),
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width/2.85,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,  // Border color
                                            width: 2,           // Border width
                                          ),
                                          backgroundColor: today
                                              .add(const Duration(days: 3))
                                              .day ==
                                              widget.selectedDate.day
                                              ? Colors.white
                                              : kBlackGreen,
                                        ),
                                        onPressed: () {
                                          if (today
                                              .add(const Duration(days: 3))
                                              .day !=
                                              widget.selectedDate.day) {
                                            setState(() {
                                              widget.selectedDate = today.add(const Duration(days: 3));
                                            });
                                          }
                                        },
                                        child: Text(
                                          _getWeekday(today.add(const Duration(days: 3))),
                                          style: kBoldNunito14.copyWith(color:today.add(const Duration(days: 3)).day == widget.selectedDate.day ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding10,0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/2.85,
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: kPadding40),
          
                            Text(
                              "Ouverture / Fermeture :",
                              style: kRegularNunito14.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: kPadding10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.openSpots = false;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                            color: !widget.openSpots ? Colors.white: kBlackGreen,
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ouverts et Fermés",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:!widget.openSpots ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,0,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.openSpots = true;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                            color: widget.openSpots ? Colors.white: kBlackGreen,
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ouverts uniquement",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:widget.openSpots ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: kPadding40),
          
                            Text(
                              "Affichage :",
                              style: kRegularNunito14.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: kPadding10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.sortingType = "all";
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: kPadding5,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                            color: widget.sortingType == "all" ? Colors.white: kBlackGreen,
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Tous les spots",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:widget.sortingType == "all" ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,0,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.sortingType = "rewarded";
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                            color: widget.sortingType == "rewarded" ? Colors.white: kBlackGreen,
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Spots récompensés",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:widget.sortingType == "rewarded" ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: kPadding40),
          
                            Text(
                              "Zone géographique",
                              style: kRegularNunito14.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: kPadding10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,kPadding5,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.zone = "region";
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: kPadding5,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                          color: widget.zone == "region" ? Colors.white: kBlackGreen,
                                          border: Border.all(color: Colors.white,width: 2),
                                          borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ville et alentours",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:widget.zone == "region" ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(kPadding5,0,0,0),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.zone = "city";
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(vertical: kPadding5,horizontal: 8),
                                        width: MediaQuery.of(context).size.width/2.85,
                                        decoration: BoxDecoration(
                                            color: widget.zone == "city" ? Colors.white: kBlackGreen,
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: const BorderRadius.all(Radius.circular(24))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ville uniquement",
                                            textAlign: TextAlign.center,
                                            style: kBoldNunito14.copyWith(color:widget.zone == "city" ? Colors.black : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              )),
        ),
      ),
    );
  }
}
Future<void> myFunction() async {
  // Reference to the Firestore collection
  var crowdReportC = FirebaseFirestore.instance.collection('crowdReport');
  try {
    // Fetch all documents from the 'spots' collection
    QuerySnapshot snapshot = await crowdReportC.get();

    // Iterate through each document and add the 'superType' field
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Update each document with the new 'superType' field
      var spot = await FirebaseFirestore.instance.collection('spot').doc(doc.get("spotId")).get();
      var list = [];
      try{
        list = spot.get("allCrowdReports") as List;
      }catch(e){

      }
      list.add(doc.data());
      await FirebaseFirestore.instance.collection('spot').doc(doc.get("spotId")).update({
        'allCrowdReports': list, // Set the appropriate value for the superType field
      });
      // Retrieve the document to check the updated data
      // Print the updated field
      print("Updated 'allCrowdReports'"+doc.get("spotId"));
    }

    print("All spots have been updated with the new 'allCrowdReports' field.");
  } catch (e) {
    print("Error updating spots: $e");
  }
}
Future<void> myFunction3() async {
  var crowdReportC = FirebaseFirestore.instance.collection('spot');
  try {
    QuerySnapshot snapshot = await crowdReportC.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await FirebaseFirestore.instance.collection('spot').doc(doc.id).update({
        'superType': FieldValue.delete(), // Set the appropriate value for the superType field
      });
      print("'superType' field.");
    }

    print("All spots have been updated with the new 'superType' field.");
  } catch (e) {
    print("Error updating spots: $e");
  }
}
Future<void> removeLastCrowdReports() async {
  var crowdReportC = FirebaseFirestore.instance.collection('spot');
  try {
    QuerySnapshot snapshot = await crowdReportC.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      print("salam");
      await FirebaseFirestore.instance.collection('spot').doc(doc.id).update({
        //'lastCrowdReport': FieldValue.delete(),
        'allCrowdReports': [],
      });
    }

    print("All spots have been updated with the new 'allCrowdReports' field.");
  } catch (e) {
    print("Error updating spots: $e");
  }
}
Future<void> addLocationsOffers() async {
  var crowdReportC = FirebaseFirestore.instance.collection('offer');
  try {
    QuerySnapshot snapshot = await crowdReportC.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      print("salam");
      await FirebaseFirestore.instance.collection('offer').doc(doc.id).update({
        'locations': []
      });
      // if(doc['latitude']!=null){
      //   await FirebaseFirestore.instance.collection('offer').doc(doc.id).update({
      //     'locations': [
      //       {
      //         'point':GeoPoint(doc['latitude'], doc['longitude']),
      //         "cityId":doc['cityId']
      //       }
      //     ]
      //   });
      // }else{
      //   await FirebaseFirestore.instance.collection('offer').doc(doc.id).update({
      //     'locations': []
      //   });
      // }
    }

    print("All spots have been updated with the new 'longitude' field.");
  } catch (e) {
    print("Error updating spots: $e");
  }
}
Future<void> removeLatLngOffers() async {
  var crowdReportC = FirebaseFirestore.instance.collection('offer');
  try {
    QuerySnapshot snapshot = await crowdReportC.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      print("salam");
      // await FirebaseFirestore.instance.collection('offer').doc(doc.id).update({
      //   'latitude': FieldValue.delete(),
      //   'longitude': FieldValue.delete(),
      // });
      await FirebaseFirestore.instance.collection('offer').doc(doc.id).update({
        'locations': [],
        'cityId':FieldValue.delete()
      });
    }

    print("All spots have been updated with the new 'longitude' field.");
  } catch (e) {
    print("Error updating spots: $e");
  }
}

String _getWeekday(DateTime date) {
  DateTime today = DateTime.now();
  if (date.day == today.day) {
    return "Aujourd'hui";
  } else if (date.day == today.day + 1) {
    return "Demain";
  }
  return date.getWeekday();
}

