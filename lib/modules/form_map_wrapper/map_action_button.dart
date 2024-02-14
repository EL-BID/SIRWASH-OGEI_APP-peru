part of 'form_map_wrapper.dart';

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _MapActionButton({required this.icon, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            color: akPrimaryColor,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(maxWidth: 80.0, maxHeight: 80.0),
            icon: Icon(
              icon,
              size: akFontSize + 6.0,
            ),
            color: Colors.white,
            onPressed: () {
              onTap?.call();
            },
          ),
        ),
      ),
    );
  }
}
