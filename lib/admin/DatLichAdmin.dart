import 'dart:convert';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentAdminPage extends StatefulWidget {
  @override
  _MyAppointmentsPageState createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<AppointmentAdminPage> {
  List<AppointmentData> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl = BASEURL.datlichAdmin; // Replace with your PHP API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          if (data.containsKey('data') && data['data'].isNotEmpty) {
            setState(() {
              appointments = List<Map<String, dynamic>>.from(data['data'])
                  .map((appointment) => AppointmentData(
                        id: appointment['id_appointment'],
                        userName: appointment['user_name'],
                        serviceName: appointment['service_name'],
                        price: appointment['price'],
                        dateTime: appointment['datetime'],
                        status: appointment['status'],
                      ))
                  .toList();
              isLoading = false;
            });
          } else {
            throw Exception('No appointment data found in the response.');
          }
        } else {
          throw Exception('Failed to load appointments: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHI TIẾT ĐẶT LỊCH '),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : AppointmentList(appointments: appointments),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final List<AppointmentData> appointments;

  AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        var appointment = appointments[index];
        return AppointmentCard(appointment: appointment);
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentData appointment;

  AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    String statusText = getStatusText(appointment.status);

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Khách hàng: ${appointment.userName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Tên dịch vụ: ${appointment.serviceName}'),
            SizedBox(height: 8.0),
            Text('Gía: ${appointment.price}'),
            SizedBox(height: 8.0),
            Text('Ngày giờ: ${appointment.dateTime}'),
            SizedBox(height: 8.0),
            Text('Trạng thái: $statusText'),
            SizedBox(height: 16.0), // Add spacing for buttons

            // // Buttons for actions
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         // Handle edit action
            //         _editAppointment(context, appointment);
            //       },
            //       child: Text('Sửa'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         // Handle delete action
            //         _deleteAppointment(context, appointment);
            //       },
            //       style: ElevatedButton.styleFrom(primary: Colors.white),
            //       child: Text('Xóa'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         // Handle additional action
            //         _additionalAction(context, appointment);
            //       },
            //       child: Text('Thêm'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Chờ làm';
      case '2':
        return 'Đã nhận';
      case '3':
        return 'Hoàn thành';
      default:
        return 'Unknown Status';
    }
  }

  void _editAppointment(BuildContext context, AppointmentData appointment) {
    // Implement the edit action
    // You can navigate to an edit screen or show a dialog for editing
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditAppointmentScreen(appointment: appointment)));
  }

  void _deleteAppointment(BuildContext context, AppointmentData appointment) {
    // Implement the delete action
    // You can show a confirmation dialog and then delete the appointment
  }

  void _additionalAction(BuildContext context, AppointmentData appointment) {
    // Implement additional action
    // Add the functionality you want to perform when the additional action button is pressed
  }
}

class AppointmentData {
  final String id;
  final String userName;
  final String serviceName;
  final String price;
  final String dateTime;
  final String status;

  AppointmentData({
    required this.id,
    required this.userName,
    required this.serviceName,
    required this.price,
    required this.dateTime,
    required this.status,
  });
}

void main() {
  runApp(MaterialApp(
    home: AppointmentAdminPage(),
  ));
}
