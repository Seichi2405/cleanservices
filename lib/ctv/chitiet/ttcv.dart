import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/service_model.dart';
import '../mainctv.dart';

class ThongTin extends StatefulWidget {
  @override
  _ThongTinState createState() => _ThongTinState();
}

class _ThongTinState extends State<ThongTin> {
  int selectedLevel = 0;
  String _name = "Trần Đình Thọ";
  String _phone = "0919994656";
  String _address = "45 Nguyễn Đình Chiểu, P5, Q3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin công việc"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => doanhthu(
                  serviceModel: ServiceModel(
                    idservice: '',
                    name: '',
                    description: '',
                    image: '',
                    price: '',
                    status: '',
                    createdat: '',
                  ),
                  priceService: '',
                  idService: '',
                  nameService: '',
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Công việc: Dọn dẹp nhà",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Kích thước phòng",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "<55m2",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Cấp độ bẩn của phòng",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Cấp 2 - Thêm 30 phút",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Thông tin khách hàng",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO: Implement the update information feature
                    },
                    child: Text("Thay đổi"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Tên: $_name",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "SĐT: $_phone",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Địa chỉ: $_address",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 15),
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Lặp lại",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 3,
                  groupValue: selectedLevel,
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = 3;
                    });
                  },
                ),
                Text('2 tuần 1 lần'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tổng tiền: 150.000vnd',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => doanhthu(
                                serviceModel: ServiceModel(
                                  idservice: '',
                                  name: '',
                                  description: '',
                                  image: '',
                                  price: '',
                                  status: '',
                                  createdat: '',
                                ),
                                idService: '',
                                priceService: '',
                                nameService: '',
                              )),
                    );
                  },
                  child: Text('Từ chối'),
                ),
                SizedBox(width: 50),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút Gửi
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Đã gửi.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPageAd(),
                                  ),
                                );
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Xác nhận'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
