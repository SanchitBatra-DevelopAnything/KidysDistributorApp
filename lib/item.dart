import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'itemCounterButton.dart';

class Item extends StatefulWidget {
  const Item(
      {Key? key,
      required this.imgPath,
      required this.price,
      required this.itemName,
      required this.itemId})
      : super(key: key);

  final String imgPath;
  final dynamic price;
  final String itemName;
  final String itemId;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  var _isInCart = false;
  var _quantity = 0;

  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    _isInCart = cartProviderObject.checkInCart(widget.itemId);
    _isInCart
        ? _quantity = cartProviderObject.getQuantity(widget.itemId)
        : _quantity = 0;
    var parentCategory =
        Provider.of<CategoriesProvider>(context).activeCategoryName;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3.0,
            blurRadius: 5.0,
          )
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/item-detail', arguments: {
                  'imgPath': widget.imgPath,
                });
              },
              child: Container(
                width: double.infinity,
                child: Hero(
                  tag: widget.imgPath,
                  child: Image.network(
                    widget.imgPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 5,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Rs. " + widget.price,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.itemName.toLowerCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 3,
            child: Center(
              child: !_isInCart
                  ? Container(
                      height: 50,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity - 100,
                          decoration: BoxDecoration(
                            color: Color(0xFFdd0e1c),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "+ Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // Add to cart functionality
                          cartProviderObject.addItem(
                              widget.itemId,
                              widget.price,
                              1,
                              widget.itemName,
                              widget.imgPath,
                              parentCategory);
                          setState(() {
                            _isInCart = true;
                          });
                        },
                      ),
                    )
                  : CountButtonView(
                      itemId: widget.itemId,
                      parentCategory: parentCategory,
                      onChange: (count) => {
                        if (count == 0)
                          {
                            cartProviderObject.removeItem(widget.itemId),
                            setState(() => {_isInCart = false})
                          }
                        else if (count > 0)
                          {
                            cartProviderObject.addItem(
                              widget.itemId,
                              widget.price,
                              count,
                              widget.itemName.toLowerCase(),
                              widget.imgPath,
                              parentCategory,
                            )
                          }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
