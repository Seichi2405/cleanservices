import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:cleanservice/customer/card_product.dart';
import 'package:cleanservice/customer/cardservice.dart';
import 'package:cleanservice/models/card_model.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:cleanservice/widgets/profile_page.dart';
import 'package:cleanservice/customer/main3.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pref_profile_model.dart';
import '../models/service_model.dart';
import 'danhgia.dart';
//import 'homeScreen.dart';
import 'historypage.dart';
import 'homescreen.dart';
import 'hotro.dart';

class MainPageAC extends StatefulWidget {
  @override
  State<MainPageAC> createState() => _MainPageStateAC();
}

class _MainPageStateAC extends State<MainPageAC> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    HomeScreen(
      userID: '',
    ), // Home
    Wallet(), // Wallet
    ChatPage(), // Chat
    ProfilePage(), // Account
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
            icon: Icon(Icons.wallet),
            label: 'Wallet',
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

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

//Profile

// class ProfileUI extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 170, right: 16, top: 10),
//                 child: Text(
//                   "Profile",
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Stack(
//               alignment: Alignment.center,
//               children: <Widget>[
//                 Center(
//                   child: Positioned(
//                     child: CircleAvatar(
//                       radius: 70,
//                       backgroundColor: Colors.black,
//                       backgroundImage: NetworkImage(
//                           'https://i.pinimg.com/280x280_RS/a4/2d/c5/a42dc574d1a7a3cdf7162818edd1e68e.jpg'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//                 //height: 20,
//                 ),
//             ListTile(
//               title: Text('NguyenLeBaoNgan',
//                   style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
//               //subtitle: Text('Khach Hang than thiet'),
//             ),
//             SizedBox(height: 20),
//             ListTile(
//               title: Text('Ngày sinh', style: TextStyle(fontSize: 25)),
//               subtitle: Text('21/11/2002', style: TextStyle(fontSize: 20)),
//             ),
//             ListTile(
//               title: Text('Giới tính', style: TextStyle(fontSize: 25)),
//               subtitle: Text('Nữ', style: TextStyle(fontSize: 20)),
//             ),
//             ListTile(
//               title: Text('Điện thoại', style: TextStyle(fontSize: 25)),
//               subtitle: Text('0834505170', style: TextStyle(fontSize: 20)),
//             ),
//             ListTile(
//               title: Text('Email', style: TextStyle(fontSize: 25)),
//               subtitle:
//                   Text('baongan@gmail.com', style: TextStyle(fontSize: 20)),
//             ),
//             ListTile(
//               title: Text('Địa chỉ', style: TextStyle(fontSize: 25)),
//               subtitle: Text('45 Nguyễn Đình Chiểu, P5, Q3',
//                   style: TextStyle(fontSize: 20)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//endprofile
//home
// class HomeScreen extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     final txtTheme = Theme.of(context).textTheme;
//     List<Color> BgColors = [
//       Color(0xFFFDD133),
//       Color(0xFF64DA91),
//       Color(0xFF60C0FC),
//       Color(0xFFFB7F7F),
//       Color(0xFFCA84F9),
//       Color(0xFF7AE667),
//     ];
//     List<String> ContainerList = [
//       "Tổngvệsinh",
//       "Dọndẹpnhà",
//       "VSmáylạnh",
//       "Nấuăn",
//       "Giặtủi",
//       "Sửanước",
//     ];
//     List<Image> ImgsList = [
//       Image.asset("assets/img/img/cleaning.png", width: 40, height: 40),
//       Image.asset('assets/img/img/house-cleaning.png', width: 40, height: 40),
//       Image.asset('assets/img/img/ac.png', width: 40, height: 40),
//       Image.asset('assets/img/img/cooking.png', width: 40, height: 40),
//       Image.asset('assets/img/img/washing-machine.png', width: 40, height: 40),
//       Image.asset('assets/img/img/water-faucet.png', width: 40, height: 40),
//     ];
//     return SafeArea(
//         child: Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(top: 30, left: 15, right: 15),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Home",
//                     style: txtTheme.titleLarge,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to the new page
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => hotro()),
//                       );
//                     },
//                     child: Icon(
//                       Icons.notifications_rounded,
//                       color: Color(0xFF3CB782),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 height: 50,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.black12.withOpacity(0.03),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.search),
//                     border: InputBorder.none,
//                     labelText: "Search...",
//                     labelStyle: TextStyle(fontSize: 14, color: Colors.black45),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: 6,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                 ),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MainPage2(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 70,
//                               width: 70,
//                               decoration: BoxDecoration(
//                                 color: BgColors[index],
//                                 borderRadius: BorderRadius.circular(40),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     blurRadius: 5,
//                                     color: BgColors[index],
//                                   ),
//                                 ],
//                               ),
//                               child: ImgsList[index],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(ContainerList[index]),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // SizedBox(
//               //   height: 5,
//               // ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Ưu đãi',
//                     style: txtTheme.titleLarge,
//                   ),
//                   Text(
//                     'see all',
//                     style: TextStyle(color: Colors.black45),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 150,
//                 child: Image.asset(
//                   "assets/img/img/bannerjpg.jpg",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Bảng tin',
//                     style: txtTheme.titleLarge,
//                   ),
//                   Text(
//                     'see all',
//                     style: TextStyle(color: Colors.black45),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: NetworkImage(
//                             'https://yt3.ggpht.com/a/AATXAJxuZzbmMTZ3ifJhH_MAn7N8Ihjc7DB96RJBRw=s900-c-k-c0xffffffff-no-rj-mo'),
//                       ),
//                       SizedBox(height: 10.0),
//                       Text('VTV'),
//                       Text('1 giờ trước'),
//                     ],
//                   ),
//                   SizedBox(width: 10.0),
//                   Expanded(
//                     child: Image.network(
//                       'https://t.ex-cdn.com/nongnghiep.vn/resize/600x337/files/news/2023/04/17/phim-cuoc-doi-van-dep-sao-tap-8-vtv3-nongnghiep-204620.jpg',
//                       height: 200,
//                       width: 300,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }

//home

// class HomeScreen extends StatefulWidget {
//   final DateTime? selectedDate; // Thêm selectedDate vào đây
//   final TimeOfDay? selectedTime;

//   HomeScreen({
//     this.selectedDate, // Đánh dấu trường này là bắt buộc
//     this.selectedTime,
//   });
//   @override
//   _HomeSceenState createState() => _HomeSceenState();
// }

// class _HomeSceenState extends State<HomeScreen> {
//   List<ServiceModel> listService = [];

//   getService() async {
//     listService.clear();
//     var urlService = Uri.parse(BASEURL.getService);
//     final response = await http.get(urlService);
//     if (response.statusCode == 200) {
//       setState(() {
//         final data = jsonDecode(response.body);
//         for (Map<String, dynamic> item in data) {
//           listService.add(ServiceModel.fromJson(item));
//         }
//       });
//     }
//   }

//   String? userID;
//   getPref() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//     setState(() {
//       userID = sharedPreferences.getString(PreProfile.idUser) ?? "";
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPref();
//     userID = PreProfile.idUser;
//     getService();
//   }

// // int? userid;
//   @override
//   Widget build(BuildContext context) {
//     int selectedPrice = 0;
//     return Scaffold(
//         body: SafeArea(
//             child: ListView(
//       padding: EdgeInsets.fromLTRB(24, 30, 24, 30),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "-- HOME --",
//                   style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 )
//               ],
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HistoryPage(userId: userID.toString()),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.history),
//               color: Colors.greenAccent,
//             )
//           ],
//         ),
//         SizedBox(
//           height: 24,
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           height: 55,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Color(0xffe4faf0)),
//           child: TextField(
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: Color(0xffb1d8b2),
//               ),
//               hintText: "Search ...",
//             ),
//           ),
//         ),
//         SizedBox(height: 24),
//         Text(
//           "Dịch vụ",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
//         ),
//         SizedBox(height: 24),
//         GridView.builder(
//           itemCount: listService.length,
//           shrinkWrap: true,
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
//           itemBuilder: (context, i) {
//             final x = listService[i];
//             return GestureDetector(
//               // Wrap CardService with GestureDetector
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => MainPage2(
//                             idService: x.idservice, //test id
//                             priceService: x.price,
//                             nameService: x.name,
//                             selectedDate: widget.selectedDate,
//                             selectedTime: widget.selectedTime,
//                             serviceModel: ServiceModel(
//                                 idservice: '',
//                                 name: '',
//                                 description: '',
//                                 image: '',
//                                 price: '',
//                                 status: '',
//                                 createdat: ''),
//                             //idService: x.idservice,
//                           )),
//                 );
//               },
//               child: CardService(
//                 imageService: x.image,
//                 nameService: x.name,
//                 // priceService: x.price,
//               ),
//             );
//           },
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Ưu đãi',
//             ),
//             Text(
//               'see all',
//               style: TextStyle(color: Colors.black45),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         SizedBox(
//           width: double.infinity,
//           height: 150,
//           child: Image.asset(
//             "assets/img/img/bannerjpg.jpg",
//             fit: BoxFit.cover,
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Bảng tin',
//             ),
//             Text(
//               'see all',
//               style: TextStyle(color: Colors.black45),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         Row(
//           children: [
//             Column(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       'https://yt3.ggpht.com/a/AATXAJxuZzbmMTZ3ifJhH_MAn7N8Ihjc7DB96RJBRw=s900-c-k-c0xffffffff-no-rj-mo'),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text('VTV'),
//                 Text('1 giờ trước'),
//               ],
//             ),
//             SizedBox(width: 10.0),
//             Expanded(
//               child: Image.network(
//                 'https://t.ex-cdn.com/nongnghiep.vn/resize/600x337/files/news/2023/04/17/phim-cuoc-doi-van-dep-sao-tap-8-vtv3-nongnghiep-204620.jpg',
//                 height: 200,
//                 width: 300,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//       ],
//     )));
//   }
// }

//wallet//

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Wallet',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 199,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16, right: 6),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 199,
                    width: 344,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Color(cards[index].cardBackground),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 29,
                          top: 48,
                          child: Text(
                            'CARD NUMBER',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white70),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          top: 65,
                          child: Text(
                            cards[index].cardNumber,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        // Positioned(
                        //   right: 21,
                        //   top: 35,
                        //   child: Image.asset(
                        //     cards[index].cardType,
                        //     width: 27,
                        //     height: 27,
                        //   ),
                        // ),
                        Positioned(
                          left: 29,
                          bottom: 45,
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          bottom: 21,
                          child: Text(
                            cards[index].user,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          left: 202,
                          bottom: 45,
                          child: Text(
                            'Exoiry Date',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70),
                          ),
                        ),
                        Positioned(
                          left: 202,
                          bottom: 21,
                          child: Text(
                            cards[index].cardExpired,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 13, top: 29),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Số dư hiện tại',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '500.000 vnd',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueAccent),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Điểm tích lũy',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '200đ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.add),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Đổi quà',
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          'see all',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/img/img/voucher1.jpg',
                                width: 250,
                                height: 170,
                              ),
                              SizedBox(height: 5),
                              Text('20 điểm'),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Image.asset(
                                'assets/img/img/voucher2.jpg',
                                width: 250,
                                height: 170,
                              ),
                              SizedBox(height: 5),
                              Text('50 điểm'),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Image.asset(
                                'assets/img/img/voucher3.png',
                                width: 250,
                                height: 170,
                              ),
                              SizedBox(height: 5),
                              Text('50 điểm'),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//endwt
