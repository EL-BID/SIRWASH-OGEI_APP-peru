part of 'widgets.dart';

class FileAttachButton extends StatelessWidget {
  final String title;
  final String label1;
  final String label2;
  final void Function()? onCameraTap;
  final void Function()? onGalleryTap;
  final void Function()? onFileTap;
  const FileAttachButton(
      {Key? key,
      this.title = '',
      this.onCameraTap,
      this.onGalleryTap,
      this.onFileTap,
      this.label1 = '',
      this.label2 = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        top: 8.0,
      ),
      child: Column(
        children: [
          Row(children: [
            AkText(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: akTitleColor,
                fontSize: akFontSize - 1.0,
              ),
            )
          ]),
          const SizedBox(height: 10.0),
          Row(children: [
            Column(children: [
              AkText(
                label1 != '' ? '•' : '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: akTitleColor,
                  fontSize: akFontSize - 1.0,
                ),
              ),
            ]),
            const SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: AkText(
                label1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: akTitleColor,
                  fontSize: akFontSize - 1.0,
                ),
              ),
            ),
          ]),
          label2 != '' ? const SizedBox(height: 10.0) : const SizedBox(),
          Row(children: [
            Column(children: [
              AkText(
                label2 != '' ? '•' : '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: akTitleColor,
                  fontSize: akFontSize - 1.0,
                ),
              ),
            ]),
            const SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: AkText(
                label2,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: akTitleColor,
                  fontSize: akFontSize - 1.0,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10.0),
          /* boton tomar foto */
          Center(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                final resp = await Get.dialog(
                    AlertDialog(
                      contentPadding: const EdgeInsets.all(0.0),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      content: Container(
                        width: 1000.0,
                        constraints: const BoxConstraints(
                            minHeight: 10.0, maxHeight: 300.0),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(akRadiusGeneral)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AkText('Seleccione:'),
                            const SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 8, 8, 8),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.grey),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 60,
                                        45),
                                  ),
                                  onPressed: () {
                                    Get.back(result: 1);
                                  },
                                  child: const Text('Cámara'),
                                )),
                              ],
                            ),
                          /*   const SizedBox(width: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.grey),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 60,
                                        45),
                                  ),
                                  onPressed: () {
                                    Get.back(result: 2);
                                  },
                                  child: const Text('Galeria'),
                                )),
                              ],
                            ),
                            const SizedBox(width: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.grey),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width - 60,
                                        45),
                                  ),
                                  onPressed: () {
                                    Get.back(result: 3);
                                  },
                                  child: const Text('Archivo'),
                                )),
                              ],
                            ), */
                          ],
                        ),
                      ),
                    ),
                    barrierColor: Colors.black.withOpacity(0.35));

                if (resp == 1) {
                  onCameraTap?.call();
                } else if (resp == 2) {
                  onGalleryTap?.call();
                } else if (resp == 3) {
                  onFileTap?.call();
                }
              },
              icon: const Icon(
                Icons.camera_enhance_rounded,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: const Text(
                "Tomar foto",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                side: const BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
          )),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
