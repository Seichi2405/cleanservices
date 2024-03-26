import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:cleanservice/customer/location.dart';
import 'package:location/location.dart';
import 'package:time_range/time_range.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:one_clock/one_clock.dart';
import 'package:cleanservice/customer/main2.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pref_profile_model.dart';
import '../models/service_model.dart';
import '../network/uri_api.dart';
import '../widgets/profile_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'cardservice.dart';
import 'main2.dart';
import 'danhgia.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'newscreen.dart';

// moi them idService
class MainPage2 extends StatefulWidget {
  final String priceService, nameService, idService;
  final ServiceModel serviceModel;
  final DateTime? selectedDate; // Đảm bảo rằng selectedDate đã được định nghĩa
  final TimeOfDay? selectedTime;
  MainPage2({
    this.priceService = '',
    this.nameService = '',
    required this.serviceModel,
    this.idService = '',
    required this.selectedDate, // Đảm bảo rằng selectedDate đã được định nghĩa
    required this.selectedTime,
  });
  @override
  _MainPageState2 createState() => _MainPageState2();
}

double totalPrice = 0.0;
int pricePerHour = 80000;
bool showTotalPrice = false;
String? selectedServiceName, selectedServiceID;

double price = 0.0;
String formattedSelectedDate = '';

class _MainPageState2 extends State<MainPage2> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController idServiceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatTimeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomSizeController = TextEditingController();
  TextEditingController dirtLevelController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  LatLng? selectedLocation;
  List<ServiceModel> listService = [];
  List<ServiceModel> selectedServices = []; // Danh sách dịch vụ đã chọn
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
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
      });
    }
  }

  String? name, phone, address;
  int? userID;

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString(PreProfile.name) ?? "";

      phone = sharedPreferences.getString(PreProfile.phone) ?? "";

      address = sharedPreferences.getString(PreProfile.address) ?? "";
      userID = sharedPreferences.getInt(PreProfile.idUser);
    });
  }

//
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
/////ghi chu tam ̣cos saif
  void _getCurrentLocation() async {
    geolocator.LocationAccuracy geolocatorAccuracy =
        geolocator.LocationAccuracy.high;
    location.LocationData locationData =
        await location.Location().getLocation();
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocatorAccuracy,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      if (_currentLocation != null) {
        addressController.text =
            'Lat: ${_currentLocation!.latitude}, Lng: ${_currentLocation!.longitude}';
      }
    });
    // setState(() {
    //   _currentLocation = LatLng(position.latitude, position.longitude);
    //   if (_currentLocation != null) {
    //     _getAddressFromLatLng(
    //         _currentLocation!.latitude, _currentLocation!.longitude);
    //   }
    // });
  }

  // Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latitude, longitude);

  //     if (placemarks.isNotEmpty) {
  //       Placemark placemark = placemarks[0];
  //       String address =
  //           '${placemark.street} ${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}';
  //       print('Address: $address');

  //       setState(() {
  //         addressController.text = address;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
//

  @override
  void initState() {
    super.initState();
    // selectedTime = widget.selectedTime;
    getPref();
    selectedServiceName = widget.nameService;
    selectedServiceID = widget.idService;
    getService();
    _getCurrentLocation();
  }

  int currentStep = 0;
  String roomSize = '';
  String additionalServices = '';
  int selectedLevel = 0;

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        updateFormattedDateTime();
      });
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      // initialTime: TimeOfDay.now(),
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        updateFormattedDateTime();
      });
  }

  String addressValue = '';
  void updateFormattedDateTime() {
    formattedSelectedDate = "";
    if (selectedDate != null && selectedTime != null) {
      formattedSelectedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ),
      );
    } else {
      formattedSelectedDate = '';
    }
  }

  // Future<void> _openMapsAndPickLocation() async {
  //   final location = Location();
  //   final hasPermission = await location.serviceEnabled();

  //   if (!hasPermission) {
  //     final serviceStatus = await location.requestService();
  //     if (serviceStatus != PermissionStatus.granted) {
  //       // Handle the case where location service is not enabled
  //       return;
  //     }
  //   }

  //   // Lấy vị trí hiện tại
  //   final position = await location.getLocation();

  //   // Xây dựng URL để mở ứng dụng Google Maps với vị trí hiện tại
  //   final mapUrl =
  //       'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

  //   if (await canLaunch(mapUrl)) {
  //     await launch(mapUrl);

  //     // Lắng nghe sự kiện khi người dùng quay lại ứng dụng
  //     final selectedLocation = await Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PickLocationScreen(addressController),
  //       ),
  //     );

  //     // Kiểm tra và cập nhật giá trị vào TextFormField
  //     if (selectedLocation != null && selectedLocation is LatLng) {
  //       final updatedLocation =
  //           'Lat: ${selectedLocation.latitude}, Lng: ${selectedLocation.longitude}';
  //       addressController.text = updatedLocation;
  //     }
  //   } else {
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 88, 204, 185),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // addToCart();
            Navigator.of(context).pop();
          },
        ),
        title: Text('Dọn dẹp ', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < 3) {
              setState(() {
                currentStep = currentStep + 1;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewScreen(
                    repeatTimeController: repeatTimeController,
                    descriptionController: descriptionController,
                    addressController: addressController,
                    dirtLevelController: dirtLevelController,
                    roomSizeController: roomSizeController,
                    idService: '',
                    name: '',
                    selectedServiceName: '',
                    selectedServiceID: '',
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
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep = currentStep - 1;
              });
            }
          },
          onStepTapped: (int value) {
            setState(() {
              currentStep = value;
            });
          },
          controlsBuilder: (context, details) {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text('Next'),
                ),
                SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: Text('Back'),
                )
              ],
            );
          },
          steps: [
            Step(
              title: Text('Bước 1'),
              content: Column(
                children: [
                  Text(
                    'Kích thước phòng',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Vui lòng ước tính diện tích cần dọn dẹp:',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = '<55m2';
                            roomSizeController.text = roomSize;
                            totalPrice =
                                double.parse(widget.priceService) + 80000 * 2;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(
                            roomSize == '<55m2' ? '<55m2' : '<55m2 - 2 giờ'),
                        style: ElevatedButton.styleFrom(
                          primary:
                              roomSize == '<55m2' ? Colors.green : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = '55-80m2';
                            roomSizeController.text = roomSize;
                            totalPrice =
                                double.parse(widget.priceService) + 80000 * 3;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == '55-80m2'
                            ? '55-80m2'
                            : '55-80m2 - 3 giờ'),
                        style: ElevatedButton.styleFrom(
                          primary: roomSize == '55-80m2'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = '80-100m2';
                            roomSizeController.text = roomSize;
                            totalPrice =
                                double.parse(widget.priceService) + 80000 * 4;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == '80-100m2'
                            ? '80-100m2'
                            : '80-100m2 - 4 giờ'),
                        style: ElevatedButton.styleFrom(
                          primary: roomSize == '80-100m2'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = '>100m2';
                            roomSizeController.text = roomSize;
                            totalPrice =
                                double.parse(widget.priceService) + 80000 * 5;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == '>100m2'
                            ? '>100m2'
                            : '>100m2 - >4 giờ'),
                        style: ElevatedButton.styleFrom(
                          primary:
                              roomSize == '>100m2' ? Colors.green : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Giá tiền sẽ được tính theo thời gian thực nhân viên thực hiện: 1 giờ = 80.000đ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Dịch vụ thêm',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Bạn có thể chọn thêm dịch vụ',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
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
                              // Gọi hàm để xử lý khi chọn/bỏ chọn dịch vụ
                              handleServiceSelection(x);
                            },
                            child: CardService(
                              imageService: x.image,
                              nameService: x.name,
                              priceService: x.price + "vnd",
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Kích thước phòng: $roomSize', // Hiển thị kích thước
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      if (showTotalPrice) // Hiển thị tổng giá nếu showTotalPrice là true
                        Text(
                          'Giá:  $totalPrice' +
                              "vnd", // Hiển thị giá dịch vụ và tổng giá
                          style: TextStyle(fontSize: 20),
                        )
                      else
                        Text(
                          'Giá: ${widget.priceService}' +
                              "vnd", // Hiển thị giá dịch vụ ban đầu
                          style: TextStyle(fontSize: 20),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
              isActive: currentStep >= 0,
              state: currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Bước 2'),
              content: Column(
                children: [
                  Text(
                    'Cấp độ bẩn của phòng',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ctv sẽ giúp bạn đánh giá mức độ bẩn của phòng. Tùy theo từng mức độ sẽ có thụ phu tương ứng',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = 'Cấp 1 - Bình thường';
                            dirtLevelController.text = roomSize;
                            price = totalPrice + 0;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == 'Cấp 1 - Bình thường'
                            ? 'Cấp 1 - Bình thường + 0 vnd'
                            : 'Cấp 1 - Bình thường '),
                        style: ElevatedButton.styleFrom(
                          primary: roomSize == 'Cấp 1 - Bình thường'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = 'Cấp 2 - Thêm 30 phút';
                            dirtLevelController.text = roomSize;
                            price = totalPrice + 40000;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == 'Cấp 2 - Thêm 30 phút'
                            ? 'Cấp 2 - Thêm 30 phút + 40.000 vnd'
                            : 'Cấp 2 - Thêm 30 phút'),
                        style: ElevatedButton.styleFrom(
                          primary: roomSize == 'Cấp 2 - Thêm 30 phút'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            roomSize = 'Cấp 3 - Thêm 1 giờ';
                            dirtLevelController.text = roomSize;
                            price = totalPrice + 80000;
                            showTotalPrice = true;
                          });
                        },
                        child: Text(roomSize == 'Cấp 3 - Thêm 1 giờ'
                            ? 'Cấp 3 - Thêm 1 giờ + 80.000 vnd'
                            : 'Cấp 3 - Thêm 1 giờ'),
                        style: ElevatedButton.styleFrom(
                          primary: roomSize == 'Cấp 3 - Thêm 1 giờ'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'Video',
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      // SizedBox(height: 5),
                      // Text(
                      //   'Vui lòng cung cấp video để ctv đánh giá cấp độ bẩn của phòng',
                      //   style: TextStyle(
                      //     fontStyle: FontStyle.italic,
                      //     fontSize: 15,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      // Icon(Icons.video_camera_back_outlined),
                      // SizedBox(height: 10),
                      Text(
                        'Tùy chọn',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: selectedLevel,
                            onChanged: (value) {
                              setState(() {
                                selectedLevel = 1!;
                              });
                            },
                          ),
                          Text('Nhà có vật nuôi'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: selectedLevel,
                            onChanged: (value) {
                              setState(() {
                                selectedLevel = 2!;
                              });
                            },
                          ),
                          Text('Tự chọn người làm'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 3,
                            groupValue: selectedLevel,
                            onChanged: (value) {
                              setState(() {
                                selectedLevel = 3!;
                              });
                            },
                          ),
                          Text('Khác'),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (showTotalPrice) // Hiển thị tổng giá nếu showTotalPrice là true
                        Text(
                          'Giá:  $price' +
                              "vnd", // Hiển thị giá dịch vụ và tổng giá
                          style: TextStyle(fontSize: 20),
                        )
                      else
                        Text(
                          'Giá: ${widget.priceService}' +
                              "vnd", // Hiển thị giá dịch vụ ban đầu
                          style: TextStyle(fontSize: 20),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
              isActive: currentStep >= 1,
              state: currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Bước 3'),
              content: Column(
                children: [
                  Text(
                    'Địa điểm làm việc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: name ?? 'N/A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    enabled: false, // make the text field read-only
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      labelText: phone ?? 'N/A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    enabled: false, // make the text field read-only
                  ),
                  SizedBox(height: 5),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: address ?? 'N/A',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(
                  //         width: 2,
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //   ),
                  //   enabled: false, // make the text field read-only
                  // ),
                  // SizedBox(height: 5),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Địa chỉ làm việc',
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // _openMapsAndPickLocation();
                          String address = addressController.text;

                          // Cập nhật giá trị vào biến và hiển thị trong TextField không thể chỉnh sửa
                          setState(() {
                            addressValue = address;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PickLocationScreen(addressController),
                            ),
                          );
                        },
                        child: Icon(Icons.location_on), // Icon định vị
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Chọn ngày làm',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: TextField(
                          controller: dateController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: selectedDate == null
                                ? 'Select Date'
                                : 'Selected Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Chọn giờ làm',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: TextField(
                          controller: timeController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: selectedTime == null
                                ? 'Select Time'
                                : 'Selected Time: ${selectedTime!.format(context)}',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Lặp lại',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Hằng ngày",
                            //groupValue: selectedLevel,
                            groupValue: repeatTimeController.text,
                            onChanged: (value) {
                              setState(() {
                                //selectedLevel = 1!;
                                repeatTimeController.text = "Hằng ngày";
                              });
                            },
                          ),
                          Text('Hằng ngày'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Hàng tuần",
                            //groupValue: selectedLevel,
                            groupValue: repeatTimeController.text,
                            onChanged: (value) {
                              setState(() {
                                //selectedLevel = 2!;
                                repeatTimeController.text =
                                    "Hàng tuần"; //value.toString();
                              });
                            },
                          ),
                          Text('Hàng tuần'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "2 tuần 1 lần",
                            //groupValue: selectedLevel,
                            groupValue: repeatTimeController.text,
                            onChanged: (value) {
                              setState(() {
                                //selectedLevel = 3!;
                                repeatTimeController.text = "2 tuần 1 lần";
                              });
                            },
                          ),
                          Text('2 tuần 1 lần'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Hàng tháng",
                            //groupValue: selectedLevel,
                            groupValue: repeatTimeController.text,
                            onChanged: (value) {
                              setState(() {
                                //selectedLevel = 4!;
                                repeatTimeController.text = "Hàng tháng";
                              });
                            },
                          ),
                          Text('Hàng tháng'),
                        ],
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Ghi chú cho người làm',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 15),
                      if (showTotalPrice) // Hiển thị tổng giá nếu showTotalPrice là true
                        Text(
                          'Giá:  $price' +
                              "vnd", // Hiển thị giá dịch vụ và tổng giá
                          style: TextStyle(fontSize: 20),
                        )
                      else
                        Text(
                          'Giá: ${widget.priceService}' +
                              "vnd", // Hiển thị giá dịch vụ ban đầu
                          style: TextStyle(fontSize: 20),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
              isActive: currentStep >= 2,
              state: currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Bước 4'),
              content: Column(
                children: [
                  Text(
                    'Địa điểm làm việc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: name ?? 'N/A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    enabled: false, // make the text field read-only
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      labelText: phone ?? 'N/A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    enabled: false, // make the text field read-only
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      labelText: addressValue.isNotEmpty ? addressValue : 'N/A',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    enabled: false,
                  ),
                  //
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: address ?? 'N/A',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(
                  //         width: 2,
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //   ),
                  //   enabled: false, // make the text field read-only
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //SizedBox(height: 15),
                      Text(
                        'Thông tin công việc',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: idServiceController,
                        decoration: InputDecoration(
                          hintText: 'Tên công việc:  $selectedServiceName',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Thời gian: $formattedSelectedDate',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 15),
                      // if (showTotalPrice) // Hiển thị tổng giá nếu showTotalPrice là true
                      //   Text(
                      //     'Giá:  $totalPrice' +
                      //         "vnd", // Hiển thị giá dịch vụ và tổng giá
                      //     style: TextStyle(fontSize: 20),
                      //   )
                      // else
                      //   Text(
                      //     'Giá: ${widget.priceService}' +
                      //         "vnd", // Hiển thị giá dịch vụ ban đầu
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // SizedBox(height: 20),

                      if (showTotalPrice)
                        Text(
                          'Giá:  $price' + "vnd",
                          style: TextStyle(fontSize: 20),
                        )
                      else
                        Text(
                          'Giá: ${widget.priceService}' + "vnd",
                          style: TextStyle(fontSize: 20),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
              isActive: currentStep >= 3,
              state: currentStep >= 3 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }
}
