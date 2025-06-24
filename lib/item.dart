// ignore_for_file: unnecessary_set_literal

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/itemDetail.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:kidys_distributor/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'itemCounterButton.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.imgPath,
    required this.price,
    required this.itemName,
    required this.itemDetails,
    required this.slab_1_start,
    required this.slab_1_end,
    required this.slab_2_start,
    required this.slab_2_end,
    required this.slab_3_start,
    required this.slab_3_end,
    required this.slab_1_discount,
    required this.slab_2_discount,
    required this.slab_3_discount,
    required this.itemId,
  }) : super(key: key);

  final String imgPath;
  final dynamic price;
  final String itemName;
  final String itemId;
  final String itemDetails;
  final dynamic slab_1_start;
  final dynamic slab_2_start;
  final dynamic slab_3_start;
  final dynamic slab_1_end;
  final dynamic slab_2_end;
  final dynamic slab_3_end;
  final dynamic slab_1_discount;
  final dynamic slab_2_discount;
  final dynamic slab_3_discount;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  var _isInCart = false;
  var _quantity = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tableData = [
      {
        'qty': [widget.slab_1_start, widget.slab_1_end].join(" - "),
        'price': calculatePrice(widget.slab_1_discount, widget.price),
        'discount': '${widget.slab_1_discount}%',
      },
      {
        'qty': [widget.slab_2_start, widget.slab_2_end].join(" - "),
        'price': calculatePrice(widget.slab_2_discount, widget.price),
        'discount': '${widget.slab_2_discount}%',
      },
      {
        'qty': [widget.slab_3_start, widget.slab_3_end].join(" - "),
        'price': calculatePrice(widget.slab_3_discount, widget.price),
        'discount': '${widget.slab_3_discount}%',
      },
    ];

    final cartProviderObject = Provider.of<CartProvider>(context);
    var loggedInDistributor =
        Provider.of<AuthProvider>(context).loggedInDistributor;

    _isInCart = cartProviderObject.checkInCart(widget.itemId);
    _quantity = _isInCart
        ? cartProviderObject.getQuantity(widget.itemId)
        : 0;

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
                      itemDetails: widget.itemDetails,
                    ),
                  ),
                );
              },
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: Hero(
                    tag: widget.imgPath,
                    child: CachedNetworkImage(
                      imageUrl: widget.imgPath,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const SpinKitPulse(color: Color(0xffdd0e1c)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "Min Qty : 1 | Max Qty : 999",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              widget.itemName.toLowerCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.black45),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                _buildTableRow('Qty', 'Price/Unit', 'Margin', isHeader: true),
                for (var data in tableData)
                  _buildTableRow(
                    data['qty']!,
                    data['price']!,
                    data['discount']!,
                    highlight: _isInRange(_quantity, data['qty']!),
                  ),
              ],
            ),
          ),
          const Divider(),
          loggedInDistributor != 'null'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "MRP Rs. ${widget.price}",
                          style: const TextStyle(
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
                            ? SizedBox(
                                height: 50,
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity - 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "+ Add",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 4, 102, 7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    cartProviderObject.addItem(
                                      widget.itemId,
                                      widget.price,
                                      1,
                                      widget.itemName,
                                      widget.imgPath,
                                      parentCategory,
                                      widget.slab_1_start,
                                      widget.slab_1_end,
                                      widget.slab_1_discount,
                                      widget.slab_2_start,
                                      widget.slab_2_end,
                                      widget.slab_2_discount,
                                      widget.slab_3_start,
                                      widget.slab_3_end,
                                      widget.slab_3_discount,
                                    );
                                    setState(() {
                                      _isInCart = true;
                                    });
                                  },
                                ),
                              )
                            : CountButtonView(
                                itemId: widget.itemId,
                                parentCategory: parentCategory,
                                onChange: (count) {
                                  if (count == 0) {
                                    cartProviderObject
                                        .removeItem(widget.itemId);
                                    setState(() => _isInCart = false);
                                  } else {
                                    cartProviderObject.addItem(
                                      widget.itemId,
                                      widget.price,
                                      count,
                                      widget.itemName.toLowerCase(),
                                      widget.imgPath,
                                      parentCategory,
                                      widget.slab_1_start,
                                      widget.slab_1_end,
                                      widget.slab_1_discount,
                                      widget.slab_2_start,
                                      widget.slab_2_end,
                                      widget.slab_2_discount,
                                      widget.slab_3_start,
                                      widget.slab_3_end,
                                      widget.slab_3_discount,
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, String col3,
      {bool isHeader = false, bool highlight = false}) {
    return TableRow(
      decoration: highlight ? BoxDecoration(color: Colors.greenAccent) : null,
      children: [
        _buildTableCell(col1, isHeader),
        _buildTableCell(col2, isHeader),
        _buildTableCell(col3, isHeader),
      ],
    );
  }

  Widget _buildTableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 12,
          color: isHeader ? Colors.black : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  bool _isInRange(int quantity, String range) {
    List<String> parts = range.split('-');
    if (parts.length == 2) {
      double start = double.tryParse(parts[0]) ?? 0;
      double end = double.tryParse(parts[1]) ?? 0;
      return quantity >= start && quantity <= end;
    }
    return false;
  }

  String calculatePrice(dynamic discount, dynamic price) {
    if (discount == 0) return price.toString();
    var factor = (discount / 100);
    var discountCalculated = price - (factor * price);
    return discountCalculated.toStringAsFixed(2);
  }
}
