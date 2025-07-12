class BannerModel {
  final String imageUrl;

  BannerModel({required this.imageUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(imageUrl: json['imageUrl']);
  }
}
