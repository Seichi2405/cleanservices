import 'package:cleanservice/models/transaction.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/appointment.dart';
import '../models/pref_profile_model.dart';
import '../models/service_model.dart';

class HistoryPage extends StatefulWidget {
  final String name,
      priceService,
      nameService,
      idService,
      userID,
      idAppointment;
  final ServiceModel serviceModel;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TextEditingController repeatTimeController;
  final TextEditingController descriptionController;
  final TextEditingController roomSizeController;
  final TextEditingController dirtLevelController;
  HistoryPage({
    required this.name,
    this.priceService = '',
    this.nameService = '',
    required this.idService,
    required this.userID,
    required this.serviceModel,
    required this.selectedDate,
    required this.selectedTime,
    required this.repeatTimeController,
    required this.descriptionController,
    required this.roomSizeController,
    required this.dirtLevelController,
    required this.idAppointment,
  });
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Appointment> appointments = [];
  String? selectedServiceName;
  int? userid;

  List<TransactionStatus> transactionStatusList = [];

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
    });
    getHistory();
  }

  getHistory() async {
    appointments.clear();
    var urlHistory = Uri.parse(BASEURL.history + userid.toString());
    final response = await http.get(urlHistory);
    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        for (Map<String, dynamic> item in data) {
          appointments.add(Appointment.fromJson(item));
        }
      });
    }
    fetchAllTransactionData();
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

  String getStatusText(dynamic status) {
    if (status == 1 || status == "1") {
      return "Đang chờ";
    } else if (status == 2 || status == "2") {
      return "Đã nhận";
    } else if (status == 3 || status == "3") {
      return "Hoàn thành";
    } else {
      return "Không xác định";
    }
  }

  void _deleteAppointment(String idAppointment) async {
    final response = await http.post(
      Uri.parse(BASEURL.deleteapp),
      body: {
        'id_appointment': idAppointment,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['value'] == 1) {
        // Xóa thành công, cập nhật giao diện
        setState(() {
          appointments.removeWhere(
              (appointment) => appointment.idAppointment == idAppointment);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa lịch đặt thành công.'),
          ),
        );
      } else {
        // Xóa không thành công, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa lịch đặt: ${responseData['message']}'),
          ),
        );
      }
    } else {
      // Xóa không thành công, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi kết nối đến server.'),
        ),
      );
    }
  }

  String StatusPay(String? statuspay) {
    if (statuspay == '1') {
      return "Đã thanh toán";
    } else {
      return "Chưa thanh toán";
    }
  }

  void _confirmCompletion(String idAppointment) async {
    // Gửi request để cập nhật trạng thái lên server
    final response = await http.post(
      Uri.parse(BASEURL.confirmCompletion),
      body: {
        'id_appointment': idAppointment,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['value'] == 1) {
        // Cập nhật trạng thái trong danh sách appointments
        setState(() {
          var confirmedAppointment = appointments.firstWhere(
            (appointment) => appointment.idAppointment == idAppointment,
          );
          confirmedAppointment.status = '3'; // Trạng thái đã hoàn thành
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xác nhận hoàn thành lịch đặt.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Lỗi khi xác nhận hoàn thành: ${responseData['message']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi kết nối đến server.'),
        ),
      );
    }
  }

  fetchAppointments() async {
    var urllistApp = Uri.parse(BASEURL.get_appointments);
    final response = await http.get(urllistApp);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        for (var item in data) {
          final appointment = Appointment.fromJson(item);
          if (appointment.status == '3' &&
              (appointment.idctv ?? '').toString() ==
                  (userid ?? '').toString()) {
            setState(() {
              appointments.add(appointment);
            });
          }
        }
      }
    } else {
      throw Exception('Failed to fetch appointments from API');
    }
  }

  Future<void> _showCtvInfoDialog(String? idCtv) async {
    if (idCtv != null) {
      var url = Uri.parse(BASEURL.getbyidctv);
      var response = await http.post(
        url,
        body: {'id_ctv': idCtv},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['value'] == 1) {
          var userData = data['data'];
          _displayCtvInfoDialog(
              userData['name'], userData['phone'], userData['email']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Chưa có cộng tác viên nhận đơn. Vui lòng chờ thêm.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi kết nối đến server.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID CTV is null.'),
        ),
      );
    }
  }

  void _displayCtvInfoDialog(String name, String sdt, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin CTV'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tên: $name'),
              Text('Số Điện Thoại: $sdt'),
              Text('Email: $email')
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đặt lịch'),
      ),
      body: appointments.isEmpty
          ? Center(
              child: Text('Không có lịch sử đặt lịch.'),
            )
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                var transactionStatus = transactionStatusList.firstWhere(
                  (transaction) =>
                      transaction.idAppointment == appointment.idAppointment,
                  orElse: () => TransactionStatus(),
                );
                return Dismissible(
                  key: Key(appointment.idAppointment.toString()),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    // Gọi hàm xóa ở đây
                    _deleteAppointment(appointment.idAppointment.toString());
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Column(
                    children: [
                      Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dịch vụ: ${appointment.serviceId}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showCtvInfoDialog(appointment.idctv);
                                },
                                child: Text(
                                  'ID CTV: ${appointment.idctv ?? 'n/a'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Text(
                                getStatusText(appointment.status),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Colors.green[400]),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Hiển thị dialog xác nhận hoàn thành khi người dùng bấm vào Text
                                  if (appointment.status == '2') {
                                    // Hiển thị dialog xác nhận hoàn thành khi người dùng bấm vào Text
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Xác nhận hoàn thành'),
                                          content: Text(
                                              'Bạn có chắc chắn muốn xác nhận hoàn thành không?'),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Đóng dialog
                                                // Gọi hàm xác nhận hoàn thành ở đây
                                                _confirmCompletion(appointment
                                                    .idAppointment
                                                    .toString());
                                              },
                                              child: Text('Xác nhận'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Đóng dialog
                                              },
                                              child: Text('Thoát'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // Hiển thị thông báo khi status không phải là 2
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Không thể xác nhận hoàn thành cho trạng thái khác "Đã nhận".'),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Thời gian: ${appointment.datetime.toString()}',
                                ),
                              ),
                              Text('Giá: ${appointment.price}'),
                              Text(
                                'Mô tả công việc: ${appointment.description}',
                              ),
                              Text('Phòng: ${appointment.roomSize}'),
                              Text('Mức độ dơ: ${appointment.dirtLevel}'),
                              Text(
                                'Phương thức thanh toán: ${transactionStatus.paymentMethod ?? 'n/a'}',
                              ),
                              Text(StatusPay(transactionStatus.statusPay)),
                            ],
                          ),
                        ),
                      ),
                      Divider(), // Thêm Divider
                    ],
                  ),
                );
              },
            ),
    );
  }
}
