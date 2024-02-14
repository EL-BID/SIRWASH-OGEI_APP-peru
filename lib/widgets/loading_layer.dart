part of 'widgets.dart';

class LoadingLayer extends StatelessWidget {
  final bool loading;
  final Color? bgColor;
  final String? text;

  const LoadingLayer(
    this.loading, {
    super.key,
    this.bgColor,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: loading
          ? SizedBox.expand(
              child: Container(
                alignment: Alignment.center,
                color: bgColor ?? Colors.white.withOpacity(.85),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LoadingIcon(),
                    const SizedBox(height: 20.0),
                    AkText(
                      text ?? 'Cargando...',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: akFontSize + 3.0,
                        color: akPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            )
          // Padding is neccesary for don't having 2 Sizedbox widgets
          // Animated switch requires differents widgets to apply effects
          : const Padding(padding: EdgeInsets.all(0.0), child: SizedBox()),
    );
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0XFF8D8B8B).withOpacity(.30),
            offset: const Offset(0, 7),
            blurRadius: 15.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Lottie.asset(
        'assets/lottie/loading_animation.json',
        width: Get.width * 0.20,
        fit: BoxFit.fill,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.strokeColor(
              ['LOADING', '**'],
              value: akPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
