class Distributor {
  String id;
  String distributorName;
  String GSTNumber;
  String area;
  String attached_price_list;

  Distributor(
      {required this.distributorName,
      required this.id,
      required this.GSTNumber,
      required this.attached_price_list,
      required this.area});
}
