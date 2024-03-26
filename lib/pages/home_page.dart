import 'package:cleanservice/widgets/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../widgets/profile_page.dart';
import '../widgets/splash_screen.dart';
import 'package:cleanservice/ctv/profile_page_ctv.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Bạn là',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             GestureDetector(
//               child: Image.network(
//                 'https://simerp.io/wp-content/uploads/2021/04/Hanh-vi-nguoi-tieu-dung.png',
//                 width: 300,
//                 //height: 300,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfilePage()),
//                 );
//               },
//             ),
//             Text(
//               'Khách hàng',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             GestureDetector(
//               child: Image.network(
//                 'https://thumbs.dreamstime.com/b/businessman-office-worker-vector-illustration-45503639.jpg',
//                 width: 200,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfilePageCTV()),
//                 );
//               },
//             ),
//             Text(
//               'Cộng tác viên',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#35C6EFFF');
  Color _accentColor = HexColor('#8A02AE');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng Nhập',
      theme: ThemeData(
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: _accentColor),
      ),
      home: SplashScreen(title: 'Đăng Nhập'),
    );
  }
}
