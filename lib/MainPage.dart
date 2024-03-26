import 'package:flutter/material.dart';
import 'package:cleanservice/ColorScheme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _mainPageState();
}

class _mainPageState extends State<MainPage> {
  String selectedType ="Initial";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      appBar: AppBar(
        title: Text("Your Plan", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
              child:Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text("Selected Cleaning", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width*0.43,
                                decoration: BoxDecoration(
                                  color: Color(0xffdfdeff),
                                  image: DecorationImage(
                                    image: AssetImage('asset/image/img1.png'),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Initial Cleaning", style: TextStyle(
                                fontWeight: FontWeight.w600
                              ),),
                              SizedBox(height: 10,),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffededed),
                                ),
                                child: (selectedType =='Initial')?Icon(Icons.check_circle,
                                color: pink,
                                size: 30,):Container(),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ) )
        ],
      ),
    );
  }
}

