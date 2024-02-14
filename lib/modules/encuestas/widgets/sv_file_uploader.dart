import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirwash/config/config.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/modules/photo_zoom/photo_zoom_controller.dart';
import 'package:sirwash/routes/app_pages.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import 'photo_item.dart';

class SvFileUploader extends StatelessWidget {
  final List<PhotoFile> filesList;
  final void Function(XFile)? onFilePicked;
  final void Function(PhotoFile)? onRemoveTap;
  final bool isReadOnly;

  const SvFileUploader({
    super.key,
    required this.filesList,
    this.onFilePicked,
    this.onRemoveTap,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    List<UploadSlot> items = [];

    for (var i = 0; i < filesList.length; i++) {
      final photo = filesList[i];
      items.add(UploadSlot(
        readOnly: isReadOnly,
        file: photo.file,
        onRemoveTap: () async {
          final exitAppConfirm = await Helpers.confirmDialog(
            title: '¿Quitar imagen?',
            subTitle: 'La imagen se eliminará aunque no seleccione "Guardar"',
            yesText: 'Sí, eliminar',
            yesBackgroundColor: akRedColor,
            noText: 'No, cancelar',
          );

          if (exitAppConfirm ?? false) {
            onRemoveTap?.call(photo);
          }
        },
        onPhotoTap: () {
          Get.toNamed(
            AppRoutes.PHOTO_ZOOM,
            arguments: PhotoZoomArguments(
              file: photo.file,
            ),
          );
        },
      ));
    }

    // Número máximo de fotos
    if (filesList.length < 5) {
      items.add(UploadSlot(
        readOnly: isReadOnly,
        onAddTap: () {
          addPhotoToList();
        },
      ));
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      shrinkWrap: true,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      children: items,
    );
  }

  Future<void> addPhotoToList() async {
    try {
      final _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: Config.photoQuality,
        maxWidth: Config.photoMaxWidth,
        maxHeight: Config.photoMaxHeight,
      );
      if (pickedFile != null) {
        onFilePicked?.call(pickedFile);
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      AppSnackbar()
          .error(message: 'Hay un problema con el selector de imagenes');
    }
  }
}

// ignore: unused_element
class _ModalSelectSource extends StatelessWidget {
  const _ModalSelectSource();

  @override
  Widget build(BuildContext context) {
    const modalBgColor = Colors.white;
    final modalRadius = BorderRadius.circular(8.0);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: modalRadius,
                child: Container(
                  decoration: const BoxDecoration(
                    color: modalBgColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            SvgPicture.asset(
                              'assets/icons/maximize.svg',
                              width: Get.width * 0.25,
                            ),
                            const SizedBox(height: 20.0),
                            AkText(
                              'Agregar fotos',
                              style: TextStyle(
                                color: akPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: akFontSize + 1.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            AkText(
                              'Selecciona una foto de la galería o toma una nueva.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: akTextColor,
                                fontSize: akFontSize - 0.5,
                              ),
                            )
                          ],
                        ),
                      ),
                      _Option(
                        text: 'Hacer foto',
                        onTap: () {
                          Get.back(result: ImageSource.camera);
                        },
                      ),
                      const Divider(
                        color: Color(0xFFF3F3F3),
                        height: 1.0,
                        thickness: 1.0,
                      ),
                      _Option(
                        text: 'Elegir de la galería',
                        onTap: () {
                          Get.back(result: ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              _Option(
                text: 'Cancelar',
                textColor: const Color.fromARGB(255, 167, 42, 33),
                fontWeight: FontWeight.w600,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;

  const _Option(
      {required this.text, this.textColor, this.fontWeight, this.onTap});

  @override
  Widget build(BuildContext context) {
    const modalBgColor = Colors.white;
    final modalRadius = BorderRadius.circular(8.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: modalBgColor,
        borderRadius: modalRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: modalRadius,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
            child: AkText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Helpers.darken(akAccentColor, 0.05),
                fontWeight: fontWeight ?? FontWeight.w400,
                fontSize: akFontSize + 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
