import 'dart:convert';

import 'package:cleanservice/customer/constants.dart';
import 'package:cleanservice/customer/main2.dart';
import 'package:cleanservice/customer/momo.dart';
import 'package:cleanservice/helpers/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/pref_profile_model.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';
import 'danhgia.dart';
import 'homescreen.dart';
import 'main3.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

// ignore: must_be_immutable
class NewScreen extends StatefulWidget {
  final String name,
      priceService,
      nameService,
      selectedServiceName,
      selectedServiceID,
      idService,
      userID;
  final ServiceModel serviceModel;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TextEditingController repeatTimeController;
  final TextEditingController descriptionController;
  final TextEditingController roomSizeController;
  final TextEditingController dirtLevelController;
  final TextEditingController addressController;
  NewScreen({
    required this.name,
    this.priceService = '',
    this.nameService = '',
    this.selectedServiceName = '',
    required this.idService,
    required this.userID,
    required this.serviceModel,
    required this.selectedServiceID,
    required this.selectedDate,
    required this.selectedTime,
    required this.repeatTimeController,
    required this.descriptionController,
    required this.roomSizeController,
    required this.dirtLevelController,
    required this.addressController,
  });

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController idServiceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomSizeController = TextEditingController();
  TextEditingController dirtLevelController = TextEditingController();
  TextEditingController newRepeatTimeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late TextEditingController repeatTimeController;
  late TextEditingController descriptionController1;
  late TextEditingController roomSizeController1;
  late TextEditingController dirtLevelController1;
  late TextEditingController addressController1;
  String? name, phone, address;
  int? userid;
  String? idAppointment;
  get selectedDate => null;

  get selectedTime => null;

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString(PreProfile.name) ?? "";

      phone = sharedPreferences.getString(PreProfile.phone) ?? "";

      address = sharedPreferences.getString(PreProfile.address) ?? "";
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
      //print("User ID from SharedPreferences: $userID");
    });
  }

  String? selectedPaymentMethod;
  List<ServiceModel> listService = [];
  List<ServiceModel> selectedServices = []; // Danh sách dịch vụ đã chọn
  // DateTime? selectedDate;
  // TimeOfDay? selectedTime;
// Hàm xử lý khi chọn hoặc bỏ chọn một dịch vụ
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
        //  selectedServiceName = listService.first.name;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // selectedTime = widget.selectedTime;
    getPref();
    //selectedServiceName = widget.nameService;
    //selectedServiceID = widget.idService;
    newRepeatTimeController = TextEditingController();
    newRepeatTimeController.text = widget.repeatTimeController.text;
    descriptionController1 = TextEditingController();
    descriptionController1.text = widget.descriptionController.text;
    roomSizeController1 = TextEditingController();
    roomSizeController1.text = widget.roomSizeController.text;
    dirtLevelController1 = TextEditingController();
    dirtLevelController1.text = widget.dirtLevelController.text;
    addressController1 = TextEditingController();
    addressController1.text = widget.addressController.text;
    String selectedServiceName = widget.selectedServiceName;
    getService();
  }

  // String? updateSelectedServiceID() {
  //   for (ServiceModel service in listService) {
  //     if (service.name == service.idservice) {
  //       return service.idservice;
  //     }
  //   }
  //   return null;
  // }
  bool isPaymentSent = false;
  late String _idAppointment;
  submitAppointment() async {
    // var formattedSelectedDate =
    //     selectedDate != null ? selectedDate.toString() : '';

    var urlAppointments = Uri.parse(BASEURL.appointments);
    final response = await http.post(urlAppointments, body: {
      "id_user": userid.toString(),
      "id_service": selectedServiceID.toString(), //updateSelectedServiceID,
      "datetime": formattedSelectedDate,
      //'time': selectedTime.toString(),
      "repeatTime": newRepeatTimeController.text,
      "price": price.toString(),
      "description": descriptionController1.text,
      "roomSize": roomSizeController1.text,
      "dirtLevel": dirtLevelController1.text,
      "address_2": addressController1.text,
    });

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      int value = data['value'];
      // String message = data['message'];
      if (value == 1) {
        final idAppointment = data['id_appointment'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lịch đã được đặt thành công!'),
        ));
        print('idAppointment: $idAppointment');
        if (!isPaymentSent) {
          isPaymentSent = true;
          _idAppointment = idAppointment.toString();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Momo(
                idAppointment: idAppointment.toString(),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi khi đặt lịch'),
        ));
      }
    } else {
      // Xử lý lỗi nếu có lỗi trong yêu cầu HTTP.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi trong quá trình đặt lịch'),
      ));
    }
  }

  void _openMomoScreen(BuildContext context, String idAppointment) {
    submitAppointment();
  }

  Future<void> sendPaymentStatus() async {
    final response = await http.post(
      Uri.parse(BASEURL.pay),
      body: {
        'id_appointment': _idAppointment,
        'price': '10000',
        'payment_method': 'Paypal',
        'status_pay': '1',
      },
    );

    if (response.statusCode == 200) {
      print('Payment status sent successfully');
    } else {
      print(
          'Failed to send payment status. Status code: ${response.statusCode}');
    }
  }

  Future<void> sendPayment() async {
    final response = await http.post(
      Uri.parse(BASEURL.pay),
      body: {
        'id_appointment': _idAppointment,
        'price': '10000',
        'payment_method': 'Tiền mặt',
        'status_pay': '2',
      },
    );

    if (response.statusCode == 200) {
      print('Payment status sent successfully');
    } else {
      print(
          'Failed to send payment status. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Thanh toán', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phương thức thanh toán',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngân hàng ABC',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Miễn phi'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thêm liên kết',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Text('Phương thức thanh toán khác',
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // SizedBox(
              //   height: 10,
              // ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.grey[200], // màu nền ban đầu của button
              //     onPrimary: Colors.green, // màu chữ khi button được nhấn
              //     shape: RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.circular(10)), // bo góc cho button
              //   ),
              //   onPressed: () {},
              //   child: Text(
              //     'Tiền mặt',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Text('Chi tiết giao dịch',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    //test
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mã DV:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(selectedServiceID ?? 'N/A')
                      ],
                    ),

                    // tets
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tên dịch vụ:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$selectedServiceName')
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
                        Text('$name ')
                      ],
                    ),
                    SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Địa chỉ:',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     Text('$address')
                    //   ],
                    // ),
                    // SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Địa chỉ đặt:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            '${addressController1.text}',
                            overflow: TextOverflow
                                .ellipsis, // Cắt bớt và hiển thị dấu "..."
                          ),
                        ),
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
                        Text('$phone')
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
                        Text('$price' + "vnd")
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
                        Text('$formattedSelectedDate')
                      ],
                    ),
                    //
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lặp lại:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${newRepeatTimeController.text}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ghi chú của bạn:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${descriptionController1.text}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diện tích phòng:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${roomSizeController1.text}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cấp độ bẩn:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${dirtLevelController1.text}'),
                      ],
                    ),
                    //
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thành tiền:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text('$price' + "vnd", style: TextStyle(fontSize: 25))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       await submitAppointment();
              //       await sendPayment();
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => HomeScreen(
              //                   userID: '',
              //                 )),
              //       );
              //     },
              //     child: Text('Thanh toán'),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       await submitAppointment();
              //       await sendPaymentStatus();
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (BuildContext context) => UsePaypal(
              //               sandboxMode: true,
              //               clientId: "${Constants.clientId}",
              //               secretKey: "${Constants.secretKey}",
              //               returnURL: "${Constants.returnURL}",
              //               cancelURL: "${Constants.cancelURL}",
              //               transactions: const [
              //                 {
              //                   "amount": {
              //                     "total": '10.12',
              //                     "currency": "USD",
              //                     "details": {
              //                       "subtotal": '10.12',
              //                       "shipping": '0',
              //                       "shipping_discount": 0
              //                     }
              //                   },
              //                   "description":
              //                       "The payment transaction description.",
              //                   // "payment_options": {
              //                   //   "allowed_payment_method":
              //                   //       "INSTANT_FUNDING_SOURCE"
              //                   // },
              //                   "item_list": {
              //                     "items": [
              //                       {
              //                         "name": "A demo product",
              //                         "quantity": 1,
              //                         "price": '10.12',
              //                         "currency": "USD"
              //                       }
              //                     ],

              //                     // shipping address is not required though
              //                     "shipping_address": {
              //                       "recipient_name": "Jane Foster",
              //                       "line1": "Travis County",
              //                       "line2": "",
              //                       "city": "Austin",
              //                       "country_code": "US",
              //                       "postal_code": "73301",
              //                       "phone": "+00000000",
              //                       "state": "Texas"
              //                     },
              //                   }
              //                 }
              //               ],
              //               note: "Contact us for any questions on your order.",
              //               onSuccess: (Map params) async {
              //                 print("onSuccess: $params");
              //                 UIHelper.showAlertDialog('Thanh toán thành công',
              //                     title: 'thành công');
              //               },
              //               onError: (error) {
              //                 print("onError: $error");
              //                 UIHelper.showAlertDialog('Thanh toán thất bại',
              //                     title: 'Thất bại');
              //               },
              //               onCancel: (params) {
              //                 print('cancelled: $params');
              //                 UIHelper.showAlertDialog('Hủy thanh toán',
              //                     title: 'Hủy');
              //               }),
              //         ),
              //       );
              //     },
              //     child: Text('Thanh toán paypal'),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () =>
              //         _openMomoScreen(context, idAppointment.toString()),
              //     child: Text('Thanh toán momo'),
              //   ),
              // ),
              Column(
                children: [
                  Center(
                    child: DropdownButton<String>(
                      value: selectedPaymentMethod,
                      items: [
                        DropdownMenuItem(
                          child: Text('Chọn phương thức thanh toán'),
                          value: null,
                        ),
                        DropdownMenuItem(
                          child: Text('Tiền mặt'),
                          value: 'Tiền mặt',
                        ),
                        DropdownMenuItem(
                          child: Text('Paypal'),
                          value: 'Paypal',
                        ),
                        DropdownMenuItem(
                          child: Text('Momo'),
                          value: 'Momo',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        await submitAppointment();
                        if (selectedPaymentMethod == 'Paypal') {
                          await sendPaymentStatus();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsePaypal(
                                  sandboxMode: true,
                                  clientId: "${Constants.clientId}",
                                  secretKey: "${Constants.secretKey}",
                                  returnURL: "${Constants.returnURL}",
                                  cancelURL: "${Constants.cancelURL}",
                                  transactions: const [
                                    {
                                      "amount": {
                                        "total": '10.12',
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": '10.12',
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description":
                                          "The payment transaction description.",
                                      // "payment_options": {
                                      //   "allowed_payment_method":
                                      //       "INSTANT_FUNDING_SOURCE"
                                      // },
                                      "item_list": {
                                        "items": [
                                          {
                                            "name": "A demo product",
                                            "quantity": 1,
                                            "price": '10.12',
                                            "currency": "USD"
                                          }
                                        ],

                                        // shipping address is not required though
                                        "shipping_address": {
                                          "recipient_name": "Jane Foster",
                                          "line1": "Travis County",
                                          "line2": "",
                                          "city": "Austin",
                                          "country_code": "US",
                                          "postal_code": "73301",
                                          "phone": "+00000000",
                                          "state": "Texas"
                                        },
                                      }
                                    }
                                  ],
                                  note:
                                      "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: $params");
                                    UIHelper.showAlertDialog(
                                        'Thanh toán thành công',
                                        title: 'thành công');
                                  },
                                  onError: (error) {
                                    print("onError: $error");
                                    UIHelper.showAlertDialog(
                                        'Thanh toán thất bại',
                                        title: 'Thất bại');
                                  },
                                  onCancel: (params) {
                                    print('cancelled: $params');
                                    UIHelper.showAlertDialog('Hủy thanh toán',
                                        title: 'Hủy');
                                  }),
                            ),
                          );
                        } else if (selectedPaymentMethod == 'Momo') {
                          _openMomoScreen(context, idAppointment.toString());
                        } else {
                          await sendPayment();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPageAC(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 25),
                        primary: Colors.green,
                      ),
                      child: Text('Thanh toán')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
              //
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Thành tiền:',
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              //     ),
              //     Text('$price' + "vnd", style: TextStyle(fontSize: 25))
              //   ],
              // ),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
