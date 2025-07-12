import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:kidys_distributor/models/bannerModel.dart';
import 'package:provider/provider.dart';

import '../models/cataegory.dart';
import 'package:http/http.dart' as http;


class BannerProvider with ChangeNotifier {

  List<BannerModel> _banners = [];
  
  

  List<BannerModel> get banners {
    return [..._banners];
  }



  Future<void> fetchBannersFromDB() async {
    const url =
        "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/B2BBanners.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<BannerModel> loadedBanners = [];
      print(response.body);
      if (response.body == null || response.body == "null") {
        _banners = loadedBanners;
      notifyListeners();
  print("Server response is null or empty.");
  return; // Return an empty map or handle it as needed
}
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((bannerId, bannerData) {
        loadedBanners.add(BannerModel(
            
            imageUrl: bannerData['imageUrl'],
            ));
      });
      _banners = loadedBanners;
      notifyListeners();
    } catch (error) {
      print("Banners FETCH FAILED!");
      throw error;
    }
  }
}