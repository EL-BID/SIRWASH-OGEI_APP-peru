import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sirwash/themes/ak_ui.dart';

class UploadSlot extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets paddingWrap;
  final Radius dottedBorderRadius;
  final Color dottedBorderColor;
  final List<double> dashPattern;
  final double strokeWidth;
  final Color photoBackgroundColor;
  final File? file;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onPhotoTap;
  final bool readOnly;

  const UploadSlot({
    super.key,
    this.padding = const EdgeInsets.all(5.0),
    this.paddingWrap = const EdgeInsets.all(5.0),
    this.dottedBorderRadius = const Radius.circular(6),
    this.dottedBorderColor = const Color(0xFFCFCFCF),
    this.dashPattern = const <double>[6, 6],
    this.strokeWidth = 1.0,
    this.photoBackgroundColor = const Color(0xFFEDEDED),
    this.file,
    this.onRemoveTap,
    this.onAddTap,
    this.onPhotoTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        _elementImagePicker(),
        if (file != null && !readOnly) _deleteButton()
      ],
    );
  }

  Widget _deleteButton() {
    double _size = 22;
    return Positioned(
        right: 0.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            elevation: 4,
            color: akPrimaryColor, // button color
            child: InkWell(
              splashColor: akPrimaryColor, // inkwell color
              child: SizedBox(
                  width: _size,
                  height: _size,
                  child: const Icon(
                    Icons.clear,
                    size: 15,
                    color: Colors.white,
                  )),
              onTap: () {
                onRemoveTap?.call();
              },
            ),
          ),
        ));
  }

  Widget _elementImagePicker() {
    return Padding(
      padding: paddingWrap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: dottedBorderRadius,
        padding: padding,
        color: dottedBorderColor,
        dashPattern: dashPattern,
        strokeWidth: strokeWidth,
        child: GestureDetector(
          onTap: () {
            if (file != null) {
              onPhotoTap?.call();
            } else {
              if (!readOnly) {
                onAddTap?.call();
              }
            }
          },
          child: Container(
            color: photoBackgroundColor,
            width: double.infinity,
            height: double.infinity,
            child: _generateChild(),
          ),
        ),
      ),
    );
  }

  Widget _generateChild() {
    if (file != null) {
      return Image.file(file!, fit: BoxFit.cover);
    } else {
      return const Center(
        child: Icon(Icons.add, color: Color(0xFFB7B7B7)),
      );
    }
  }
}
