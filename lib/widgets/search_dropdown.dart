part of 'widgets.dart';

class SearchDropdown<T> extends StatelessWidget {
  final Key? dropDownKey;
  final String? label;
  final String? hint;
  final bool isLoading;
  final List<T> items;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final bool Function(T, String)? filterFn;
  final String Function(T)? itemAsString;
  final bool showSearchBox;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<T>? validator;
  final bool addRequiredBadge;

  const SearchDropdown(
      {this.dropDownKey,
      this.label,
      this.hint,
      this.isLoading = false,
      this.items = const [],
      this.selectedItem,
      this.onChanged,
      this.filterFn,
      this.itemAsString,
      this.showSearchBox = true,
      this.autovalidateMode,
      this.validator,
      this.addRequiredBadge = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            RichText(
              text: TextSpan(
                  text: label!,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: akTitleColor,
                    fontSize: akFontSize,
                    fontFamily: akDefaultFontFamily,
                  ),
                  children: [
                    if (addRequiredBadge)
                      const TextSpan(
                          text: ' *', style: TextStyle(color: Colors.red))
                  ]),
              textAlign: TextAlign.left,
            ),
          DropdownSearch<T>(
            key: dropDownKey,
            items: items,
            onChanged: onChanged,
            filterFn: filterFn,
            selectedItem: selectedItem,
            popupProps: PopupPropsMultiSelection.dialog(
              fit: FlexFit.loose,
              showSearchBox: showSearchBox,
              searchFieldProps: TextFieldProps(
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: Helpers.generateHashLetter(30),
                    type: MaskAutoCompletionType.eager,
                    filter: {
                      "#": RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s0-9]+$'),
                    },
                  )
                ],
                decoration: InputDecoration(
                  hintText: hint ?? 'Buscar',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: akPrimaryColor.withOpacity(.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(),
                ),
              ),
              emptyBuilder: (context, searchEntry) => const Center(
                child: Text(
                  'No se encontraron resultados',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            dropdownButtonProps: DropdownButtonProps(
              icon: isLoading
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: akPrimaryColor.withOpacity(
                          .45,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28.0,
                      color: akPrimaryColor.withOpacity(
                        .45,
                      ),
                    ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: hint ?? 'Seleccione',
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: akPrimaryColor),
                ),
              ),
            ),
            itemAsString: itemAsString,
            validator: validator,
            autoValidateMode: autovalidateMode,
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
