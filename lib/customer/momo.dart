import 'package:cleanservice/customer/homescreen.dart';
import 'package:cleanservice/customer/main2.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:momo_vn/momo_vn.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Momo extends StatefulWidget {
  final String idAppointment;

  Momo({
    required this.idAppointment,
  });
  @override
  _MomoState createState() => _MomoState();
}

class _MomoState extends State<Momo> {
  late MomoVn _momoPay;
  late PaymentResponse _momoPaymentResult;
  // ignore: non_constant_identifier_names
  late String _paymentStatus;
  late String _idAppointment;
  @override
  void initState() {
    super.initState();
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _paymentStatus = "";
    initPlatformState();
    _idAppointment = widget.idAppointment;
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> sendPaymentStatus() async {
    final response = await http.post(
      Uri.parse(BASEURL.pay),
      body: {
        'id_appointment': _idAppointment,
        'price': '10000',
        'payment_method': 'Momo',
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('THANH TOÁN QUA ỨNG DỤNG MOMO'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  TextButton(
                    // color: Colors.blue,
                    // textColor: Colors.white,
                    // disabledColor: Colors.grey,
                    // disabledTextColor: Colors.black,
                    // padding: EdgeInsets.all(8.0),
                    // splashColor: Colors.blueAccent,
                    child: Text('BÁM ĐỂ THANH TOÁN QUA MOMO'),
                    onPressed: () async {
                      sendPaymentStatus();
                      MomoPaymentInfo options = MomoPaymentInfo(
                          merchantName: "TTN",
                          appScheme: "MOxx",
                          merchantCode: 'MOMOHD4W20220825',
                          partnerCode: 'Mxx',
                          amount: 10000,
                          orderId: '12321312',
                          orderLabel: 'Gói combo',
                          merchantNameLabel: "HLGD",
                          fee: 10,
                          description: 'Thanh toán combo',
                          username: '01234567890',
                          partner: 'merchant',
                          extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
                          isTestMode: true);
                      try {
                        _momoPay.open(options);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPageAC()),
                      );
                    },
                    child: Text('Quay về trang chủ'),
                  ),
                ],
              ),
              Text(_paymentStatus.isEmpty ? "CHƯA THANH TOÁN" : _paymentStatus)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _momoPay.clear();
  }

  void _setState() {
    _paymentStatus = 'Đã chuyển thanh toán';
    if (_momoPaymentResult.isSuccess == true) {
      _paymentStatus += "\nTình trạng: Thành công.";
      _paymentStatus +=
          "\nSố điện thoại: " + _momoPaymentResult.phoneNumber.toString();
      // _paymentStatus += "\nExtra: " + _momoPaymentResult.extra!;
      // _paymentStatus += "\nToken: " + _momoPaymentResult.token.toString();
    } else {
      _paymentStatus += "\nTình trạng: Thất bại.";
      // _paymentStatus += "\nExtra: " + _momoPaymentResult.extra.toString();
      // _paymentStatus += "\nMã lỗi: " + _momoPaymentResult.status.toString();
    }
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    Fluttertoast.showToast(
        msg: "THÀNH CÔNG: " + response.phoneNumber.toString(),
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    Fluttertoast.showToast(
        msg: "THẤT BẠI: " + response.message.toString(),
        toastLength: Toast.LENGTH_SHORT);
  }
}
