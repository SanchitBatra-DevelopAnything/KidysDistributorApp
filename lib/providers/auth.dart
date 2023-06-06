import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kidys_distributor/models/area.dart';
import 'package:kidys_distributor/models/distributor.dart';

class AuthProvider with ChangeNotifier {
  List<Area> _areas = [];
  List<Distributor> _distributors = [];

  String loggedInDistributor = "";
  String loggedInArea = "";

  String dbURL = "https://kidysadminapp-default-rtdb.firebaseio.com/";

  List<Area> get areas {
    return [..._areas];
  }

  List<String> get areaNames {
    return [..._areas].map((e) => e.areaName).toList();
  }

  List<Distributor> get distributors {
    return [..._distributors];
  }

  List<String> get distributorNames {
    return [..._distributors]
        .map((retailer) => retailer.distributorName)
        .toList();
  }

  Future<void> distributorSignUp(
      String distributorName, String area, String GSTNumber) async {
    //send http post here.
    const url =
        "https://kidysadminapp-default-rtdb.firebaseio.com/DistributorNotifications.json";
    await http.post(Uri.parse(url),
        body: json.encode({
          'distributorName': distributorName,
          'area': area,
          'GST': GSTNumber
        }));
  }

  Future<void> fetchAreasFromDB() async {
    const url = "https://kidysadminapp-default-rtdb.firebaseio.com/Areas.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Area> loadedAreas = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((shopId, areaData) {
        loadedAreas.add(Area(areaName: areaData['areaName']));
      });
      _areas = loadedAreas;
      _areas.sort(
        (a, b) => a.areaName.compareTo(b.areaName),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchDistributorsFromDB() async {
    const url =
        "https://kidysadminapp-default-rtdb.firebaseio.com/Distributors.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Distributor> loadedDistributors = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((distributorId, distributorData) {
        loadedDistributors.add(Distributor(
            id: distributorId,
            area: distributorData['area'],
            distributorName: distributorData['distributorName'],
            attached_price_list: distributorData['attachedPriceList'],
            GSTNumber: distributorData['GST']));
      });
      _distributors = loadedDistributors;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setLoggedInDistributorAndArea(
      String distributorName, String area) async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // sharedPreferences.setString("loggedInRetailer", retailerName);
    // sharedPreferences.setString("loggedInShop", shopName);
    this.loggedInDistributor = distributorName;
    this.loggedInArea = area;
    notifyListeners();
  }
}
