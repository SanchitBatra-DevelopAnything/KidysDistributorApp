import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidys_distributor/cartItemView.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    final cartItemsList = cartProviderObject.itemList;
    // var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 235, 229, 229),
        body: Column(
          children: [
            Container(
              height: 75,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Checkout",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                    CupertinoButton(
                      child: Text(
                        "Place Order",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                      color: Color(0xffdd0e1c),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Discounts will be applied on actual dispatched quantities , if applicable.",
                    style: TextStyle(
                        color: Color(0xffdd0e1c), fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                    color: Color.fromARGB(255, 241, 157, 163)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromARGB(255, 235, 229, 229)),
                              child: const Icon(
                                Icons.alarm,
                                size: 35,
                                color: Colors.black,
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Dispatch Details",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Click here",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Total : Rs.${totalOrderPrice}",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 235, 229, 229)),
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        CartItemView(cartItem: cartItemsList[index]),
                    itemExtent: 100,
                    itemCount: cartItemsList.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
