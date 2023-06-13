import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/itemDetail.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'itemCounterButton.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(
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
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ItemDetail(
                              imgUrl: widget.imgPath,
                              itemName: widget.itemName,
                            )));
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rs. " + widget.price.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
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
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "+ Add",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 4, 102, 7),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Add to cart functionality
                              print("started add");
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
        ],
      ),
    );
  }
}
