import 'package:flutter/material.dart';

class quydoi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tích Điểm'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            width: 20,
          ),
          Table(
            border: TableBorder.all(width: 1.0, color: Colors.black),
            children: [
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Điểm tích lũy'),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Thu nhập đảm bảo'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('100 điểm'),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('350.000 đồng'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('200 điểm'),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(''),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('300 điểm'),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('820.000 đồng'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('400 điểm'),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text('900.000 đồng'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),

          Text('Thứ 2 - Thứ 6 ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          SizedBox(height: 20,),
          Text('Thứ 2 - Thứ 6', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('6h – 9h', style: TextStyle(fontSize: 20),),
                Text('4', style: TextStyle(fontSize: 20),),
              ],
            ),

          ),
          SizedBox(height: 20,),
          Text('*Lưu ý: Ngày lễ sẽ được x2 số điểm', style: TextStyle(fontSize: 20, color: Colors.red),),
        ],
      )
    );
  }
}

