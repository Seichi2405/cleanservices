import 'dart:convert';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CTVadminPage extends StatefulWidget {
  @override
  _CTVadminPageState createState() => _CTVadminPageState();
}

class _CTVadminPageState extends State<CTVadminPage> {
  List<Map<String, dynamic>> partners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch partner details when the widget is initialized
    fetchPartnerDetails();
  }

  Future<void> fetchPartnerDetails() async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.ctvAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          if (data.containsKey('data') && data['data'].isNotEmpty) {
            setState(() {
              partners = List<Map<String, dynamic>>.from(data['data']);
              isLoading = false;
            });
          } else {
            throw Exception('No partner data found in the response.');
          }
        } else {
          throw Exception('Failed to load partner details: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load partner details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePartner(String idUser) async {
    try {
      final response = await http.post(
        Uri.parse(BASEURL.deleteCustomer),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'id_user': idUser},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('value') && data['value'] == 1) {
          // Create a copy of the list and remove the dismissed item
          List<Map<String, dynamic>> updatedPartners = List.from(partners);
          updatedPartners
              .removeWhere((partner) => partner['id_user'] == idUser);

          // Update the state with the new list
          setState(() {
            partners = updatedPartners;
          });
        } else {
          throw Exception('Failed to delete partner: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to delete partner. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deletePartner: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cộng tác viên'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  var partner = partners[index];
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(partner['id_user'].toString()),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          String idUser = partner['id_user'];
                          deletePartner(idUser);
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
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            title: Text(
                              'Tên: ${partner['name'] ?? 'N/A'}',
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
                                  'Địa chỉ: ${partner['address'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'SĐT: ${partner['phone'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Email: ${partner['email'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(
                              double.infinity,
                              80,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(CTVadminPage());
}
