import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kidys_distributor/models/area.dart';
import 'package:kidys_distributor/models/distributor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  List<Area> _areas = [];
  List<Distributor> _distributors = [];

  String loggedInDistributor = "";
  String loggedInArea = "";
  String activePriceList = "";
  String activeDistributorKey = "";
  int activeDistributorIndex = -1;
  String loggedInShop = "";
  String loggedIncontact = "";
  String loggedInGSTNumber = "";
  String loggedInShopAddress = "";

  String dbURL = "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/";
  String? _deviceToken = "";

  String? get deviceToken {
    return _deviceToken;
  }

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

   void setActiveDistributorIndex(int newIndex) {
    activeDistributorIndex = newIndex;
    notifyListeners(); // Notify widgets to rebuild
  }

  setupNotifications() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    _deviceToken = await fcm.getToken();
    notifyListeners();
  }

  Future<void> distributorSignUp(String distributorName, String area,
      String GSTNumber, String shop,String contactNumber,String shopAddress , String latitude , String longitude) async {
    //send http post here.
    const url =
        "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/DistributorNotifications.json";
    await http.post(Uri.parse(url),
        body: json.encode({
          'name': distributorName,
          'area': area,
          'GST': GSTNumber,
          'contact': contactNumber,
          'shop' : shop,
          'deviceToken': _deviceToken,
          'shopAddress' : shopAddress,
          'latitude' : latitude,
          'longitude' : longitude
        }));
  }

  Future<void> fetchAreasFromDB() async {
    const url = "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/Areas.json";
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
        "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/Distributors.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Distributor> loadedDistributors = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((distributorId, distributorData) {
        loadedDistributors.add(Distributor(
            id: distributorId,
            area: distributorData['area'],
            distributorName: distributorData['name'],
            shop: distributorData['shop'],
            contact: distributorData['contact'].toString(),
            attached_price_list : "normal-price-list",
            shopAddress : distributorData['shopAddress'].toString(),
            GSTNumber: distributorData['GST']));
      });
      _distributors = loadedDistributors;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> loadLoggedInDistributorData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    this.loggedInDistributor =
        sharedPreferences.getString("loggedInDistributor").toString();
    this.loggedInArea = sharedPreferences.getString("loggedInArea").toString();
    this.activePriceList = sharedPreferences.getString("priceList").toString();
    this.activeDistributorKey =
        sharedPreferences.getString("distributorKey").toString();
    this.loggedInShop = sharedPreferences.getString("loggedInShop").toString();
    this.loggedIncontact = sharedPreferences.getString("loggedIncontact").toString();
    this.loggedInGSTNumber = sharedPreferences.getString("loggedInGSTNumber").toString();
    this.loggedInShopAddress = sharedPreferences.getString("loggedInShopAddress").toString();
    notifyListeners();
  }

  Future<void> setLoggedInDistributorAndArea(String distributorKey) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("loggedInDistributor", _distributors[activeDistributorIndex].distributorName);
    sharedPreferences.setString("loggedInArea", _distributors[activeDistributorIndex].area);
    sharedPreferences.setString("priceList", "normal");
    sharedPreferences.setString("loggedInShop" , _distributors[activeDistributorIndex].shop);
    sharedPreferences.setString("loggedIncontact" , _distributors[activeDistributorIndex].contact);
    sharedPreferences.setString("loggedInGSTNumber",_distributors[activeDistributorIndex].GSTNumber);
    sharedPreferences.setString("loggedInShopAddress" , _distributors[activeDistributorIndex].shopAddress);
    sharedPreferences.setString("distributorKey", distributorKey);
    this.loggedInDistributor = _distributors[activeDistributorIndex].distributorName;
    this.loggedInArea = _distributors[activeDistributorIndex].area;
    this.activePriceList = "normal";
    this.activeDistributorKey = distributorKey;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  Future<void> deleteAccount() async {
    var url =
        "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/${activeDistributorKey}.json";
    try {
      await http.delete(Uri.parse(url));
    } catch (error) {
      throw error;
    }
  }
}
