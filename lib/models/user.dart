class User {
  User({required this.userId, required this.fullName});
  final String userId;
  final String fullName;

  User.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        fullName = json['fullName'];

  Map<String, dynamic> toJson() => {
        'id': userId,
        'fullName': fullName,
      };
}
