import 'dart:convert';

import 'package:cleanservice/ctv/finish.dart';
import 'package:cleanservice/ctv/stats.dart';

import '../ctv/quydoi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cleanservice/ctv/profile_page_ctv.dart';
import '../customer/main3.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';
import 'chitiet/ttcv.dart';
import 'homectv.dart';
import 'package:fl_chart/fl_chart.dart';

import 'load.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPageAd(),
      routes: {
        '/quydoi': (context) => quydoi(),
      },
    );
  }
}

//Button navbar
class MainPageAd extends StatefulWidget {
  @override
  State<MainPageAd> createState() => _MainPageAdState();
}

class _MainPageAdState extends State<MainPageAd> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    HomeScreenCTV(),
    doanhthu(
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
      nameService: '',
      priceService: '',
    ),
    tichdiem(),
    ChatPageCTV(),
    ProfilePageCTV(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Doanh Thu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Tích điểm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          )
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      //body: ChatPage(),
    );
  }
}

//Tab Tich Diem
class tichdiem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 932 * fem,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 120 * fem,
                top: 50 * fem,
                child: Align(
                  child: SizedBox(
                    width: 200 * fem,
                    height: 50 * fem,
                    child: Container(
                      color: Colors.cyan,
                      child: Center(
                        child: Text(
                          'Tích Điểm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0 * fem,
                top: 101 * fem,
                child: Align(
                  child: SizedBox(
                    width: 430 * fem,
                    height: 780 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff000000)),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 6.5 * fem,
                top: 150 * fem,
                child: Align(
                  child: SizedBox(
                    width: 200 * fem,
                    height: 30 * fem,
                    child: Text(
                      'Điểm Tích Lũy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 200 * fem,
                top: 150 * fem,
                child: Align(
                  child: SizedBox(
                    width: 200 * fem,
                    height: 30 * fem,
                    child: Text(
                      '100',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w900,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff0425fa),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20 * fem,
                top: 200 * fem,
                child: Align(
                  child: SizedBox(
                    width: 200 * fem,
                    height: 30 * fem,
                    child: Text(
                      'Thu Nhập Đảm Bảo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 210 * fem,
                top: 200 * fem,
                child: Align(
                  child: SizedBox(
                    width: 200 * fem,
                    height: 30 * fem,
                    child: Text(
                      '350.000đ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w900,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff0425fa),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 170 * fem,
                top: 300 * fem,
                child: Align(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => quydoi()),
                      );
                    },
                    child: Text('Quy đổi'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> titles = <String>[
  'Chờ Làm',
  'Đã Hoàn Thành',
  'Thống Kê',
];

class doanhthu extends StatefulWidget {
  final String priceService, nameService, idService;
  doanhthu({
    required this.nameService,
    required this.priceService,
    required this.idService,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    required ServiceModel serviceModel,
    String? selectedServiceID,
  });
  @override
  State<doanhthu> createState() => _doanhthuState();
}

String? selectedServiceName, selectedServiceID;

class _doanhthuState extends State<doanhthu> {
  // const doanhthu({super.key});
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

  void handleServiceSelection(ServiceModel service) {
    setState(() {
      if (selectedServices.contains(service)) {
        // Nếu dịch vụ đã được chọn, bỏ chọn và trừ giá tiền
        selectedServices.remove(service);
        totalPrice -= double.parse(service.price);
      } else {
        // Nếu dịch vụ chưa được chọn, thêm vào danh sách và cộng giá tiền
        selectedServices.add(service);
        totalPrice += double.parse(service.price);
        selectedServiceName = service.name;
        selectedServiceID = service.idservice;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // selectedTime = widget.selectedTime;
    //getPref();
    selectedServiceName = widget.nameService;
    selectedServiceID = widget.idService;
    getService();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    const int tabsCount = 3;

    return DefaultTabController(
      initialIndex: 0,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Doanh Thu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * ffem / fem,
                  color: Color(0xcbffffff),
                ),
              ),
            ),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: titles[0],
              ),
              Tab(
                text: titles[1],
              ),
              Tab(
                text: titles[2],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Content for the first tab
            Container(
              child: load(
                selectedServiceID: selectedServiceID,
                // idService: '',
                // name: '',
                selectedServiceName: '',
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
            // Content for the second tab
            Container(
              child: FinishPage(
                serviceModel: ServiceModel(
                    createdat: '',
                    description: '',
                    idservice: '',
                    image: '',
                    name: '',
                    price: '',
                    status: ''),
                selectedServiceID: '',
              ),
            ),
            // Content for the third tab
            Container(
              child: MonthlyTotalsChart(
                userID: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//dạng cột
// class StatisticalChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Thống kê theo tháng',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Container(
//               width: 400,
//               height: 400,
//               child: BarChart(
//                 BarChartData(
//                   barGroups: [
//                     BarChartGroupData(
//                       x: 1,
//                       barRods: [
//                         BarChartRodData(toY: 80),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 2,
//                       barRods: [
//                         BarChartRodData(toY: 75),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 3,
//                       barRods: [
//                         BarChartRodData(toY: 58),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 4,
//                       barRods: [
//                         BarChartRodData(toY: 47),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 5,
//                       barRods: [
//                         BarChartRodData(toY: 78.5),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 6,
//                       barRods: [
//                         BarChartRodData(toY: 76),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 7,
//                       barRods: [
//                         BarChartRodData(toY: 66),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 8,
//                       barRods: [
//                         BarChartRodData(toY: 33),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 9,
//                       barRods: [
//                         BarChartRodData(toY: 54),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 10,
//                       barRods: [
//                         BarChartRodData(toY: 86),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 11,
//                       barRods: [
//                         BarChartRodData(toY: 78),
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 12,
//                       barRods: [
//                         BarChartRodData(toY: 97),
//                       ],
//                     ),
//                     // Thêm các BarChartGroupData khác tương tự cho các tháng còn lại
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Text(
//             //   '1 - 12 là số tháng trong năm',
//             //   style: TextStyle(fontSize: 16),
//             // ),
//             // SizedBox(height: 8),
//             // Text(
//             //   '20 - 100 là tỉ lệ % công việc trong 1 tháng',
//             //   style: TextStyle(fontSize: 16),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//--------------------------------------------------------------------//

// class load extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(top: 30, left: 15, right: 15),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Đề cử',
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                 Text('see all'),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ThongTin()),
//                 );
//               },
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       // CircleAvatar(
//                       //   backgroundImage: NetworkImage(
//                       //       'https://i0.wp.com/thatnhucuocsong.com.vn/wp-content/uploads/2023/02/Hinh-anh-avatar-cute.jpg?ssl=1l'),
//                       //   radius: 30,
//                       // ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Trần Đình Thọ',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 Text(
//                                   '1,5km',
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               '26.11.2022 |10h00',
//                               style:
//                                   TextStyle(fontSize: 12, color: Colors.grey),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               '77 Đường Hoàng Diệu 2, Linh Trung, Thủ Đức, Thành phố Hồ Chí Minh',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Công việc cần làm: Dọn dẹp nhà',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   '150.000 vnd',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class finish extends StatelessWidget {
//   // const load({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(top: 30, left: 15, right: 15),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Danh sách hoàn thành',
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                 Text('see all'),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           'https://toigingiuvedep.vn/wp-content/uploads/2022/01/hinh-avatar-cute-nu.jpg'),
//                       radius: 30,
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Nguyễn Đình Hoàng',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16),
//                               ),
//                               Text(
//                                 '1,5km',
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             '26.11.2022 |10h00',
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             '12 Hai Bà Trưng, DaKao, Q1',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                           SizedBox(height: 5),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Công việc cần làm: Sửa nước',
//                                 style: TextStyle(
//                                     fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 '150.000 vnd',
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// account
//Profile

//chat

class ChatPageCTV extends StatefulWidget {
  @override
  State<ChatPageCTV> createState() => _ChatPageStateCTV();
}

class _ChatPageStateCTV extends State<ChatPageCTV> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
      text: 'Ngan',
      Image: 'assets/img/img/ava1.jpg',
      secondaryText: 'hello',
      time: 'Now',
    ),
    ChatUsers(
      text: 'Tho',
      Image: '',
      secondaryText: 'hi',
      time: 'Yesterday',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 175, right: 16, top: 10),
                child: Text(
                  "Chat",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
                itemCount: chatUsers.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUserList(
                    text: chatUsers[index].text,
                    secondaryText: chatUsers[index].secondaryText,
                    Image: chatUsers[index].Image,
                    time: chatUsers[index].time,
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                  );
                })
          ],
        ),
      ),
    );
  }
}

class ChatUserList extends StatefulWidget {
  String text;
  String secondaryText;
  String Image;
  String time;
  bool isMessageRead;
  ChatUserList(
      {required this.text,
      required this.secondaryText,
      required this.Image,
      required this.time,
      required this.isMessageRead});
  @override
  State<ChatUserList> createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.Image),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.secondaryText,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  color: widget.isMessageRead
                      ? Colors.pink
                      : Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatUsers {
  String text;
  String secondaryText;
  String Image;
  String time;
  ChatUsers(
      {required this.text,
      required this.secondaryText,
      required this.Image,
      required this.time});
}

class ChatDetailPage extends StatefulWidget {
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> chatMessage = [
    ChatMessage(message: "hi", type: MessageType.Receiver),
    ChatMessage(message: "helllloooooo", type: MessageType.Sender),
    ChatMessage(message: "1234", type: MessageType.Receiver),
    ChatMessage(message: "5678", type: MessageType.Sender),
  ];
  //

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photo - Video", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "Mic", icons: Icons.mic, color: Colors.blue),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

//
  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: chatMessage.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatBubble(
                chatMessage: chatMessage[index],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 50),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                backgroundColor: Colors.pink,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: AssetImage("assets/img/img/ava1.jpg"),
                maxRadius: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Ngan",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.phone,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

enum MessageType {
  Sender,
  Receiver,
}

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({required this.message, required this.type});
}

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({required this.chatMessage});
  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.chatMessage.type == MessageType.Receiver
                ? Colors.white
                : Colors.grey.shade200),
          ),
          padding: EdgeInsets.all(16),
          child: Text(widget.chatMessage.message),
        ),
      ),
    );
  }
}

//send_menu_items

class SendMenuItems {
  String text;
  IconData icons;
  MaterialColor color;
  SendMenuItems({required this.text, required this.icons, required this.color});
}
