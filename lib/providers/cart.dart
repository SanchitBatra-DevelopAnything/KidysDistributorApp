import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/distributorOrderItem.dart';

class CartItem {
  final String id;
  final String title;
  final num quantity;
  final num price;
  final String imageUrl;
  final String parentCategoryType;
  final num totalPrice;

  CartItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.parentCategoryType,
      required this.quantity,
      required this.totalPrice,
      required this.price});

  Map toJson() => {
        'id': this.id,
        'title': this.title,
        'quantity': this.quantity,
        'price': this.price,
        'imageUrl': this.imageUrl,
        'parentCategoryType': this.parentCategoryType,
        'totalPrice': this.totalPrice
      };
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items = {}; //product db id as key.

  List<CartItem> _itemList = [];

  String dispatchDateSelected = "";

  Map<String, CartItem> get items {
    return {..._items!};
  }

  List<CartItem> get itemList {
    return [..._itemList];
  }

  int get itemCount {
    if (_items == null) {
      return 0;
    }
    return _items!.length;
  }

  bool checkInCart(String itemId) {
    return _items!.containsKey(itemId);
  }

  dynamic getQuantity(String itemId) {
    if (checkInCart(itemId)) {
      CartItem? item = _items![itemId];
      return item!.quantity;
    } else {
      return 0;
    }
  }

  void setDispatchDate(String date) {
    dispatchDateSelected = date;
    notifyListeners();
  }

  void resetDispatchDate() {
    dispatchDateSelected = "";
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    _itemList = [];
    notifyListeners();
  }

  num getTotalOrderPrice() {
    double totalPrice = 0;
    _itemList.forEach((element) {
      totalPrice += element.totalPrice;
    });
    return totalPrice;
  }

  void removeItem(String itemId) {
    if (checkInCart(itemId)) {
      _items!.remove(itemId);
      formCartList();
      notifyListeners();
    }
  }

  void formCartList() {
    _itemList = [];
    this._items!.forEach((key, value) {
      _itemList.add(CartItem(
          id: key,
          totalPrice: value.totalPrice,
          imageUrl: value.imageUrl,
          parentCategoryType: value.parentCategoryType,
          price: value.price,
          quantity: value.quantity,
          title: value.title));
    });
    print("LIST OF CART BECOMES = ");
    _itemList.forEach((ci) => print(
        "${ci.id} , has quantity ${ci.quantity} , title ${ci.title} ,Total =  ${ci.totalPrice}"));
    notifyListeners();
  }

  // double getPriceFromString(String price) {
  //   var p = price.substring(3);
  //   return double.parse(p);
  // }

  void addItem(String itemId, num price, num quantity, String title,
      String imgPath, String parentCategory) {
    print(
        "REQUEST TO ADD ${title} with price ${price.toString()} and quantity ${quantity} , making total = ${(price * quantity).toString()}");
    if (_items!.containsKey(itemId)) {
      //change quantity..
      print("Found update quantity = ${quantity}");
      _items!.update(
          itemId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              totalPrice: existingCartItem.price * quantity,
              title: existingCartItem.title,
              imageUrl: existingCartItem.imageUrl,
              parentCategoryType: existingCartItem.parentCategoryType,
              price: existingCartItem.price,
              quantity: quantity));
    } else {
      _items!.putIfAbsent(
          itemId,
          () => CartItem(
              id: itemId + "-CART",
              totalPrice: price * quantity,
              price: price,
              title: title,
              quantity: 1,
              imageUrl: imgPath,
              parentCategoryType: parentCategory));
    }
    print("Formin list");
    formCartList();
    notifyListeners();

    print("ADDED ITEM");
  }

  Future<void> PlaceDistributorOrder(
      String area, String loggedInDistributor, String time) async {
    var todaysDate = DateTime.now();
    var year = todaysDate.year.toString();
    var month = todaysDate.month.toString();
    var day = todaysDate.day.toString();
    var date = day + month + year;
    var url =
        "https://kidysadminapp-default-rtdb.firebaseio.com/activeDistributorOrders/${area}/${loggedInDistributor}.json";
    try {
      await http.post(Uri.parse(url),
          body: json.encode({
            "area": area,
            "orderedBy": loggedInDistributor,
            "orderTime": time,
            "orderDate": date,
            "dispatchDate": dispatchDateSelected,
            "items": formOrderItemList(),
            "totalPrice": getTotalOrderPrice(),
          }));
    } catch (error) {
      print("ERROR IS");
      print(error);
      throw error;
    }
  }

  // Future<void> deleteCartOnDB(String retailer, String shop) async {
  //   var url =
  //       "https://muskan-admin-app-default-rtdb.firebaseio.com/cart/${shop}/${retailer}.json";
  //   try {
  //     await http.delete(Uri.parse(url));
  //   } catch (error) {
  //     print("ERROR IS");
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> saveCart(String retailer, String shop) async {
  //   var url =
  //       "https://muskan-admin-app-default-rtdb.firebaseio.com/cart/${shop}/${retailer}.json";
  //   try {
  //     await http.put(Uri.parse(url),
  //         body: json.encode({"items": formSaveCartList()}));
  //   } catch (error) {
  //     print("ERROR IS");
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> fetchCartFromDB(String retailer, String shop) async {
  //   var url =
  //       "https://muskan-admin-app-default-rtdb.firebaseio.com/cart/${shop}/${retailer}/items.json";
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response == null) {
  //       return;
  //     }
  //     // final List<CartItem> loadedItems = [];
  //     final extractedData = json.decode(response.body) as List<dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     extractedData.forEach((cartItem) {
  //       // loadedItems.add(CartItem(
  //       //     id: cartItem['id'],
  //       //     imageUrl: cartItem['imageUrl'],
  //       //     parentCategoryType: cartItem['parentCategoryType'],
  //       //     parentSubcategoryType: cartItem['parentSubcategoryType'],
  //       //     price: cartItem['price'],
  //       //     quantity: cartItem['quantity'],
  //       //     title: cartItem['title'],
  //       //     totalPrice: cartItem['totalPrice']));
  //       addItem(
  //         cartItem['id'],
  //         cartItem['price'],
  //         cartItem['quantity'],
  //         cartItem['title'],
  //         cartItem['imageUrl'],
  //         cartItem['parentCategoryType'],
  //       );
  //     });
  //   } catch (error) {
  //     print("ERROR IS");
  //     print(error);
  //     throw error;
  //   }
  // }

  // formSaveCartList() {
  //   var items = [];
  //   itemList.forEach((cartItem) {
  //     items.add(cartItem.toJson());
  //   });
  //   return items;
  // }

  formOrderItemList() {
    var items = [];
    _itemList.forEach((cartItem) {
      items.add(DistributorOrderItem(
              item: cartItem.title,
              imageUrl: cartItem.imageUrl,
              CategoryName: cartItem.parentCategoryType,
              quantity: cartItem.quantity,
              price: cartItem.totalPrice)
          .toJson());
    });
    return items;
  }
}
