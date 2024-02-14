import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sirwash/themes/ak_ui.dart';

import 'sv_text_label.dart';

class SvInput extends StatelessWidget {
  final String? textLabel;
  final String hint;
  final TextEditingController? contr;
  final TextInputType keyboardType;
  final bool showCursor;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String? value)? validator;
  final bool disabled;

  const SvInput({
    super.key,
    this.textLabel,
    required this.hint,
    this.contr,
    this.keyboardType = TextInputType.text,
    this.showCursor = true,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.inputFormatters,
    this.autovalidateMode,
    this.validator,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                if (textLabel != null)
                  SizedBox(
                    width: 100,
                    child: SvTextLabel(
                      textLabel!,
                      color: akPrimaryColor.withOpacity(0.75),
                      textAlign: TextAlign.left,
                    ),
                  ),
                if (textLabel != null)
                  const SizedBox(
                    height: 50,
                    width: 20,
                  ),
                Expanded(
                  flex: 4,
                  child: IgnorePointer(
                    ignoring: disabled,
                    child: TextFormField(
                      keyboardType: keyboardType,
                      controller: contr,
                      showCursor: showCursor,
                      readOnly: readOnly,
                      onTap: onTap,
                      maxLines: maxLines,
                      inputFormatters: inputFormatters,
                      style: TextStyle(
                        color: disabled
                            ? akPrimaryColor.withOpacity(0.6)
                            : akPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black26,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: akPrimaryColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: akErrorColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: akErrorColor,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        fillColor: Colors.white,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(
                            .25,
                          ),
                        ),
                      ),
                      autovalidateMode: autovalidateMode,
                      validator: validator,
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
