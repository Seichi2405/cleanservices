// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../customer/cardservice.dart';
import '../models/appointment.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../network/uri_api.dart';
import 'chitiet/ctdv1.dart';
import 'mainctv.dart';

class HomeScreenCTV extends StatefulWidget {
  final String nameService, idService;
  HomeScreenCTV({
    this.nameService = '',
    // required this.serviceModel,
    this.idService = '',
  });
  @override
  State<HomeScreenCTV> createState() => _HomeScreenStateCTV();
}

class _HomeScreenStateCTV extends State<HomeScreenCTV> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController idServiceController = TextEditingController();
  List<ServiceModel> listService = [];
  List<ServiceModel> selectedServices = [];
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

  List<Appointment> appointments = [];
  fetchAppointments() async {
    var urllistApp = Uri.parse(BASEURL.get_appointments);
    final response = await http.get(urllistApp);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        for (var item in data) {
          final appointment = Appointment.fromJson(item);
          if (appointment.status != '3') {
            appointments.add(appointment);
          }
        }
      }
    } else {
      throw Exception('Failed to load appointments from API');
    }
  }

  void handleServiceSelection(ServiceModel service) {
    setState(() {
      if (selectedServices.contains(service)) {
        // Nếu dịch vụ đã được chọn, bỏ chọn và trừ giá tiền
        selectedServices.remove(service);
        //totalPrice -= double.parse(service.price);
      } else {
        // Nếu dịch vụ chưa được chọn, thêm vào danh sách và cộng giá tiền
        selectedServices.add(service);
        // totalPrice += double.parse(service.price);
        selectedServiceName = service.name;
        selectedServiceID = service.idservice;
      }
    });
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
  void initState() {
    super.initState();
    selectedServiceName = widget.nameService;
    selectedServiceID = widget.idService;
    getService();
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedTime = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24, 30, 24, 30),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "~ Trang chủ ~",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )
                  ],
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => HistoryPage(

                //           //repeatTimeController: widget.repeatTimeController,
                //           serviceModel: ServiceModel(
                //             idservice: '',
                //             name: '',
                //             description: '',
                //             image: '',
                //             price: '',
                //             status: '',
                //             createdat: '',
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                //   icon: Icon(Icons.history),
                //   color: Colors.greenAccent,
                // )
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
                  hintText: "Tìm kiếm ...",
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Theo dịch vụ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 15,
            ),
            GridView.builder(
              itemCount: listService.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2)),
              itemBuilder: (context, i) {
                final x = listService[i];
                return GestureDetector(
                  // Wrap CardService with GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => doanhthu(
                                // selectedServiceID: selectedServiceID,
                                idService: x.idservice, //test id
                                priceService: x.price,
                                nameService: x.name,
                                // selectedDate: widget.selectedDate,
                                // selectedTime: widget.selectedTime,
                                serviceModel: ServiceModel(
                                  idservice: '',
                                  name: '',
                                  description: '',
                                  image: '',
                                  price: '',
                                  status: '',
                                  createdat: '',
                                ),
                              )),
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
            Text(
              'Danh sách',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 15,
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
                              // Navigate to a new page when the card is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ThongTin(
                                      appointment: appointment,
                                      // user:
                                      //     User(name: "", address: "", sdt: ""),
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
                                        // Text('Phòng: ${appointment.roomSize}'),
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
    );
  }
}

//home
