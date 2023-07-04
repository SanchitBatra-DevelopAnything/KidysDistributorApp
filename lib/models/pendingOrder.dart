class PendingOrder {
  String? status;
  String? area;
  String? id;
  String? dispatchDate;
  List<dynamic>? items;
  String? orderDate;
  String? orderTime;
  String? orderedBy;
  num? totalPrice;

  PendingOrder(
      {required this.area,
      required this.dispatchDate,
      required this.id,
      required this.items,
      required this.status,
      required this.orderDate,
      required this.orderTime,
      required this.orderedBy,
      required this.totalPrice});
}
