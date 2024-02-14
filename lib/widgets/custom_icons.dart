part of 'widgets.dart';

class SpinLoadingIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const SpinLoadingIcon(
      {this.color = Colors.white, this.size = 30.0, this.strokeWidth = 2.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.size,
      width: this.size,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(this.color),
      ),
    );
  }
}

class CIconFolder extends StatelessWidget {
  final double size;
  final Color? color1;
  final Color? color2;

  const CIconFolder({this.size = 100.0, this.color1, this.color2});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/icons/folder_document.svg',
          color: color1 ?? akPrimaryColor,
          width: size,
        ),
        Positioned(
          top: size * 0.44,
          left: size * 0.15,
          child: SvgPicture.asset(
            'assets/icons/folder_document_alt.svg',
            color: color2 ?? akAccentColor,
            width: size * 0.19,
          ),
        ),
      ],
    );
  }
}
