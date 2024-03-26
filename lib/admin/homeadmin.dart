import 'package:flutter/material.dart';
import 'homeadmin2.dart'; // Thay đổi tên file nếu cần
import 'CTVadmin.dart';
import 'ChuyenDoi.dart';
import 'DatLichAdmin.dart';
import 'DichVuAdmin.dart';
import 'KHadmin.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    homeadmin2(),
    CustomerInforPage(),
    CTVadminPage(),
    AppointmentAdminPage(),
    ChuyenDoi(),
    AddServicePage(),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue, // Màu sắc khi mục được chọn
        unselectedItemColor: Colors.grey, // Màu sắc khi mục không được chọn
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Thay đổi biểu tượng cho Trang chủ
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Khách Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Cộng Tác Viên',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Đặt Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: 'Chuyển Đổi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Thêm Dịch Vụ',
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}