part of 'widgets.dart';

class BasicDropdown extends StatelessWidget {
  final TextEditingController inputController;
  final String? hint;

  const BasicDropdown({required this.inputController, this.hint, super.key});

  @override
  Widget build(BuildContext context) {
    return AkInput(
      controller: inputController,
      suffixIcon: const Icon(Icons.unfold_more_rounded),
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: hint ?? 'Seleccione',
      labelColor: akTextColor.withOpacity(0.35),
      readOnly: true,
      showCursor: false,
      onTap: () async {
        // if (_conX.loading.value) return;
        // if (arrayController.isEmpty) {
        //   Helpers.snackbar(
        //       message: 'No hay elementos que mostrar',
        //       variant: SnackBarVariant.info);
        //   return;
        // }

        // final resp = await _showOptions(arrayController);
        // if (resp != null) {
        //   _conX.setSelectedPuntoMuestra(nameController, resp);
        // } else {
        //   print('No hubo selección: $resp');
        // }
        print('vamos');
      },
    );
  }

  Future<dynamic> _showOptions(List<dynamic> items) async {
    List<Widget> options = [];
    for (var item in items) {
      String _text = item['description'];
      options.add(Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () => Get.back(result: item),
          highlightColor: Colors.transparent,
          splashColor: akPrimaryColor,
          child: ListTile(
            title: Row(
              children: [
                // item is SaCcpp
                //     ? Container(
                //         width: 10.0,
                //         height: akFontSize + 6.0,
                //         decoration: BoxDecoration(
                //           color: Color(int.parse('0xFF' + item.description)),
                //           borderRadius: BorderRadius.circular(2.5),
                //         ),
                //       )
                //     : const SizedBox(),
                // item is SaCcpp ? const SizedBox(width: 7.0) : const SizedBox(),
                Expanded(
                  child: AkText(_text),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    final ScrollController controller = ScrollController();

    final resp = await Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            width: 1000.0,
            constraints:
                const BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(akRadiusGeneral)),
            child: Theme(
              data: Theme.of(Get.context!).copyWith(
                highlightColor: akPrimaryColor,
              ),
              child: Scrollbar(
                radius: const Radius.circular(30.0),
                thickness: 5.0,
                thumbVisibility: true,
                controller: controller,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (c, idx) {
                    return options[idx];
                  },
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.35));
    return resp;
  }
}
