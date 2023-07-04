import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String? status;
  final String? placedOn;
  final String? dispatchOn;
  final String? orderId;
  final num? order_total;
  final num? dispatchedTotal;

  const OrderCard(
      {Key? key,
      String? this.status,
      String? this.placedOn,
      String? this.dispatchOn,
      String? this.orderId,
      num? this.order_total,
      num? this.dispatchedTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromARGB(255, 235, 229, 229)),
        height: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 4.0),
              child: Row(
                children: [
                  Text(
                    "Status ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 138, 137, 137),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    this.status!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  this.status == 'Accepted'
                      ? Icon(
                          Icons.task_alt_sharp,
                          color: Color.fromARGB(255, 46, 126, 50),
                          size: 25,
                        )
                      : Icon(
                          Icons.watch_later,
                          color: Color.fromARGB(255, 247, 114, 5),
                          size: 25,
                        ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  "Dispatch On : ${this.dispatchOn}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Placed On : ${this.placedOn}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                dense: true,
              ),
            ),
            Expanded(
              child: ListTile(
                title: this.status == "Accepted"
                    ? Text(
                        "Total : Rs.${this.order_total}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough),
                      )
                    : Text(
                        "Estimated Total : Rs.${this.order_total}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                subtitle: this.status == "Accepted"
                    ? Text(
                        "Dispatched Total : Rs.${this.dispatchedTotal}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    : Text(
                        "(This might change based on items we dispatch.)",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
