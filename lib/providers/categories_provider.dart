// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kidys_distributor/models/item.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:provider/provider.dart';

import '../models/cataegory.dart';
import '../models/cataegory.dart';
import '../models/brand.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Brand> _brands = [];
  List<Item> _items = [];
  List<Item> _filteredItems = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Brand> get brands {
    return [..._brands];
  }

  List<Item> get items {
    return [..._items];
  }

  List<Item> get filteredItems {
    return [..._filteredItems];
  }

  String activeCategoryName = "";
  String activeCategoryKey = "";
  String activeBrandName = "";
  String activeBrandKey = "";

  Future<void> fetchBrandsFromDB({bool isBulandshehar = false}) async {
    const url =
        "http://10.0.2.2:8080/v1/brands";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Brand> loadedBrands = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((brandId, brandData) {
        loadedBrands.add(Brand(
            id: brandId,
            imageUrl: brandData['imageUrl'],
            sortOrder : brandData['sortOrder']!=null ? brandData['sortOrder'] : 99999,
            brandName: brandData['brandName']));
      });

      if (isBulandshehar) {
        loadedBrands.removeWhere((brand) => brand.brandName == "Coca Cola");
      } 

    
    loadedBrands.sort((a, b) {
      if (a.sortOrder == null) return 1; // Put null sortOrder at the end
      if (b.sortOrder == null) return -1;
      return a.sortOrder!.compareTo(b.sortOrder!); // Compare based on sortOrder
    });



      _brands = loadedBrands;
      notifyListeners();
    } catch (error) {
      print("BRANDS FETCH FAILED!");
      throw error;
    }
  }

  Future<void> loadItemsForActiveBrand() async {
  final url = "http://10.0.2.2:8080/v1/items/brand/${activeBrandKey}";
  try {
    final response = await http.get(Uri.parse(url));
    final List<Item> loadedItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((itemId, itemData) {
      loadedItems.add(Item.fromJson(itemId, itemData));
    });

    loadedItems.sort((a, b) => a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()));
    _items = loadedItems;
    _filteredItems = [..._items];
    notifyListeners();
  } catch (error) {
    print("ITEMS FETCH FAILED!");
    throw error;
  }
}


  void filterItems(String searchFor) {
    if (searchFor == '') {
      _filteredItems = [..._items];
      notifyListeners();
      return;
    }
    _filteredItems = [];
    _filteredItems = [
      ..._items
          .where((item) => item.itemName
              .toString()
              .toLowerCase()
              .contains(searchFor.toLowerCase()))
          .toList()
    ];

    notifyListeners();
  }
}
