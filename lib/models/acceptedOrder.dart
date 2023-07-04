class AcceptedOrder {
  String? status;
  String? area;
  String? id;
  String? orderDate;
  String? orderKey;
  String? orderTime;
  String? orderedBy;
  num? totalDispatchPrice;
  String? dispatchDate;
  num? totalPrice;
  List<dynamic>? items;

  AcceptedOrder(
      {required this.status,
      required this.id,
      required this.area,
      required this.orderDate,
      required this.orderTime,
      required this.totalDispatchPrice,
      required this.totalPrice,
      required this.orderedBy,
      required this.dispatchDate,
      required this.orderKey,
      required this.items});
}
