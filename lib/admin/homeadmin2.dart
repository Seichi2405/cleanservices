import 'package:flutter/material.dart';

class homeadmin2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'CLEAN SERVICE',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make text bold
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              Color.fromRGBO(101, 80, 157, 1.0), // Set background color
        ),
        body: Center(
          child: Text('CHÀO MỪNG ADMIN QUAY LẠI!!!'),
        ),
      ),
    );
  }
}
