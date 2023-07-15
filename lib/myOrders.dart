import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/myOrderCard.dart';
import 'package:kidys_distributor/providers/auth.dart';
import 'package:kidys_distributor/providers/orders.dart';
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

      Provider.of<OrderProvider>(context, listen: false)
          .fetchAllOrdersList(loggedInDistributor, loggedInArea)
          .then((_) => {
                setState(() => {
                      isLoading = false,
                    })
              });
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = Provider.of<OrderProvider>(context).allOrders;
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
              Expanded(
                  child: isLoading
                      ? SpinKitPulse(
                          color: Color(0xffdd0e1c),
                        )
                      : ListView.builder(
                          itemCount: allOrders.length,
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () => {
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .setSelectedOrderForDetail(
                                          allOrders[index]),
                                  Navigator.of(context)
                                      .pushNamed('/orderSummary'),
                                },
                                child: OrderCard(
                                  status: allOrders[index].status,
                                  orderId: allOrders[index].id,
                                  placedOn: allOrders[index].orderTime,
                                  dispatchOn: allOrders[index].dispatchDate,
                                  order_total: allOrders[index].totalPrice,
                                  subTotal:
                                      allOrders[index].status == "Accepted"
                                          ? allOrders[index].subTotal
                                          : 0,
                                ),
                              ))))
            ])));
  }
}
