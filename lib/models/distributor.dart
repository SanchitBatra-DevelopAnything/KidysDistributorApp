class Distributor {
  String id;
  String distributorName;
  String GSTNumber;
  String contact;
  String area;
  String shop;
  String shopAddress;
  String attached_price_list;

  Distributor(
      {required this.distributorName,
      required this.contact,
      required this.shop,
      required this.id,
      required this.GSTNumber,
      required this.shopAddress,
      required this.attached_price_list,
      required this.area});
}
