class PendingOrder {
  String status = "Pending";
  String area;
  String orderId;
  String dispatchDate;
  List<dynamic> items;
  String orderDate;
  String orderTime;
  String orderedBy;
  num totalPrice;

  PendingOrder(
      {required this.area,
      required this.dispatchDate,
      required this.orderId,
      required this.items,
      required this.status,
      required this.orderDate,
      required this.orderTime,
      required this.orderedBy,
      required this.totalPrice});
}
