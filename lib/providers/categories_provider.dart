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

  Future<void> fetchCategoriesFromDB() async {
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
    var url = "https://odo-admin-app-default-rtdb.asia-southeast1.firebasedatabase.app/Categories/" +
        activeCategoryKey +
        "/items.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Item> loadedItems = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((ItemId, ItemData) {
        loadedItems.add(Item(
            id: ItemId,
            imgUrl: ItemData['imgUrl'],
            itemName: ItemData['itemName'],
            itemPrice : ItemData['itemPrice'],
            slab_1_start : ItemData['slab_1_start'] == null ? null : ItemData['slab_1_start'],
            slab_1_end : ItemData['slab_1_end'] == null ? null : ItemData['slab_1_end'],
            slab_2_start : ItemData['slab_2_start'] == null ? null : ItemData['slab_2_start'],
            slab_2_end : ItemData['slab_2_end'] == null ? null : ItemData['slab_2_end'],
            slab_3_start : ItemData['slab_3_start'] == null ? null : ItemData['slab_3_start'],
            slab_3_end : ItemData['slab_3_end'] == null ? null : ItemData['slab_3_end'],
            slab_1_discount : ItemData['slab_1_discount'] == null ? null : ItemData['slab_1_discount'],
            slab_2_discount : ItemData['slab_2_discount'] == null ? null : ItemData['slab_2_discount'],
            slab_3_discount : ItemData['slab_3_discount'] == null ? null : ItemData['slab_3_discount']));
      });
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
