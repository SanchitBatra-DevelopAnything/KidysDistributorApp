class Category {
  String id;
  String imageUrl;
  String categoryName;
  int sortOrder;

  Category(
      {required this.id, required this.imageUrl, required this.categoryName , this.sortOrder=99999});
}
