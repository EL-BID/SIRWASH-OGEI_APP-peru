part of 'widgets.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final Color colorPrimary;
  final Color colorText;
  final void Function()? onTap;

  const BasicButton(
      {Key? key,
      required this.text,
      required this.colorPrimary,
      required this.colorText,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorPrimary,
        side: const BorderSide(width: 1.0, color: Colors.grey),
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: const Size(40, 45),
      ),
      onPressed: () {
        onTap?.call();
      },
      child: Text(text),
    );
  }
}
