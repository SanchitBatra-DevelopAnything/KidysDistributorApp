class Brand {
  String id;
  String imageUrl;
  String brandName;
  int sortOrder;

  Brand(
      {required this.id, required this.imageUrl, required this.brandName , this.sortOrder=99999});
}
