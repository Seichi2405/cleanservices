import 'dart:convert';
import 'package:cleanservice/ctv/chitiet/ctdv1.dart';
import 'package:cleanservice/ctv/finish.dart';
import 'package:cleanservice/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../customer/main3.dart';
import '../models/appointment.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';

class load extends StatefulWidget {
  final ServiceModel serviceModel;
  final String? selectedServiceID;
  final String selectedServiceName;

  load({
    required this.serviceModel,
    required this.selectedServiceID,
    this.selectedServiceName = '',
  });

  @override
  State<load> createState() => _loadState();
}

class _loadState extends State<load> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    getServiceAppointments();
    String selectedServiceName = widget.selectedServiceName;
    // fetchAppointments();
  }

  List<ServiceModel> selectedServices = [];
  void handleServiceSelection(ServiceModel service) {
    setState(() {
      if (selectedServices.contains(service)) {
        // Nếu dịch vụ đã được chọn, bỏ chọn và trừ giá tiền
        selectedServices.remove(service);
        totalPrice -= double.parse(service.price);
      } else {
        // Nếu dịch vụ chưa được chọn, thêm vào danh sách và cộng giá tiền
        selectedServices.add(service);
        totalPrice += double.parse(service.price);
        selectedServiceName = service.name;
        selectedServiceID = service.idservice;
      }
    });
  }

  List<Appointment> completedAppointments = [];
  getServiceAppointments() async {
    var urlReceive = Uri.parse(BASEURL.receive);
    final response = await http.post(urlReceive, body: {
      "id_service": widget.selectedServiceID.toString(),
      // "name": widget.selectedServiceName,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        for (var item in data) {
          final appointment = Appointment.fromJson(item);
          setState(() {
            appointments.add(appointment);
            if (appointment.status == 3) {
              completedAppointments.add(appointment);
            }
          });
        }
      }
    } else {
      throw Exception('Failed to load appointments from API');
    }
  }

  void handleAppointmentSelection(Appointment appointment) {
    if (appointment.status == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return FinishPage(
              serviceModel: ServiceModel(
                  createdat: '',
                  description: '',
                  idservice: '',
                  image: '',
                  name: '',
                  price: '',
                  status: ''),
              selectedServiceID: '',
            );
          },
        ),
      );
    } else {
      // Xử lý logic khác nếu muốn
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đề cử',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('Tất cả'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return GestureDetector(
                              onTap: () {
                                handleAppointmentSelection(appointment);
                                // Navigate to a new page when the card is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ThongTin(
                                        appointment: appointment,
                                        // user: User(
                                        //     name: "", address: "", sdt: ""),
                                        userID: '',
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Card(
                                    margin: EdgeInsets.all(8),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Dịch vụ: ${appointment.serviceName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            getStatusText(appointment.status),
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              color: Colors.green[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Tên khách hàng: ${appointment.userName}'),
                                          Text(
                                              'Thời gian: ${appointment.datetime.toString()}'),
                                          Text('Giá: ${appointment.price}'),
                                          // Text(
                                          //     'Mô tả công việc: ${appointment.description}'),
                                          // Text(
                                          //     'Phòng: ${appointment.roomSize}'),
                                          // Text(
                                          //     'Mức độ dơ: ${appointment.dirtLevel}'),
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
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
