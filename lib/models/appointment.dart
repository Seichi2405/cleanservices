// class Appointment {
//   final int id;
//   final int userId;
//   final int serviceId;
//   final DateTime datetime;
//   final String repeatTime;
//   final double price;
//   final String description;
//   final String roomSize;
//   final String dirtLevel;
//   final String serviceName;
//   final String status;

//   Appointment({
//     required this.id,
//     required this.userId,
//     required this.serviceId,
//     required this.datetime,
//     required this.repeatTime,
//     required this.price,
//     required this.description,
//     required this.roomSize,
//     required this.dirtLevel,
//     required this.serviceName,
//     required this.status,
//   });

//   factory Appointment.fromJson(Map<String, dynamic> data) {
//     return Appointment(
//       id: int.parse(data['id_appointment'] ?? "0"),
//       userId: int.parse(data['id_user'] ?? "0"),
//       serviceId: int.parse(data['id_service'] ?? "0"),
//       serviceName: data['name'] ?? "",
//       datetime: DateTime.parse(data['datetime'] ?? ""),
//       repeatTime: data['repeatTime'] ?? "0",
//       price: double.parse(data['price'] ?? 0.0),
//       description: data['description'] ?? "",
//       roomSize: data['roomSize'] ?? "",
//       dirtLevel: data['dirtLevel'] ?? "",
//       status: data['status'] ?? "",
//     );
//   }
// }
class Appointment {
  String? idAppointment;
  String? userId;
  String? serviceId;
  String? repeatTime;
  String? price;
  String? description;
  String? roomSize;
  String? dirtLevel;
  String? datetime;
  String? status;
  String? serviceName;
  String? userName;
  String? userPhone;
  String? userAddress;
  String? idctv;
  // String? paymentMethod;
  // String? statuspay;
  Appointment({
    this.idAppointment,
    this.userId,
    this.serviceId,
    this.repeatTime,
    this.price,
    this.description,
    this.roomSize,
    this.dirtLevel,
    this.datetime,
    this.status,
    this.serviceName,
    this.userName,
    this.userPhone,
    this.userAddress,
    this.idctv,
    // this.paymentMethod,
    // this.statuspay
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    idAppointment = json['id_appointment'];
    userId = json['id_user'];
    serviceId = json['id_service'];
    repeatTime = json['repeatTime'];
    price = json['price'];
    description = json['description'];
    roomSize = json['roomSize'];
    dirtLevel = json['dirtLevel'];
    datetime = json['datetime'];
    status = json['status'];
    serviceName = json['service_name'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userAddress = json['user_address'];
    idctv = json['id_ctv'];
    // paymentMethod = json['payment_method'];
    // statuspay = json['status_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_appointment'] = this.idAppointment;
    data['id_user'] = this.userId;
    data['id_service'] = this.serviceId;
    data['repeatTime'] = this.repeatTime;
    data['price'] = this.price;
    data['description'] = this.description;
    data['roomSize'] = this.roomSize;
    data['dirtLevel'] = this.dirtLevel;
    data['datetime'] = this.datetime;
    data['status'] = this.status;
    data['service_name'] = this.serviceName;
    data['user_name'] = this.userName;
    data['user_phone'] = this.userPhone;
    data['user_address'] = this.userAddress;
    data['id_ctv'] = this.idctv;
    // data['payment_method'] = this.paymentMethod;
    // data['status_pay'] = this.statuspay;
    return data;
  }
}
