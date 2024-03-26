import 'dart:convert';

import 'package:cleanservice/customer/main2.dart';
import 'package:cleanservice/models/transaction.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:cleanservice/widgets/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../models/appointment.dart';
import '../../models/pref_profile_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../homectv.dart';
import '../mainctv.dart';
import 'ctdv2.dart';

class ThongTin extends StatefulWidget {
  final Appointment appointment;
  final String userID;
  ThongTin({
    required this.appointment,
    required this.userID,
  });

  @override
  State<ThongTin> createState() => _ThongTinState();
}

class _ThongTinState extends State<ThongTin> {
  late String paymentMethod = "";
  late String statusPay = "";
  late TransactionStatus transactionStatus;
  List<TransactionStatus> transactionStatusList = [];

  void _viewMap(String address) async {
    final String url = "https://maps.google.com/?q=${Uri.encodeFull(address)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở bản đồ: $url';
    }
  }

  Future<void> _showStatusDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đang xử lý'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vui lòng đợi...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int? userid;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
    });
  }

  Future<void> _updateStatus() async {
    await _showStatusDialog(); // Hiển thị hộp thoại

    final idAppointment = widget.appointment.idAppointment;

    while (widget.appointment.status != '3') {
      final response = await http.post(
        Uri.parse(BASEURL.getstatus),
        body: {
          'id_appointment': idAppointment,
          'id_ctv': userid.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        if (responseJson['value'] == 1) {
          final newStatus = responseJson['new_status'];
          setState(() {
            widget.appointment.status = newStatus.toString();
          });
        } else {
          // Xử lý lỗi khi cập nhật trạng thái không thành công
        }
      } else {
        // Xử lý lỗi khi không kết nối được với API
      }

      await Future.delayed(
          Duration(seconds: 5)); // Chờ 5 giây trước khi kiểm tra lại
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPageAd(),
      ),
    );
  }

  Future<void> fetchAllTransactionData() async {
    try {
      Uri urlTransaction = Uri.parse(BASEURL.transaction);

      final response = await http.get(urlTransaction);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          transactionStatusList = List<TransactionStatus>.from(data.map((item) {
            return TransactionStatus.fromJson(item);
          }));
          setState(() {});
        } else {
          print('No transaction data found');
        }
      } else {
        print(
            'Failed to fetch transaction data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching transaction data: $error');
    }
  }

  String getStatusPay(String? statuspay) {
    return (statuspay == '1') ? "Đã thanh toán" : "Chưa thanh toán";
  }

  TransactionStatus getTransactionStatusForAppointment(
      Appointment appointment) {
    return transactionStatusList.firstWhere(
      (transaction) => transaction.idAppointment == appointment.idAppointment,
      orElse: () => TransactionStatus(),
    );
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllTransactionData();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    transactionStatus = getTransactionStatusForAppointment(widget.appointment);

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết dịch vụ"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dịch vụ: ${widget.appointment.serviceName}',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                'Kích thước phòng: ${widget.appointment.roomSize}',
                style: TextStyle(fontSize: 17.0),
              ),
              SizedBox(height: 12.0),
              Text(
                'Giờ làm: ${widget.appointment.datetime}',
                style: TextStyle(fontSize: 17.0),
              ),
              SizedBox(height: 12.0),
              Text(
                'Phương thức thanh toán: ${transactionStatus.paymentMethod}',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                'Tình trạng thanh toán: ${getStatusPay(transactionStatus.statusPay)}',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Thông tin',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildUserRow(),
                    SizedBox(height: 12.0),
                    Text(
                      'Địa chỉ: ${widget.appointment.userAddress}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'SDT: ${widget.appointment.userPhone}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Mô tả: ${widget.appointment.description}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Mức độ bẩn: ${widget.appointment.dirtLevel}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Center(
                child: Text(
                  'Tổng tiền: ${widget.appointment.price}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.green[800],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateStatus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPageAd(),
                      ),
                    );
                  },
                  child: Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tên khách hàng: ${widget.appointment.userName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          TextButton(
            onPressed: () {
              _viewMap(widget.appointment.userAddress.toString());
            },
            child: Text(
              'Xem bản đồ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
