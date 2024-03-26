import 'dart:convert';

import 'package:cleanservice/customer/cardservice.dart';
import 'package:cleanservice/customer/main2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pref_profile_model.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';
import 'package:http/http.dart' as http;

import 'historypage.dart';
import 'main3.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? selectedDate; // Thêm selectedDate vào đây
  final TimeOfDay? selectedTime;
  final String userID;
  HomeScreen({
    this.selectedDate, // Đánh dấu trường này là bắt buộc
    this.selectedTime,
    required this.userID,
  });
  @override
  _HomeSceenState createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeScreen> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController idServiceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomSizeController = TextEditingController();
  TextEditingController dirtLevelController = TextEditingController();
  List<ServiceModel> listService = [];

  getService() async {
    listService.clear();
    var urlService = Uri.parse(BASEURL.getService);
    final response = await http.get(urlService);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          listService.add(ServiceModel.fromJson(item));
        }
      });
    }
  }

  int? userid;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getService();
  }

// int? userid;
  @override
  Widget build(BuildContext context) {
    int selectedPrice = 0;
    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: EdgeInsets.fromLTRB(24, 30, 24, 30),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPageAC()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "~ Trang chủ ~",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(
                      repeatTimeController: repeatTimeController,
                      descriptionController: descriptionController,
                      dirtLevelController: dirtLevelController,
                      roomSizeController: roomSizeController,
                      idService: '',
                      name: '',
                      idAppointment: '',
                      userID: '',
                      selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
                      //repeatTimeController: widget.repeatTimeController,
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
              icon: Icon(Icons.history),
              color: Colors.greenAccent,
            )
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffe4faf0)),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xffb1d8b2),
              ),
              hintText: "Tìm kiếm...",
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          "Dịch vụ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 24),
        GridView.builder(
          itemCount: listService.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2),
          ),
          itemBuilder: (context, i) {
            final x = listService[i];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage2(
                      idService: x.idservice,
                      priceService: x.price,
                      nameService: x.name,
                      selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
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
              child: CardService(
                imageService: x.image,
                nameService: x.name,
                // priceService: x.price,
              ),
            );
          },
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ưu đãi',
            ),
            Text(
              'see all',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: double.infinity,
          height: 150,
          child: Image.asset(
            "assets/img/img/bannerjpg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bảng tin',
            ),
            Text(
              'see all',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://yt3.ggpht.com/a/AATXAJxuZzbmMTZ3ifJhH_MAn7N8Ihjc7DB96RJBRw=s900-c-k-c0xffffffff-no-rj-mo'),
                ),
                SizedBox(height: 10.0),
                Text('VTV'),
                Text('1 giờ trước'),
              ],
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Image.network(
                'https://t.ex-cdn.com/nongnghiep.vn/resize/600x337/files/news/2023/04/17/phim-cuoc-doi-van-dep-sao-tap-8-vtv3-nongnghiep-204620.jpg',
                height: 200,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ],
    )));
  }
}
