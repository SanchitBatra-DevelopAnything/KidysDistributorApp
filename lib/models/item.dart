class Item {
  String id;
  dynamic delhi_ncr_price;
  String imgUrl;
  String itemName;
  dynamic modern_trade_price;
  dynamic out_station_price;
  dynamic super_stockist_price;
  dynamic western_price;

  Item(
      {required this.delhi_ncr_price,
      required this.id,
      required this.imgUrl,
      required this.itemName,
      required this.modern_trade_price,
      required this.out_station_price,
      required this.super_stockist_price,
      required this.western_price});
}
