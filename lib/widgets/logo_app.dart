part of 'widgets.dart';

class LogoApp extends StatelessWidget {
  final double size;
  final bool whiteMode;

  LogoApp({this.size = 80, this.whiteMode = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      this.whiteMode ? 'assets/img/gota.png' : 'assets/img/gota.png',
      width: size,
    );
  }
}
