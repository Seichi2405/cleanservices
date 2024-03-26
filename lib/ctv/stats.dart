// import 'dart:convert';

// import 'package:cleanservice/models/pref_profile_model.dart';
// import 'package:cleanservice/network/uri_api.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class MonthlyTotalsChart extends StatefulWidget {
//   @override
//   _MonthlyTotalsChartState createState() => _MonthlyTotalsChartState();
// }

// class _MonthlyTotalsChartState extends State<MonthlyTotalsChart> {
//   List<Map<String, dynamic>> chartData = [];
//   late String chartType;

//   @override
//   void initState() {
//     super.initState();
//     chartType = 'bar'; // Loại biểu đồ mặc định
//     fetchData();
//   }

//   int? userid;

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> fetchData() async {
//     try {
//       final response = await http.post(
//         Uri.parse(BASEURL.test),
//         body: {'id_user': '5'},
//       );

//       if (mounted) {
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           setState(() {
//             chartData = List<Map<String, dynamic>>.from(data['data']);
//           });
//         } else {
//           print('Error: ${response.statusCode}');
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         print('Error fetching data: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Monthly Totals Chart'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             DropdownButton<String>(
//               value: chartType.isNotEmpty ? chartType : null,
//               onChanged: (value) {
//                 if (mounted) {
//                   setState(() {
//                     chartType = value!;
//                   });
//                 }
//               },
//               items: [
//                 'bar',
//                 'line',
//                 'pie',
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             Container(
//               height: 400,
//               child: _buildChart(),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: chartData.length,
//                 itemBuilder: (context, index) {
//                   final item = chartData[index];
//                   return ListTile(
//                     title: Text(
//                         'Tháng ${item['month_year']} tổng: ${item['total_revenue']}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChart() {
//     if (chartType == 'bar') {
//       return SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         series: <BarSeries<Map<String, dynamic>, String>>[
//           BarSeries<Map<String, dynamic>, String>(
//             dataSource: chartData,
//             xValueMapper: (Map<String, dynamic> data, _) =>
//                 data['month_year'].toString(),
//             yValueMapper: (Map<String, dynamic> data, _) =>
//                 data['total_revenue'],
//           ),
//         ],
//       );
//     } else if (chartType == 'line') {
//       return SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         series: <LineSeries<Map<String, dynamic>, String>>[
//           LineSeries<Map<String, dynamic>, String>(
//             dataSource: chartData,
//             xValueMapper: (Map<String, dynamic> data, _) =>
//                 data['month_year'].toString(),
//             yValueMapper: (Map<String, dynamic> data, _) =>
//                 data['total_revenue'],
//           ),
//         ],
//       );
//     } else if (chartType == 'pie') {
//       return SfCircularChart(
//         series: <PieSeries<Map<String, dynamic>, String>>[
//           PieSeries<Map<String, dynamic>, String>(
//             dataSource: chartData,
//             xValueMapper: (Map<String, dynamic> data, _) =>
//                 data['month_year'].toString(),
//             yValueMapper: (Map<String, dynamic> data, _) =>
//                 data['total_revenue'],
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
// }
import 'dart:convert';

import 'package:cleanservice/models/pref_profile_model.dart';
import 'package:cleanservice/network/uri_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyTotalsChart extends StatefulWidget {
  final String userID;

  MonthlyTotalsChart({
    required this.userID,
  });

  @override
  _MonthlyTotalsChartState createState() => _MonthlyTotalsChartState();
}

class _MonthlyTotalsChartState extends State<MonthlyTotalsChart> {
  List<Map<String, dynamic>> chartData = [];
  late String chartType;

  @override
  void initState() {
    super.initState();
    chartType = 'bar'; // Loại biểu đồ mặc định
    getPref().then((value) {
      fetchData(); // Gọi fetchData sau khi getPref hoàn thành
    });
  }

  void savePref(int idUser, String name, String email, String phone,
      String address, String createdAt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt(PreProfile.idUser, idUser);
    });
  }

  int? userid;

  @override
  void dispose() {
    super.dispose();
  }

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userid = sharedPreferences.getInt(PreProfile.idUser) ?? 0;
    });
    //print('id: $userid');
  }

  Future<void> fetchData() async {
    //print('User ID: $userid');
    try {
      final response = await http.post(
        Uri.parse(BASEURL.test),
        body: {'id_user': userid.toString()},
      );
      print("${response.body}");
      if (mounted) {
        if (response.statusCode == 200) {
          final dynamic data = json.decode(response.body);

          if (data['data'] is List) {
            setState(() {
              chartData = List<Map<String, dynamic>>.from(data['data']);
            });
          } else if (data['data'] is Map) {
            // Xử lý trường hợp trả về là một đối tượng
            setState(() {
              chartData = [data['data']];
            });
          } else {
            // Xử lý trường hợp khác (nếu có)
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Monthly Totals Chart'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: chartType.isNotEmpty ? chartType : null,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    chartType = value!;
                  });
                }
              },
              items: [
                'bar',
                'line',
                'pie',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
              height: 400,
              child: _buildChart(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  final item = chartData[index];
                  return ListTile(
                    title: Text(
                        'Tháng ${item['month_year']} tổng: ${item['total_revenue']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (chartType == 'bar') {
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <BarSeries<Map<String, dynamic>, String>>[
          BarSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, dynamic> data, _) =>
                data['month_year'].toString(),
            yValueMapper: (Map<String, dynamic> data, _) =>
                double.parse(data['total_revenue']),
          ),
        ],
      );
    } else if (chartType == 'line') {
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<Map<String, dynamic>, String>>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, dynamic> data, _) =>
                data['month_year'].toString(),
            yValueMapper: (Map<String, dynamic> data, _) =>
                double.parse(data['total_revenue']),
          ),
        ],
      );
    } else if (chartType == 'pie') {
      return SfCircularChart(
        series: <PieSeries<Map<String, dynamic>, String>>[
          PieSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, dynamic> data, _) =>
                data['month_year'].toString(),
            yValueMapper: (Map<String, dynamic> data, _) =>
                double.parse(data['total_revenue']),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
