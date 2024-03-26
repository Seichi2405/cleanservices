// // ignore_for_file: use_build_context_synchronously

// import 'package:cleanservice/network/uri_api.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cleanservice/common/theme_helper.dart';
// import 'package:cleanservice/widgets/header_widget.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'login_page.dart';
// import 'profile_page.dart';
// import '../customer/main2.dart';

// class RegistrationPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _RegistrationPageState();
//   }
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   TextEditingController _nameController = TextEditingController();
//   // TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _sdtController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool checkedValue = false;
//   bool checkboxValue = false;

//   // Future<void> register(String name, String username, String email,
//   //     String password, String sdt, String address) async {
//   //   final apiUrl =
//   //       'http://192.168.1.5:1000/api/auth/signup'; // Thay đổi thành URL API đăng ký của bạn

//   //   try {
//   //     final Map<String, dynamic> requestBody = {
//   //       'name': name,
//   //       'username': username,
//   //       'email': email,
//   //       'sdt': sdt,
//   //       'address': address,
//   //       'password': password,
//   //     };

//   //     final response = await http.post(
//   //       Uri.parse(apiUrl),
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //       },
//   //       body: jsonEncode(requestBody), // Use jsonEncode here
//   //     );
//   //     print('HTTP status code: ${response.statusCode}');
//   //     print('Response : ${response}');
//   //     if (response.statusCode == 200) {
//   //       if (response.body == "User registered successfully.") {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(content: Text('Đăng ki thanh cong')),
//   //         );
//   //         Navigator.pushReplacement(
//   //             context, MaterialPageRoute(builder: (context) => LoginPage()));
//   //       }
//   //       ;
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
//   //       );
//   //     }
//   //   } catch (error) {
//   //     print('Đã xảy ra lỗi: $error');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Đã xảy ra lỗi: $error')),
//   //     );
//   //   }
//   // }
//   registerSubmit() async {
//     var registerUrl = Uri.parse(BASEURL.apiRegister);
//     final reponse = await http.post(registerUrl, body: {
//       "name": _nameController.text,
//       "email": _emailController.text,
//       "address": _addressController.text,
//       "phone": _sdtController.text,
//       "password": _passwordController.text,
//     });
//     final data = jsonDecode(reponse.body);
//     int value = data['value'];
//     String message = data['message'];
//     if (value == 1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green, // Màu xanh
//         ),
//       );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red, // Màu đỏ
//         ),
//       );
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Container(
//               height: 150,
//               child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
//             ),
//             Container(
//               margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
//               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                           child: Stack(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(100),
//                                   border:
//                                       Border.all(width: 5, color: Colors.white),
//                                   color: Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 20,
//                                       offset: const Offset(5, 5),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.person,
//                                   color: Colors.grey.shade300,
//                                   size: 80.0,
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
//                                 child: Icon(
//                                   Icons.add_circle,
//                                   color: Colors.grey.shade700,
//                                   size: 25.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Container(
//                           child: TextFormField(
//                             controller: _nameController,
//                             decoration: ThemeHelper()
//                                 .textInputDecoration('Name', 'Enter your name'),
//                           ),
//                           decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         // Container(
//                         //   child: TextFormField(
//                         //     controller: _usernameController,
//                         //     decoration: ThemeHelper().textInputDecoration(
//                         //         'User Name', 'Enter your user name'),
//                         //   ),
//                         //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         // ),
//                         // SizedBox(height: 20.0),
//                         Container(
//                           child: TextFormField(
//                             controller: _emailController,
//                             decoration: ThemeHelper().textInputDecoration(
//                                 "E-mail address", "Enter your email"),
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (val) {
//                               if (!(val!.isEmpty) &&
//                                   !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
//                                       .hasMatch(val)) {
//                                 return "Enter a valid email address";
//                               }
//                               return null;
//                             },
//                           ),
//                           decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         ),
//                         SizedBox(height: 20.0),
//                         Container(
//                           child: TextFormField(
//                             controller: _sdtController,
//                             decoration: ThemeHelper().textInputDecoration(
//                                 "Mobile Number", "Enter your mobile number"),
//                             keyboardType: TextInputType.phone,
//                             validator: (val) {
//                               if (!(val!.isEmpty) &&
//                                   !RegExp(r"^(\d+)*$").hasMatch(val)) {
//                                 return "Enter a valid phone number";
//                               }
//                               return null;
//                             },
//                           ),
//                           decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           child: TextFormField(
//                             controller: _addressController,
//                             decoration: ThemeHelper().textInputDecoration(
//                                 'Address', 'Enter your address'),
//                           ),
//                           decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         ),
//                         SizedBox(height: 20.0),
//                         Container(
//                           child: TextFormField(
//                             controller: _passwordController,
//                             obscureText: true,
//                             decoration: ThemeHelper().textInputDecoration(
//                                 "Password*", "Enter your password"),
//                             validator: (val) {
//                               if (val!.isEmpty) {
//                                 return "Please enter your password";
//                               }
//                               return null;
//                             },
//                           ),
//                           decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                         ),
//                         SizedBox(height: 15.0),
//                         FormField<bool>(
//                           builder: (state) {
//                             return Column(
//                               children: <Widget>[
//                                 Row(
//                                   children: <Widget>[
//                                     Checkbox(
//                                         value: checkboxValue,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxValue = value!;
//                                             state.didChange(value);
//                                           });
//                                         }),
//                                     Text(
//                                       "I accept all terms and conditions.",
//                                       style: TextStyle(color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     state.errorText ?? '',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       color: Theme.of(context).errorColor,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             );
//                           },
//                           validator: (value) {
//                             if (!checkboxValue) {
//                               return 'You need to accept terms and conditions';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         SizedBox(height: 20.0),
//                         Container(
//                           decoration:
//                               ThemeHelper().buttonBoxDecoration(context),
//                           child: ElevatedButton(
//                             style: ThemeHelper().buttonStyle(),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(40, 10, 40, 10),
//                               child: Text(
//                                 "Register".toUpperCase(),
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             onPressed: () {
//                               if (_nameController.text.isEmpty ||
//                                   _emailController.text.isEmpty ||
//                                   _sdtController.text.isEmpty ||
//                                   _addressController.text.isEmpty ||
//                                   _passwordController.text.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Vui lòng nhập thông tin"),
//                                     backgroundColor: Colors.red, // Màu đỏ
//                                   ),
//                                 );
//                               } else {
//                                 registerSubmit();
//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(
//                                 //         builder: (context) => LoginPage()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             },
//                           ),
//                         ),

//                         // Container(
//                         //   width: MediaQuery.of(context).size.width,
//                         //   child: ButtonPrimary(
//                         //     text: "ĐĂNG KÝ",
//                         //     onTap: () {
//                         //       if (_nameController.text.isEmpty ||
//                         //           _emailController.text.isEmpty ||
//                         //           _sdtController.text.isEmpty ||
//                         //           _addressController.text.isEmpty ||
//                         //           _passwordController.text.isEmpty) {
//                         //         showDialog(
//                         //             context: context,
//                         //             builder: (context) => AlertDialog(
//                         //                   title: Text("Cảnh báo !!"),
//                         //                   content:
//                         //                       Text("Vui lòng nhập thông tin"),
//                         //                   actions: [
//                         //                     TextButton(
//                         //                         onPressed: () {
//                         //                           Navigator.pop(context);
//                         //                         },
//                         //                         child: Text("Ok"))
//                         //                   ],
//                         //                 ));
//                         //       } else {
//                         //         registerSubmit();
//                         //       }
//                         //     },
//                         //   ),
//                         // ),

//                         SizedBox(height: 30.0),
//                         Text(
//                           "Or create account using social media",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 25.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               child: FaIcon(
//                                 FontAwesomeIcons.googlePlus,
//                                 size: 35,
//                                 color: HexColor("#EC2D2F"),
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return ThemeHelper().alartDialog(
//                                           "Google Plus",
//                                           "You tap on GooglePlus social icon.",
//                                           context);
//                                     },
//                                   );
//                                 });
//                               },
//                             ),
//                             SizedBox(
//                               width: 30.0,
//                             ),
//                             GestureDetector(
//                               child: Container(
//                                 padding: EdgeInsets.all(0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(100),
//                                   border: Border.all(
//                                       width: 5, color: HexColor("#40ABF0")),
//                                   color: HexColor("#40ABF0"),
//                                 ),
//                                 child: FaIcon(
//                                   FontAwesomeIcons.twitter,
//                                   size: 23,
//                                   color: HexColor("#FFFFFF"),
//                                 ),
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return ThemeHelper().alartDialog(
//                                           "Twitter",
//                                           "You tap on Twitter social icon.",
//                                           context);
//                                     },
//                                   );
//                                 });
//                               },
//                             ),
//                             SizedBox(
//                               width: 30.0,
//                             ),
//                             GestureDetector(
//                               child: FaIcon(
//                                 FontAwesomeIcons.facebook,
//                                 size: 35,
//                                 color: HexColor("#3E529C"),
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return ThemeHelper().alartDialog(
//                                           "Facebook",
//                                           "You tap on Facebook social icon.",
//                                           context);
//                                     },
//                                   );
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
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
// ignore_for_file: use_build_context_synchronously

import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cleanservice/common/theme_helper.dart';
import 'package:cleanservice/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'profile_page.dart';
import '../customer/main2.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _sdtController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  // Future<void> register(String name, String username, String email,
  //     String password, String sdt, String address) async {
  //   final apiUrl =
  //       'http://192.168.1.5:1000/api/auth/signup'; // Thay đổi thành URL API đăng ký của bạn

  //   try {
  //     final Map<String, dynamic> requestBody = {
  //       'name': name,
  //       'username': username,
  //       'email': email,
  //       'sdt': sdt,
  //       'address': address,
  //       'password': password,
  //     };

  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(requestBody), // Use jsonEncode here
  //     );
  //     print('HTTP status code: ${response.statusCode}');
  //     print('Response : ${response}');
  //     if (response.statusCode == 200) {
  //       if (response.body == "User registered successfully.") {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Đăng ki thanh cong')),
  //         );
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => LoginPage()));
  //       }
  //       ;
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
  //       );
  //     }
  //   } catch (error) {
  //     print('Đã xảy ra lỗi: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đã xảy ra lỗi: $error')),
  //     );
  //   }
  // }
  registerSubmit() async {
    var registerUrl = Uri.parse(BASEURL.apiRegister);
    final reponse = await http.post(registerUrl, body: {
      "name": _nameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "phone": _sdtController.text,
      "password": _passwordController.text,
    });
    final data = jsonDecode(reponse.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green, // Màu xanh
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red, // Màu đỏ
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: ThemeHelper()
                                .textInputDecoration('Name', 'Enter your name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // Container(
                        //   child: TextFormField(
                        //     controller: _usernameController,
                        //     decoration: ThemeHelper().textInputDecoration(
                        //         'User Name', 'Enter your user name'),
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                        // SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _sdtController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _addressController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Address', 'Enter your address'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_nameController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _sdtController.text.isEmpty ||
                                  _addressController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Vui lòng nhập thông tin"),
                                    backgroundColor: Colors.red, // Màu đỏ
                                  ),
                                );
                              } else {
                                registerSubmit();
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginPage()),
                                //     (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: ButtonPrimary(
                        //     text: "ĐĂNG KÝ",
                        //     onTap: () {
                        //       if (_nameController.text.isEmpty ||
                        //           _emailController.text.isEmpty ||
                        //           _sdtController.text.isEmpty ||
                        //           _addressController.text.isEmpty ||
                        //           _passwordController.text.isEmpty) {
                        //         showDialog(
                        //             context: context,
                        //             builder: (context) => AlertDialog(
                        //                   title: Text("Cảnh báo !!"),
                        //                   content:
                        //                       Text("Vui lòng nhập thông tin"),
                        //                   actions: [
                        //                     TextButton(
                        //                         onPressed: () {
                        //                           Navigator.pop(context);
                        //                         },
                        //                         child: Text("Ok"))
                        //                   ],
                        //                 ));
                        //       } else {
                        //         registerSubmit();
                        //       }
                        //     },
                        //   ),
                        // ),

                        SizedBox(height: 30.0),
                        Text(
                          "Or create account using social media",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus,
                                size: 35,
                                color: HexColor("#EC2D2F"),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Google Plus",
                                          "You tap on GooglePlus social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: HexColor("#40ABF0")),
                                  color: HexColor("#40ABF0"),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  size: 23,
                                  color: HexColor("#FFFFFF"),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Twitter",
                                          "You tap on Twitter social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 35,
                                color: HexColor("#3E529C"),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
