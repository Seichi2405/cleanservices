import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/service_model.dart';
import '../mainctv.dart';

class ThongTin3 extends StatefulWidget {
  @override
  _ThongTinState3 createState() => _ThongTinState3();
}

class _ThongTinState3 extends State<ThongTin3> {
  int selectedLevel = 0;

  String _name = "Trần Đình Thọ";
  String _phone = "0919994656";
  String _address =
      "77 Đường Hoàng Diệu 2, Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh";
  String selectedValue = 'option1'; // Add this line
  int selectedOptionNumber = 0; // Add this line
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết dịch vụ"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => doanhthu(
                  idService: '',
                  nameService: '',
                  priceService: '',
                  serviceModel: ServiceModel(
                    idservice: '',
                    name: '',
                    description: '',
                    image: '',
                    price: '',
                    status: '',
                    createdat: '',
                  ),
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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Làm trong",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "2 giờ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Thông tin CTV",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Container(
                width: 700,
                height: 121,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff9ea2a2)),
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 4),
                      width: double.infinity,
                      height: 25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Phan Trí Vĩ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),
                          SizedBox(
                              width:
                                  100), // Khoảng cách giữa chữ "Phan Trí Vĩ" và ngôi sao
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 4), // Khoảng cách giữa ngôi sao và số
                          Text(
                            '4.8',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0031b0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 137),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 6.58),
                            width: 16.15,
                            height: 18,
                            // Placeholder for image
                          ),
                          Text(
                            '0853113113',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 137),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 6.58),
                            width: 16.15,
                            height: 18,
                            // Placeholder for image
                          ),
                          Text(
                            '160 lượt đặt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 137),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6.58),
                            width: 16.15,
                            height: 18,
                            // Placeholder for image
                          ),
                          Text(
                            'Q1, tp.Hồ Chí Minh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Thông tin công việc",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Container(
                width: 700,
                height: 121,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff9ea2a2)),
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      width: double.infinity,
                      child: Text(
                        'Cấp Độ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue!;

                            selectedOptionNumber = getSelectedOptionNumber(
                                selectedValue); // Update selectedOptionNumber
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'option1',
                            child: Text('Cấp độ 1 - Bình Thường'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'option2',
                            child: Text('Cấp độ 2 - Dơ'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'option3',
                            child: Text('Cấp độ 3 - Rất Dơ'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0031b0),
                          ),
                          children: [
                            TextSpan(
                                text:
                                    '+ ${getSelectedOptionNumberText(selectedOptionNumber)} '),
                            TextSpan(
                              text: 'đ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff0031b0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Chi tiết giao dịch',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clean Service',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dịch vụ:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('selectedServiceName'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tên khách hàng:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('name'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Địa chỉ:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('address'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số điện thoại:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('phone'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số tiền:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('price' + "vnd"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thời gian hẹn:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('formattedSelectedDate'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thành tiền:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text('price' + "vnd", style: TextStyle(fontSize: 25)),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Thực hiện các hành động khi nhấn nút Thanh toán
                },
                child: Text('Thanh toán'),
              ),
            ),
//....
          ],
        ),
      ),
    );
  }

  String getSelectedOptionNumberText(int optionNumber) {
    switch (optionNumber) {
      case 0:
        return '0';
      case 1:
        return '80.000';
      case 2:
        return '150.000';
      default:
        return '0';
    }
  }

  int getSelectedOptionNumber(String value) {
    switch (value) {
      case 'option1':
        return 0;
      case 'option2':
        return 1;
      case 'option3':
        return 2;
      default:
        return 0;
    }
  }
}
