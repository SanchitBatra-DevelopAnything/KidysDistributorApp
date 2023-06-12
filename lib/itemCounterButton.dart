import 'package:flutter/material.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:provider/provider.dart';

typedef void CountButtonClickCallBack(dynamic count);

class CountButtonView extends StatefulWidget {
  final String itemId;
  final CountButtonClickCallBack onChange;
  final String parentCategory;

  const CountButtonView({
    Key? key,
    required this.itemId,
    required this.onChange,
    required this.parentCategory,
  }) : super(key: key);

  @override
  _CountButtonViewState createState() => _CountButtonViewState();
}

class _CountButtonViewState extends State<CountButtonView> {
  dynamic quantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateCount(dynamic addValue) {
    if (quantity + addValue <= 0) {
      setState(() {
        quantity = 0;
      });
    }
    if (quantity + addValue > 0) {
      setState(() {
        quantity += addValue;
      });
    }

    if (widget.onChange != null) {
      widget.onChange(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    var count = Provider.of<CartProvider>(context, listen: false)
        .getQuantity(widget.itemId);
    // var selectedSubcategory = widget.parentSubcategory.toUpperCase();
    setState(() {
      quantity = count;
    });
    print("RECEIVED COUNT IN BASKET = " + count.toString());
    return SizedBox(
      width: double.infinity - 100,
      height: 50.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  onLongPress: () {
                    updateCount(-50);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.0)),
                      width: quantity < 100 ? 40 : 32,
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 102, 7),
                            decoration: TextDecoration.none),
                      )))),
              Container(
                child: Center(
                    child: Text(
                  '$quantity',
                  style: TextStyle(
                      fontSize: quantity < 100 ? 18.0 : 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 102, 7),
                      decoration: TextDecoration.none),
                )),
              ),
              GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  onLongPress: () {
                    updateCount(50);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.white),
                      width: quantity < 100 ? 40 : 32,
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: quantity < 100 ? 18.0 : 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 102, 7),
                            decoration: TextDecoration.none),
                      )))),
            ],
          ),
        ),
      ),
    );
  }
}
