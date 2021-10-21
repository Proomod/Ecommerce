class CategoriesModel {
  const CategoriesModel(
      {required this.categoryId,
      required this.name,
      required this.totalBookmarked});

  Map<String, dynamic> toJson() =>
      {'id': categoryId, 'category': name, 'total_bookmarked': totalBookmarked};

  CategoriesModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['id'],
        name = json['category'],
        totalBookmarked = json['total_bookmarked'];

  final int categoryId;
  final String name;
  final int totalBookmarked;
}
