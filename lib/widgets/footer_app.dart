import 'package:flutter/material.dart';

class FooterApp extends StatelessWidget {
  final double size;
  final double height;
  final bool whiteMode;


  FooterApp({this.size = 80, this.whiteMode = false , this.height: 400});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      this.whiteMode
          ? 'assets/img/salpicadura.jpg'
          : 'assets/img/salpicadura.jpg',
      width: size,
      height: height,
    );
  }
}
