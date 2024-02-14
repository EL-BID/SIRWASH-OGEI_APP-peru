import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/widgets/widgets.dart';

class DownloadingMapLayer extends StatelessWidget {
  final VoidCallback onCancelTap;
  final RxnDouble percentDownload;
  final RxString sizeDownloadedText;

  const DownloadingMapLayer(
      {required this.onCancelTap,
      required this.percentDownload,
      required this.sizeDownloadedText,
      super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17.0);

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: akPrimaryColor.withOpacity(.85),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Descargando mapa...',
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              const SizedBox(height: 12.0),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 200.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Obx(
                    () => LinearProgressIndicator(
                      color: Color(0xFF216add),
                      backgroundColor: Color(0xFFBAB9BB),
                      minHeight: 8.0,
                      value: percentDownload.value ?? 0.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Obx(() => Text(
                    sizeDownloadedText.value,
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                        fontSize: 14.0,
                        color: const Color.fromARGB(255, 205, 205, 205)),
                  )),
              const SizedBox(height: 20.0),
              BasicButton(
                text: 'Cancelar descarga',
                colorPrimary: const Color.fromARGB(255, 255, 255, 255),
                colorText: akPrimaryColor,
                onTap: onCancelTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
