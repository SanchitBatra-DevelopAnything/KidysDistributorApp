class Item {
  String id;
  dynamic delhi_ncr_price;
  String imgUrl;
  String itemName;
  dynamic modern_trade_price;
  dynamic out_station_price;
  dynamic super_stockist_price;
  dynamic western_price;
  dynamic details;
  dynamic itemPrice;
  dynamic slab_1_start;
  dynamic slab_1_end;
  dynamic slab_2_start;
  dynamic slab_2_end;
  dynamic slab_3_start;
  dynamic slab_3_end;
  dynamic slab_1_discount;
  dynamic slab_2_discount;
  dynamic slab_3_discount;

  Item({
    required this.id,
    required this.imgUrl,
    required this.itemName,
    this.delhi_ncr_price = 10,
    this.modern_trade_price = 10,
    this.out_station_price = 10,
    this.super_stockist_price = 10,
    this.details = "",
    this.western_price = 10,
    required this.itemPrice,
    this.slab_1_start,
    this.slab_1_end,
    this.slab_2_start,
    this.slab_2_end,
    this.slab_3_start,
    this.slab_3_end,
    this.slab_1_discount,
    this.slab_2_discount,
    this.slab_3_discount,
  });
}
