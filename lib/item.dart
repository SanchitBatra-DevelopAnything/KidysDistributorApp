import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    //final cartProviderObject = Provider.of<CartProvider>(context);
    _isInCart = false;
    _isInCart ? _quantity = 1 : _quantity = 0;
    var parentCategory =
        Provider.of<CategoriesProvider>(context).activeCategoryName;
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 5, bottom: 5, right: 5),
        child: GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0,
                    )
                  ],
                  color: Color.fromRGBO(51, 51, 51, 0.8),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/item-detail', arguments: {
                            'imgPath': widget.imgPath,
                          });
                        },
                        child: Hero(
                          tag: widget.imgPath,
                          child: Image.network(
                            widget.imgPath,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.red, strokeWidth: 5),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        "Rs. " + widget.price,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.itemName.toLowerCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Flexible(child: Divider(), flex: 1),
                    Flexible(
                      flex: 2,
                      child: Center(
                          child: !_isInCart
                              ? CupertinoButton(
                                  child: Text("Add to cart",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                  color: Colors.red,
                                  onPressed: () {
                                    // cartProviderObject.addItem(
                                    //   widget.itemId,
                                    //   widget.price,
                                    //   1,
                                    //   widget.itemName.toString(),
                                    //   widget.imgPath,
                                    //   parentCategory,
                                    // );
                                    // setState(() {
                                    //   _isInCart = true;
                                    // });
                                  },
                                )
                              : CountButtonView(
                                  itemId: widget.itemId,
                                  parentCategory: parentCategory,
                                  onChange: (value) => {},
                                  // onChange: (count) => {
                                  //       if (count == 0)
                                  //         {
                                  //           cartProviderObject
                                  //               .removeItem(widget.itemId),
                                  //           setState(() => {_isInCart = false})
                                  //         }
                                  //       else if (count > 0)
                                  //         {
                                  //           cartProviderObject.addItem(
                                  //             widget.itemId,
                                  //             widget.price,
                                  //             count,
                                  //             widget.itemName,
                                  //             widget.imgPath,
                                  //             parentCategory,
                                  //           )
                                  //         }
                                  //     }
                                )),
                    )
                  ],
                ))));
  }
}
