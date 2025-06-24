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
  Map<String, dynamic> areaSlabs; // ✅ New field

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
    required this.areaSlabs,
  });

  factory Item.fromJson(String id, Map<String, dynamic> json) {
    return Item(
      id: id,
      imgUrl: json['imgUrl'] ?? '',
      itemName: json['itemName'] ?? '',
      itemPrice: json['itemPrice'],
      delhi_ncr_price: json['delhi_ncr_price'],
      modern_trade_price: json['modern_trade_price'],
      out_station_price: json['out_station_price'],
      super_stockist_price: json['super_stockist_price'],
      western_price: json['western_price'],
      details: json['details'] ?? '',
      slab_1_start: json['slab_1_start'],
      slab_1_end: json['slab_1_end'],
      slab_2_start: json['slab_2_start'],
      slab_2_end: json['slab_2_end'],
      slab_3_start: json['slab_3_start'],
      slab_3_end: json['slab_3_end'],
      slab_1_discount: json['slab_1_discount'],
      slab_2_discount: json['slab_2_discount'],
      slab_3_discount: json['slab_3_discount'],
      areaSlabs: Map<String, dynamic>.from(json['areaSlabs'] ?? {}),
    );
  }

  /// ✅ Returns slab data for user's area if available, else default
  Map<String, dynamic> getEffectiveSlab(String areaName) {
    final key = areaName.toLowerCase().trim();
    if (areaSlabs.containsKey(key)) {
      return areaSlabs[key];
    } else {
      return {
        'slab_1_start': slab_1_start,
        'slab_1_end': slab_1_end,
        'slab_1_discount': slab_1_discount,
        'slab_2_start': slab_2_start,
        'slab_2_end': slab_2_end,
        'slab_2_discount': slab_2_discount,
        'slab_3_start': slab_3_start,
        'slab_3_end': slab_3_end,
        'slab_3_discount': slab_3_discount,
      };
    }
  }
}
