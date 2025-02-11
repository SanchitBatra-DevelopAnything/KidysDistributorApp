class Distributor {
  String id;
  String distributorName;
  String GSTNumber;
  String contact;
  String area;
  String shop;
  String attached_price_list;

  Distributor(
      {required this.distributorName,
      required this.contact,
      required this.shop,
      required this.id,
      required this.GSTNumber,
      required this.attached_price_list,
      required this.area});
}
