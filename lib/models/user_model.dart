class User {
  final String name;
  final String address;
  final String sdt;
  final int userId;
  User({
    required this.name,
    required this.address,
    required this.sdt,
    required this.userId,
  });
  // factory User.fromJson(Map<String, dynamic> data) {
  //   return User(
  //     // userId: int.parse(data['id_user'] ?? "0"),
  //     name: data['name'] ?? "",
  //     address: data['address'] ?? "",
  //     sdt: data['phone'] ?? "",
  //   );
  // }
}
