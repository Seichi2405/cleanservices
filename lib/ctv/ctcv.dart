import 'package:flutter/material.dart';
import '../ctv/mainctv.dart';
import '../models/service_model.dart';

class CTCV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin công việc'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => doanhthu(
                  serviceModel: ServiceModel(
                    idservice: '',
                    name: '',
                    description: '',
                    image: '',
                    price: '',
                    status: '',
                    createdat: '',
                  ),
                  nameService: '',
                  priceService: '',
                  idService: '',
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Công việc: Dọn dẹp nhà',
              style: TextStyle(fontSize: 22),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kích thước phòng',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  '< 55m2',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
