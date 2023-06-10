// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kidys_distributor/models/item.dart';

import '../models/cataegory.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Item> _items = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Item> get items {
    return [..._items];
  }

  String activeCategoryName = "";
  String activeCategoryKey = "";

  Future<void> fetchCategoriesFromDB() async {
    const url =
        "https://kidysadminapp-default-rtdb.firebaseio.com/Categories.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Category> loadedCategories = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(Category(
            id: categoryId,
            imageUrl: categoryData['imageUrl'],
            categoryName: categoryData['categoryName']));
      });
      print("fetched category data  = ");
      loadedCategories.forEach((element) {
        print(element);
      });
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      print("CATEGORIES FETCH FAILED!");
      throw error;
    }
  }

  Future<void> loadItemsForActiveCategory() async {
    var url = "https://kidysadminapp-default-rtdb.firebaseio.com/Categories/" +
        activeCategoryKey +
        ".json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Item> loadedItems = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((ItemId, ItemData) {
        loadedItems.add(Item(
            id: ItemId,
            imgUrl: ItemData['imgUrl'],
            itemName: ItemData['itemName'],
            western_price: ItemData['western_price'],
            modern_trade_price: ItemData['modern_trade_price'],
            super_stockist_price: ItemData['super_stockist_price'],
            delhi_ncr_price: ItemData['delhi_ncr_price'],
            out_station_price: ItemData['out_station_price']));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      print("ITEMS FETCH FAILED!");
      throw error;
    }
  }
}
