import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cleanservice/customer/main3.dart';
import 'main2.dart';

class danhgia extends StatelessWidget {
  //const danhgia({super.key});
  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 112 * fem,
              decoration: BoxDecoration(
                color: Color(0x8efff0c9),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(22 * fem),
                  bottomLeft: Radius.circular(40 * fem),
                ),
              ),
              child: Center(
                child: Text(
                  'Đánh giá ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2125 * ffem / fem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 2 * fem, 0 * fem),
              padding:
                  EdgeInsets.fromLTRB(7.5 * fem, 16 * fem, 7.5 * fem, 43 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 30 * fem, 25 * fem),
                    child: Text(
                      'Đánh giá nhân viên',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // CircleAvatar(
                  //   radius: 85 * fem,
                  //   backgroundImage: AssetImage(
                  //       'https://th.bing.com/th/id/OIP.yPT5uxyIE0U1rFL_2M5h2QHaHa?pid=ImgDet&w=900&h=900&rs=1'),
                  // ),
                  SizedBox(height: 35 * fem),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'viết Ghi chú',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPageAC()),
                          );
                        },
                        child: Text('Hủy'),
                      ),
                      SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút Gửi
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Đã gửi.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainPageAC(),
                                        ),
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Gửi'),
                      )
                    ],
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
