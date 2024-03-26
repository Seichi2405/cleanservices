class ServiceModel {
  final String idservice;
  final String name;
  final String description;
  final String image;
  final String price;
  final String status;
  final String createdat;

  ServiceModel({
    required this.idservice,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.status,
    required this.createdat,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> data) {
    return ServiceModel(
      idservice: data['id_service'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '',
      status: data['status'] ?? '',
      createdat: data['created_at'] ?? '',
    );
  }
}
