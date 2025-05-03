import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hoora/common/globals.dart';
import 'package:hoora/model/super_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? preferences;
  static Future<void> initLocalStorage() async {
    preferences ??= await SharedPreferences.getInstance();
  }
  static SharedPreferences getInstance()  {
    return preferences! ;
  }
  static void saveSuperTypes(List<SuperType> types) {
    var json = jsonEncode(types.map((e) => e.toJson()).toList());
    preferences!.setString(AppConstants.superTypeListSharedKey, json.toString());
  }
  static List<SuperType> getSuperTypes() {

    String json = preferences!.getString(AppConstants.superTypeListSharedKey) ?? '';


    List<SuperType> result =[];

    if(json.isNotEmpty){
      var d = jsonDecode(json);
      for(var item in d){
        result.add(SuperType.fromJson(item));
      }
    }
    return result;
  }

  static List<T> jsonArrayToList<T>(List jsonArray, Function(dynamic json) jsonToObject) {
    try {
      List<T> items = [];

      for (var element in jsonArray) {
        items.add(jsonToObject(element));
      }
      return items;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}