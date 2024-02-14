import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/modules/encuestas/widgets/sv_file_uploader.dart';
import 'package:sirwash/themes/ak_ui.dart';

class MultiUploader extends StatelessWidget {
  final List<TipoImagen> tiposImagen;
  final List<PhotoFile> photos;
  final void Function(XFile image, int tipoImagenId)? onFilePicked;
  final void Function(PhotoFile photo)? onRemoveFileTap;
  final bool isReadOnly;

  const MultiUploader({
    super.key,
    required this.tiposImagen,
    required this.photos,
    this.onFilePicked,
    this.onRemoveFileTap,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...tiposImagen
            .map((tipo) => Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 2.0),
                        Icon(
                          Icons.camera_alt,
                          color: akPrimaryColor.withOpacity(.20),
                          size: akFontSize + 5.0,
                        ),
                        const SizedBox(width: 6.0),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: RichText(
                              text: TextSpan(
                                  text: tipo.nombre,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: akTitleColor,
                                    fontSize: akFontSize,
                                    fontFamily: akDefaultFontFamily,
                                  ),
                                  children: [
                                    if (tipo.requerido)
                                      const TextSpan(
                                        text: ' *',
                                        style: TextStyle(color: Colors.red),
                                      )
                                  ]),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    SvFileUploader(
                      filesList: photos
                          .where((p) => p.tipoImagenId == tipo.tipoImagenesId)
                          .toList(),
                      onFilePicked: (file) {
                        onFilePicked?.call(
                          file,
                          tipo.tipoImagenesId,
                        );
                      },
                      onRemoveTap: onRemoveFileTap,
                      isReadOnly: isReadOnly,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ))
            .toList()
      ],
    );
  }
}
