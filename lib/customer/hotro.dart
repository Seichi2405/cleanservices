// import 'package:flutter/material.dart';
// import '../customer/main2.dart';

// class hotro extends StatefulWidget {
//   @override
//   State<hotro> createState() => _hotroState();
// }

// class _hotroState extends State<hotro> {
//   int _selectedValue = 0;

//   @override
//   Widget build(BuildContext context) {
//     double baseWidth = 430;
//     double fem = MediaQuery.of(context).size.width / baseWidth;
//     double ffem = fem * 0.97;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Hỗ trợ',
//           style: TextStyle(fontSize: 30),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeScreen(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: SizedBox(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Text('Tố cáo hành vi của CTV', style: TextStyle(fontSize: 25)),
//               Column(
//                 children: [
//                   RadioListTile<int>(
//                     title: Text('Trộm cắp'),
//                     value: 1,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile<int>(
//                     title: Text('Phá hoại tài sản'),
//                     value: 2,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile<int>(
//                     title: Text('Bạo lực thân thể'),
//                     value: 3,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile<int>(
//                     title: Text('Quấy rối'),
//                     value: 4,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile<int>(
//                     title: Text('Xúc phạm'),
//                     value: 5,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   RadioListTile<int>(
//                     title: Text('Khác'),
//                     value: 6,
//                     groupValue: _selectedValue,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedValue = value!;
//                       });
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Khác',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Text('Hình ảnh (nếu có)', style: TextStyle(fontSize: 25)),
//               SizedBox(
//                 height: 10,
//               ),
//               Icon(Icons.camera),
//               SizedBox(
//                 height: 30,
//               ),
//               Text('Ghi chú', style: TextStyle(fontSize: 25)),
//               SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   hintText: 'Ghi chú',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => MainPageAC()),
//                       );
//                     },
//                     child: Text('Hủy'),
//                   ),
//                   SizedBox(width: 50),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Xử lý khi nhấn nút Gửi
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('Thông báo'),
//                             content: Text('Đã gửi.'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MainPageAC(),
//                                     ),
//                                   );
//                                 },
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     child: Text('Gửi'),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
