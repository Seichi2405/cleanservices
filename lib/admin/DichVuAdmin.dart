import 'dart:convert';
import 'dart:io';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  File? _image;

  Future<void> _getImageFromFile() async {
    String imagePath = _imagePathController.text;
    if (imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
      });
    } else {
      print('Image path is empty.');
    }
  }

  void _saveService() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String price = _priceController.text;
    String imagePath = _imagePathController.text;

    // Prepare the data to be sent in the request body
    Map<String, String> data = {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };

    try {
      final response = await http.post(
        Uri.parse(
            BASEURL.serviceAdmin), // Replace with your actual PHP API endpoint
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Handle the response data as needed
        print(responseData);

        // Check if the service was saved successfully
        if (responseData['value'] == 1) {
          // Show a success message, for example, a snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Dịch vụ đã thêm thành công'),
            duration: Duration(seconds: 2),
          ));

          // Reload the page by popping and pushing the current route
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          print('Failed to save service: ${responseData['message']}');
        }
      } else {
        print('Failed to save service. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm công việc'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Tên'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Mô tả'),
            // maxLines: 3,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Giá'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _imagePathController,
            decoration: InputDecoration(labelText: 'Hình ảnh'),
          ),
          SizedBox(height: 16.0),
          // ElevatedButton(
          //   onPressed: _getImageFromFile,
          //   child: Text('Tải ảnh'),
          // ),
          SizedBox(height: 16.0),
          _image != null
              ? Image.file(
                  _image!,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                )
              : Container(),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveService,
            child: Text('Lưu dịch vụ'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddServicePage(),
  ));
}
