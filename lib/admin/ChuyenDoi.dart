import 'dart:convert';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChuyenDoi extends StatefulWidget {
  @override
  _ChuyenDoiState createState() => _ChuyenDoiState();
}

class _ChuyenDoiState extends State<ChuyenDoi> {
  List<CustomerModel> customers = [];

  @override
  void initState() {
    super.initState();
    // Fetch customer details when the widget is initialized
    fetchCustomerDetails();
  }

  Future<void> fetchCustomerDetails() async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.chuyendoi),
        body: <String, String>{
          'id_role': '2',
        },
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          if (data.containsKey('user_info') && data['user_info'].isNotEmpty) {
            setState(() {
              customers = List<CustomerModel>.from(data['user_info']
                  .map((user) => CustomerModel.fromJson(user)));
            });
          } else {
            throw Exception('No user data found in the response.');
          }
        } else {
          throw Exception('Failed to load user details: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin Khách hàng'),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            var customer = customers[index];
            return CustomerCard(
              customer: customer,
              onConvertPressed: (userId) {
                _performConversion(context, customer, userId);
              },
            );
          },
        ),
      ),
    );
  }

  void _performConversion(
      BuildContext context, CustomerModel customer, String? userId) async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.chuyendoi1),
        body: <String, String>{
          'id_user': userId ?? '',
        },
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          // Handle successful conversion, e.g., show a success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Chuyển đổi thành công'),
            duration: Duration(seconds: 2),
          ));

          // Reload customer details after successful conversion
          fetchCustomerDetails();
        } else {
          throw Exception('Failed to perform conversion: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to perform conversion. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final Function(String?) onConvertPressed;

  CustomerCard({required this.customer, required this.onConvertPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên: ${customer.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Địa chỉ: ${customer.address}'),
            SizedBox(height: 8.0),
            Text('SĐT: ${customer.phoneNumber}'),
            SizedBox(height: 8.0),
            Text('Email: ${customer.email}'),
            SizedBox(height: 8.0),
            Text('Role: ${customer.role}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onConvertPressed(customer.idUser);
              },
              child: Text('Chuyển đổi'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerModel {
  final String idUser;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String role;

  CustomerModel({
    required this.idUser,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.role,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      idUser: json['id_user'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: json['id_role'] ?? '',
    );
  }
}
