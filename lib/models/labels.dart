class Label {
  Label({
    required this.labelId,
    required this.catId,
    required this.name,
  });

  final int labelId;
  final int catId;
  final String name;

  Label.fromJson(Map<String, dynamic> json)
      : labelId = json["id"],
        catId = json["catId"],
        name = json["name"];
  Map<String, dynamic> toJson() => {
        'id': labelId,
        'catId': catId,
        'name': name,
      };

  static Label get empty {
    return Label(catId: 0, labelId: 0, name: '');
  }
}
