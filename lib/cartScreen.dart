import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kidys_distributor/PlatformDialog.dart';
import 'package:kidys_distributor/cartItemView.dart';
import 'package:kidys_distributor/models/distributor.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  bool isPlacingOrder = false;
  bool _isSavingCart = false;

  openDatePicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: const Color(0XFFDD0E1C),
              colorScheme: const ColorScheme.light(
                primary: Color(0xffdd0e1c),
              )),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (selectedDate != null) {
      onDateSelected(selectedDate, context);
    }
  }

  onDateSelected(DateTime date, BuildContext context) {
    var day = date.toString().split(" ")[0].split("-")[2];
    var month = date.toString().split(" ")[0].split("-")[1];
    var year = date.toString().split(" ")[0].split("-")[0];

    print("${day}-${month}-${year}");
    Provider.of<CartProvider>(context, listen: false)
        .setDispatchDate("${day}-${month}-${year}");
  }

  placeOrder(BuildContext context) async {
    
      setState(() {
        isPlacingOrder = true;
      });
      final cartObject = Provider.of<CartProvider>(context, listen: false);
      final distributor =
          Provider.of<AuthProvider>(context, listen: false).loggedInDistributor;
      final area =
          Provider.of<AuthProvider>(context, listen: false).loggedInArea;
      final timeArrayComponent =
          DateFormat.yMEd().add_jms().format(DateTime.now()).split(" ");
      final time = timeArrayComponent[timeArrayComponent.length - 2] +
          " " +
          timeArrayComponent[timeArrayComponent.length - 1];
      String token =
          Provider.of<AuthProvider>(context, listen: false).deviceToken!;
      
      

      String shop = Provider.of<AuthProvider>(context, listen: false).loggedInShop;
      String GST = Provider.of<AuthProvider>(context, listen: false).loggedInGSTNumber;
      String contact = Provider.of<AuthProvider>(context, listen: false).loggedIncontact;

      await Provider.of<CartProvider>(context, listen: false)
          .PlaceDistributorOrder(area, distributor, time, "normalPriceList", token , shop , GST, contact);
      cartObject.clearCart();
      await cartObject.deleteCartOnDB(distributor, area);
      Navigator.pushNamedAndRemoveUntil(
          context, "/orderPlaced", (route) => false);
    }

  saveCart(
      AuthProvider authProviderObject, CartProvider cartProviderObject) async {
    await cartProviderObject.saveCart(authProviderObject.loggedInDistributor,
        authProviderObject.loggedInArea);
  }

  deleteCart(
      AuthProvider authProviderObject, CartProvider cartProviderObject) async {
    await cartProviderObject.deleteCartOnDB(
        authProviderObject.loggedInDistributor,
        authProviderObject.loggedInArea);
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    final authProviderObject = Provider.of<AuthProvider>(context);
    final cartItemsList = cartProviderObject.itemList;
    // var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    var remainingPrice = 3000-totalOrderPrice;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _isSavingCart = true;
        });
        await saveCart(authProviderObject, cartProviderObject);
        setState(() {
          _isSavingCart = false;
        });
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 235, 229, 229),
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
                          onTap: () async {
                            if (cartItemsList.length == 0) {
                              setState(() {
                                _isSavingCart = true;
                              });
                              await deleteCart(
                                  authProviderObject, cartProviderObject);
                              setState(() {
                                _isSavingCart = false;
                              });
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                _isSavingCart = true;
                              });
                              await saveCart(
                                  authProviderObject, cartProviderObject);
                              setState(() {
                                _isSavingCart = false;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                      !isPlacingOrder
                          ? CupertinoButton(
                              child: const Text(
                                "Place Order",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: totalOrderPrice>=3000 ? () {
                                placeOrder(context);
                              } : null,
                              color: totalOrderPrice>=3000 ? Colors.black : Colors.grey,
                            )
                          : SpinKitPulse(
                              color: Color(0xffDD0E1C),
                              size: 50.0,
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "All applicable margins on your cart are shown below.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                      color: const Color.fromARGB(255, 241, 157, 163)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Container(
                  child:  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      remainingPrice > 0 ? "Please shop for Rs.${remainingPrice.toStringAsFixed(2)} more to place your order" : "YAY! you can now place your order!",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                      color: const Color.fromARGB(255, 241, 157, 163)),
                ),
              ) ,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    openDatePicker(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total : Rs.${totalOrderPrice}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize : 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _isSavingCart
                  ? SpinKitPulse(
                      color: Color(0xffDD0E1C),
                      size: 50.0,
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 235, 229, 229)),
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
      ),
    );
  }
}
