import 'package:flutter/material.dart';
import 'package:sirwash/themes/ak_ui.dart';

class SvTextLabel extends StatelessWidget {
  final String txt;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final double? fontSize;

  const SvTextLabel(
    this.txt, {
    this.color,
    super.key,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AkText(
      txt,
      style: TextStyle(
        fontWeight: fontWeight,
        color: color ?? akPrimaryColor,
        fontSize: fontSize ?? akFontSize,
      ),
      textAlign: textAlign,
    );
  }
}
