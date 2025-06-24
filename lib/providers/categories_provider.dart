// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kidys_distributor/models/item.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:provider/provider.dart';

import '../models/cataegory.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Item> _items = [];
  List<Item> _filteredItems = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Item> get items {
    return [..._items];
  }

  List<Item> get filteredItems {
    return [..._filteredItems];
  }

  String activeCategoryName = "";
  String activeCategoryKey = "";

  Future<void> fetchCategoriesFromDB({bool isBulandshehar = false}) async {
    const url =
        "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/onlyCategories.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Category> loadedCategories = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(Category(
            id: categoryId,
            imageUrl: categoryData['imageUrl'],
            sortOrder : categoryData['sortOrder']!=null ? categoryData['sortOrder'] : 99999,
            categoryName: categoryData['categoryName']));
      });
      // print("fetched category data  = ");
      // loadedCategories.forEach((element) {
      //   print(element);
      // });

      if (isBulandshehar) {
        loadedCategories.removeWhere((category) => category.categoryName == "Coca Cola");
      } 

       // Sort categories based on sortOrder, if it's not null
    loadedCategories.sort((a, b) {
      if (a.sortOrder == null) return 1; // Put null sortOrder at the end
      if (b.sortOrder == null) return -1;
      return a.sortOrder!.compareTo(b.sortOrder!); // Compare based on sortOrder
    });



      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      print("CATEGORIES FETCH FAILED!");
      throw error;
    }
  }

  Future<void> loadItemsForActiveCategory() async {
  final url = "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/Categories/$activeCategoryKey/items.json";
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
