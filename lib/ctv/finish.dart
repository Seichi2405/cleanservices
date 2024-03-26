import 'dart:convert';
import 'package:cleanservice/ctv/chitiet/ctdv1.dart';
import 'package:cleanservice/ctv/finish.dart';
import 'package:cleanservice/models/pref_profile_model.dart';
import 'package:cleanservice/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../customer/main3.dart';
import '../models/appointment.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';

class FinishPage extends StatefulWidget {
  final ServiceModel serviceModel;
  final String? selectedServiceID;
  final String selectedServiceName;

  FinishPage({
    required this.serviceModel,
    required this.selectedServiceID,
    this.selectedServiceName = '',
  });

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    String selectedServiceName = widget.selectedServiceName;
    fetchAppointments();
    getPref();
  }

  int? userid;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
    });
  }

  List<ServiceModel> selectedServices = [];

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
                    'Danh sách hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('See all'),
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
                            return Column(
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
