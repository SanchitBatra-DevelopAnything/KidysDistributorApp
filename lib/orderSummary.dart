import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 70.0,
              color: Colors.white,
              padding: EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 28,
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
                                    "Order Summary",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "10 items in this order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffdd0e1c)),
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text('Item 1'),
                              subtitle: Text('Description of Item 1'),
                              trailing: Text('\$10.00'),
                            ),
                            ListTile(
                              title: Text('Item 2'),
                              subtitle: Text('Description of Item 2'),
                              trailing: Text('\$15.00'),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                      color: Color.fromARGB(255, 4, 102, 7))),
                              trailing: Text(
                                '\-Rs.2,00',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 102, 7)),
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
                    ),
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
                              subtitle: Text('k123-988uiytrrettss'),
                            ),
                            ListTile(
                              title: Text('Order placed'),
                              subtitle: Text('4/3/2023 5:19PM'),
                            ),
                            ListTile(
                              title: Text('Requested dispatch date'),
                              subtitle: Text('4/4/2023'),
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
