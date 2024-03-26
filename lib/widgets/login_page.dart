// import 'dart:ffi';
import 'dart:io';

import 'package:cleanservice/admin/homeadmin.dart';
import 'package:cleanservice/ctv/button.dart';
import 'package:cleanservice/ctv/mainctv.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:cleanservice/pages/home_page.dart';
import 'package:cleanservice/widgets/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../ctv/homectv.dart';
import '../customer/main2.dart';
import '../customer/main3.dart';
import '../models/pref_profile_model.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';
import '../widgets/header_widget.dart';
import 'package:http/io_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAdmin =
      false; // Đây là quyền hạn của người dùng, ban đầu không phải là admin.
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  submitLogin() async {
    var urlLogin = Uri.parse(BASEURL.apiLogin);
    final response = await http.post(urlLogin, body: {
      "email": _emailController.text,
      "password": _passwordController.text
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    int idUser = data['id_user'];
    String name = data['name'];
    String email = data['email'] ?? "N/A";
    // print("Retrieved email: $email");
    String phone = data['phone'];
    String address = data['address'];
    String createdAt = data['created_at'];
    int? roleId;
    if (data['id_role'] is int) {
      roleId = data['id_role'];
    } else if (data['id_role'] is String) {
      roleId = int.tryParse(data['id_role']);
    }
    if (value == 1 &&
        idUser != null &&
        name != null &&
        email != null &&
        phone != null) {
      // Lưu thông tin đăng nhập vào SharedPreferences
      savePref(idUser, name, email, phone, address, createdAt);
      // Kiểm tra quyền hạn (role_id)

      // Kiểm tra quyền hạn (ví dụ: isAdmin)
      //   if (isAdmin) {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => ProfilePage()));
      //   } else {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => ProfilePage()));
      //   }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thông báo"),
          content: Text(message ?? "Có lỗi xảy ra"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Đồng ý"),
            )
          ],
        ),
      );
    }
    setState(() {});

    // savePref(idUser, name = '', email = '', phone = '', address = '',
    //     createdAt = '');
    // sharedPreferences.setString(PreProfile.name, name);
    // sharedPreferences.setString(PreProfile.email, email);
    // sharedPreferences.setString(PreProfile.phone, phone);
    // sharedPreferences.setString(PreProfile.address, address);
    // sharedPreferences.setString(PreProfile.createdAt, createdAt);
    Color snackBarColor = value == 1 ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: snackBarColor,
      ),
    );

    if (value == 1) {
      savePref(idUser, name, email, phone, address, createdAt);
      //
      if (roleId == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      } else if (roleId == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPageAC()));
      } else if (roleId == 3) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPageAd()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(message),
        ),
      );
    }
  }

  void savePref(int idUser, String name, String email, String phone,
      String address, String createdAt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt(PreProfile.idUser, idUser);
      sharedPreferences.setString(PreProfile.name, name ?? "");
      sharedPreferences.setString(PreProfile.email, email ?? "");
      sharedPreferences.setString(PreProfile.phone, phone ?? "");
      sharedPreferences.setString(PreProfile.address, address ?? "");
      sharedPreferences.setString(PreProfile.createdAt, createdAt ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Xin Chào',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Đăng nhập vào tài khoản của bạn',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                "Quên mật khẩu?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              // style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "LOGIN".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        "Vui lòng nhập thông tin",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                } else {
                                  submitLogin();
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(builder: (context) => ProfilePage()),
                                  //     (Route<dynamic> route) => false);
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: "Không có tài khoản? "),
                              TextSpan(
                                text: 'Tạo Tài Khoản',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegistrationPage()),
                                    );
                                  },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // import 'dart:ffi';
// import 'dart:io';

// import 'package:cleanservice/ctv/button.dart';
// import 'package:cleanservice/network/uri_api.dart';
// import 'package:cleanservice/pages/home_page.dart';
// import 'package:cleanservice/widgets/profile_page.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../models/pref_profile_model.dart';
// import 'forgot_password_page.dart';
// import 'registration_page.dart';
// import '../widgets/header_widget.dart';
// import 'package:http/io_client.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   double _headerHeight = 250;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   submitLogin() async {
//     var urlLogin = Uri.parse(BASEURL.apiLogin);
//     final response = await http.post(urlLogin, body: {
//       "email": _emailController.text,
//       "password": _passwordController.text
//     });

//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//     final data = jsonDecode(response.body);
//     int value = data['value'];
//     String message = data['message'];

//     int idUser = data['id_user'];
//     String name = data['name'];
//     String email = data['email'] ?? "N/A";
//     // print("Retrieved email: $email");
//     String phone = data['phone'];
//     String address = data['address'];
//     String createdAt = data['created_at'];
//     // savePref(idUser, name = '', email = '', phone = '', address = '',
//     //     createdAt = '');
//     // sharedPreferences.setString(PreProfile.name, name);
//     // sharedPreferences.setString(PreProfile.email, email);
//     // sharedPreferences.setString(PreProfile.phone, phone);
//     // sharedPreferences.setString(PreProfile.address, address);
//     // sharedPreferences.setString(PreProfile.createdAt, createdAt);
//     Color snackBarColor = value == 1 ? Colors.green : Colors.red;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: snackBarColor,
//       ),
//     );

//     if (value == 1) {
//       savePref(idUser, name, email, phone, address, createdAt);
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => ProfilePage()),
//         (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.redAccent,
//           content: Text(message),
//         ),
//       );
//     }
//   }

//   void savePref(int idUser, String name, String email, String phone,
//       String address, String createdAt) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     setState(() {
//       sharedPreferences.setInt(PreProfile.idUser, idUser);
//       sharedPreferences.setString(PreProfile.name, name ?? "");
//       sharedPreferences.setString(PreProfile.email, email ?? "");
//       sharedPreferences.setString(PreProfile.phone, phone ?? "");
//       sharedPreferences.setString(PreProfile.address, address ?? "");
//       sharedPreferences.setString(PreProfile.createdAt, createdAt ?? "");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: _headerHeight,
//               child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
//             ),
//             SafeArea(
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Xin Chào',
//                       style:
//                           TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'Đăng nhập vào tài khoản của bạn',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(height: 30.0),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               hintText: 'Email',
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(height: 30.0),
//                           TextFormField(
//                             controller: _passwordController,
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               hintText: 'Password',
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(height: 15.0),
//                           Container(
//                             margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           ForgotPasswordPage()),
//                                 );
//                               },
//                               child: Text(
//                                 "Quên mật khẩu?",
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             // decoration: ThemeHelper().buttonBoxDecoration(context),
//                             child: ElevatedButton(
//                               // style: ThemeHelper().buttonStyle(),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(40, 10, 40, 10),
//                                 child: Text(
//                                   "LOGIN".toUpperCase(),
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 if (_emailController.text.isEmpty ||
//                                     _passwordController.text.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.redAccent,
//                                       content: Text(
//                                         "Vui lòng nhập thông tin",
//                                         style: TextStyle(color: Colors.black),
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   submitLogin();
//                                   // Navigator.of(context).pushAndRemoveUntil(
//                                   //     MaterialPageRoute(builder: (context) => ProfilePage()),
//                                   //     (Route<dynamic> route) => false);
//                                 }
//                               },
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
//                             child: Text.rich(TextSpan(children: [
//                               TextSpan(text: "Không có tài khoản? "),
//                               TextSpan(
//                                 text: 'Tạo Tài Khoản',
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               RegistrationPage()),
//                                     );
//                                   },
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                               ),
//                             ])),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
