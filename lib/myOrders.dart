import 'package:flutter/material.dart';
import 'package:kidys_distributor/myOrderCard.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  var isFirstTime = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isFirstTime) {
      var loggedInDistributor =
          Provider.of<AuthProvider>(context, listen: false).loggedInDistributor;
      var loggedInArea =
          Provider.of<AuthProvider>(context, listen: false).loggedInArea;

      setState(() {
        isLoading = true;
      });
    }
    isFirstTime = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              Container(
                  height: 75,
                  color: Color(0xFF552018),
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
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "My Orders",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ])
                          ]))),
              SizedBox(
                height: 12,
              ),
              OrderCard(
                status: "Accepted",
                dispatchOn: "7/6/23",
              ),
              OrderCard(
                status: "Pending",
                dispatchOn: "8/9/23",
              )
            ])));
  }
}
