import 'package:flutter/material.dart';

class CardService extends StatelessWidget {
  final String idService;
  final String imageService;
  final String nameService;
  final String priceService;
  CardService(
      {this.idService = '',
      this.imageService = '',
      this.nameService = '',
      this.priceService = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imageService,
          width: 50,
        ),
        SizedBox(
          height: 5,
        ),
        Text(nameService),
        Text(priceService),
      ],
    );
  }
}
