class ItemModel {
  final int itemId;
  final String imageUrl;
  final String title;
  bool isFavorite;
  bool isBookmarked;
  final int labelId;
  final int categoryId;

  ItemModel(
      {required this.itemId,
      required this.imageUrl,
      required this.title,
      required this.isFavorite,
      required this.isBookmarked,
      required this.labelId,
      required this.categoryId});

  ItemModel.fromJson(Map<String, dynamic> json)
      : imageUrl = json['image'],
        title = json['title'],
        isFavorite = json['isFavorite'],
        isBookmarked = json['isBookmarked'],
        labelId = json['labelId'],
        categoryId = json['catId'],
        itemId = json['id'];

  Map<String, dynamic> toJson() => {
        'image': imageUrl,
        'id': itemId,
        'title': title,
        'isFavorite': isFavorite,
        'isBookmarked': isBookmarked,
        'labelId': labelId,
        'catId': categoryId,
      };
  set bookmarked(bool isBookmarked) {
    this.isBookmarked = isBookmarked;
  }

  set isfavorite(bool isFavorite) {
    this.isFavorite = isFavorite;
  }
}
