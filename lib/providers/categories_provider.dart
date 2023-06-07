import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/cataegory.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

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
            imageUrl: categoryData['imgUrl'],
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
}
