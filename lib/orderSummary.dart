import 'package:flutter/material.dart';
import 'package:kidys_distributor/providers/orders.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedOrder = Provider.of<OrderProvider>(context, listen: false)
        .selectedOrderForDetail;
    print(selectedOrder.items[0]);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 65.0,
              color: Colors.white,
              padding: EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Card(
                        elevation: 0.0,
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedOrder.status == "Accepted"
                                        ? "Order Summary"
                                        : "Order Details",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${selectedOrder.items.length} items in this order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffdd0e1c)),
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedOrder.items.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                      // dense: true,
                                      title: Text(
                                        selectedOrder.status == "Accepted"
                                            ? "${selectedOrder.items[index]['item']} x ${selectedOrder.items[index]['dispatchedQuantity']}"
                                            : "${selectedOrder.items[index]['item']} x ${selectedOrder.items[index]['quantity']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: selectedOrder.status ==
                                              "Accepted"
                                          ? Text(
                                              'You ordered: ${selectedOrder.items[index]['orderedQuantity']}')
                                          : Text(""),
                                      trailing: selectedOrder.status ==
                                              "Accepted"
                                          ? selectedOrder.items[index]
                                                      ['orderedQuantity'] !=
                                                  selectedOrder.items[index]
                                                      ['dispatchedQuantity']
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Rs.${selectedOrder.items[index]['dispatchedPrice']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Rs.${selectedOrder.items[index]['orderedPrice']}',
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  "Rs.${selectedOrder.items[index]['dispatchedPrice']}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                          : Text(
                                              "Rs.${selectedOrder.items[index]['price']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    selectedOrder.status == "Accepted"
                        ? Container(
                            color: Colors.white,
                            child: Card(
                              elevation: 0.0,
                              margin: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Bill Details',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Order Total'),
                                    trailing: Text('\Rs.250.00'),
                                  ),
                                  ListTile(
                                    title: Text('Dispatched Total'),
                                    trailing: Text('\Rs.220,00'),
                                  ),
                                  ListTile(
                                    title: Text('Discount',
                                        style: TextStyle(
                                            color: Color(0xff008800))),
                                    trailing: Text(
                                      '\-Rs.2,00',
                                      style:
                                          TextStyle(color: Color(0xff008800)),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Sub Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      '\Rs.228.50',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 8.0),
                    Container(
                      color: Colors.white,
                      child: Card(
                        elevation: 0.0,
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Order Details',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text('Order id'),
                              subtitle: Text('${selectedOrder.id}'),
                            ),
                            ListTile(
                              title: Text('Order placed'),
                              subtitle: Text('${selectedOrder.orderTime}'),
                            ),
                            ListTile(
                              title: Text('Requested dispatch date'),
                              subtitle: Text('${selectedOrder.dispatchDate}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
