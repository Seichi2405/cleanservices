import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../network/uri_api.dart';

class CustomerInforPage extends StatefulWidget {
  @override
  _CustomerInforPageState createState() => _CustomerInforPageState();
}

class _CustomerInforPageState extends State<CustomerInforPage> {
  List<Map<String, dynamic>> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch customer details when the widget is initialized
    fetchCustomerDetails();
  }

  Future<void> fetchCustomerDetails() async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.khAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          if (data.containsKey('data') && data['data'].isNotEmpty) {
            setState(() {
              customers = List<Map<String, dynamic>>.from(data['data']);
              isLoading = false;
            });
          } else {
            throw Exception('No customer data found in the response.');
          }
        } else {
          throw Exception(
              'Failed to load customer details: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load customer details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCustomer(int idUser) async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.deleteCustomer),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'id_user': idUser.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          // Create a copy of the list and remove the dismissed item
          List<Map<String, dynamic>> updatedCustomers = List.from(customers);
          updatedCustomers.removeWhere(
              (customer) => customer['id_user'] == idUser.toString());

          // Update the state with the new list
          setState(() {
            customers = updatedCustomers;
          });
        } else {
          throw Exception('Failed to delete customer: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to delete customer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteCustomer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin khách hàng'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  var customer = customers[index];
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(customer['id_user'].toString()),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          int idUser = int.parse(customer['id_user']);
                          deleteCustomer(idUser);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button click
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            title: Text(
                              'Tên: ${customer['name'] ?? 'N/A'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'Địa chỉ: ${customer['address'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'SĐT: ${customer['phone'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Email: ${customer['email'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Đặt màu trong suốt
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(double.infinity,
                                80), // Điều chỉnh kích thước theo yêu cầu
                          ),
                        ),
                      ),
                      Divider(height: 1.0, color: Colors.grey),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
