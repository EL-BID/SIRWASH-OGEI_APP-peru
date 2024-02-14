// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/modules/encuestas/widgets/forms_buttons.dart';
import 'package:sirwash/modules/form_map_wrapper/form_map_wrapper.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import '../widgets/multi_uploader.dart';
import '../widgets/sv_input.dart';
import '../widgets/sv_text_label.dart';
import 'cloracion_controller.dart';

class EncuestaCloracionPage extends StatelessWidget {
  final _conX = Get.put(EncuestaCloracionController());

  EncuestaCloracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormMapWrapper(
      _conX.wrapperX,
      body: Column(
        children: [_buildPanelBody()],
      ),
    );
  }

  Widget _buildPanelBody() {
    return GetBuilder<EncuestaCloracionController>(
        id: _conX.gbBody,
        builder: (_) {
          return IgnorePointer(
            ignoring: _conX.loadingForm,
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Form(
                key: _conX.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: SvTextLabel(
                          getTituloTipoEncuesta(EncuestaKey.cloracion),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 20.0),

                    IgnorePointer(
                      ignoring: _conX.isReadOnly,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Centro Poblado
                          Obx(() => SearchDropdown<CentroPoblado>(
                                dropDownKey: _conX.centroPobladoDropdownKey,
                                label:
                                    'Centro poblado. Donde se realiza la actividad',
                                items: _conX.listCentrosPoblados,
                                itemAsString: (i) => i.alias,
                                filterFn: (i, t) =>
                                    Helpers.filterInCentroPoblado(i, t),
                                onChanged: _conX.setCentroPobladoSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                addRequiredBadge: true,
                                isLoading: _conX.loadingCentroList.value,
                                validator: (_) {
                                  return _ == null
                                      ? 'Centro poblado es requerido'
                                      : null;
                                },
                              )),

                          // SAP
                          Obx(() => SearchDropdown<Sap>(
                                dropDownKey: _conX.sapDropdownKey,
                                label: 'SAP (sistema de agua potable)',
                                items: _conX.listSap,
                                itemAsString: (i) => i.alias,
                                filterFn: (i, t) => Helpers.filterInSap(i, t),
                                onChanged: _conX.setSAPSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                addRequiredBadge: true,
                                isLoading: _conX.loadingSapList.value,
                                validator: (_) {
                                  return _ == null ? 'SAP es requerido' : null;
                                },
                              )),

                          // Componente
                          Obx(() => SearchDropdown<Componente>(
                                showSearchBox: false,
                                dropDownKey: _conX.componenteDropdownKey,
                                label: 'Componente (donde clora)',
                                items: _conX.listComponentes,
                                itemAsString: (i) => i.alias,
                                onChanged: _conX.setComponenteSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isLoading: _conX.loadingComponentesList.value,
                              )),

                          // Insumo
                          Obx(() => SearchDropdown<Insumo>(
                                showSearchBox: false,
                                dropDownKey: _conX.insumoDropdownKey,
                                label: 'Insumo',
                                items: _conX.listInsumos,
                                itemAsString: (i) => i.alias,
                                onChanged: _conX.setInsumoSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isLoading: _conX.loadingInsumosList.value,
                              )),

                          const SizedBox(height: 10.0),

                          GetBuilder<EncuestaCloracionController>(
                            id: _conX.gbExtraInputs,
                            builder: (_) => _ExtraInputs(_conX),
                          ),

                          const SizedBox(height: 15.0),
                          Obx(() => _CalibracionSistema(
                                value: _conX.selectedCalibracion.value,
                                onChanged: _conX.setCalibracionSelected,
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25.0),

                    // GESTOR DE IMÁGENES
                    GetBuilder<EncuestaCloracionController>(
                      id: _conX.gbPhotos,
                      builder: (_) => MultiUploader(
                        isReadOnly: _conX.isReadOnly,
                        tiposImagen: _conX.tiposImagen,
                        photos: _conX.photos,
                        onFilePicked: _conX.onFilePicked,
                        onRemoveFileTap: _conX.onRemoveFileTap,
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    _conX.isReadOnly
                        ? FormsReturnButtons(
                            isLoading: _conX.loadingForm,
                            onReturnTap: _conX.onCancelButtonTap,
                          )
                        : FormsSaveButtons(
                            isLoading: _conX.loadingForm,
                            onCancelTap: _conX.onCancelButtonTap,
                            onSubmitTap: _conX.onSubmit,
                          ),
                    const SizedBox(height: 15.0)
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _ExtraInputs extends StatelessWidget {
  final EncuestaCloracionController _conX;

  const _ExtraInputs(
    this._conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_conX.extraInputsSelected) {
      case InsumoExtraInputs.gas:
        return SearchDropdown<MedidaGas>(
          dropDownKey: _conX.gasDropdownKey,
          hint: 'Seleccione valor (kg)',
          showSearchBox: false,
          items: _conX.listGas,
          itemAsString: (i) => i.nombre,
          onChanged: _conX.setGasSelected,
        );
      case InsumoExtraInputs.tableta:
        return Column(
          children: [
            SvInput(
              hint: 'Ingrese valor (unidad)',
              contr: _conX.valorInsumoCtlr,
              inputFormatters: [
                NumericalDoubleRangeFormatter(
                  min: 0,
                  max: 5,
                )
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
          ],
        );
      case InsumoExtraInputs.hipoCalcio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvInput(
              hint: 'Ingrese valor (kg)',
              contr: _conX.valorInsumoCtlr,
              inputFormatters: [
                NumericalDoubleRangeFormatter(
                  min: 0,
                  max: 5,
                )
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 5),
            /* Obx(
              () => SvTextLabel(
                "Rango de valor. Entre 0.5 a 5.5 (kg)",
                color: _conX.valorHipocalcioInRange.value
                    ? Colors.green
                    : Colors.red,
                textAlign: TextAlign.center,
              ),
            ), */
            const SizedBox(height: 10),
            const SvTextLabel(
              'Solución madre',
            ),
            SvInput(
              hint: 'Ingrese valor (L)',
              contr: _conX.solucionMadreCtlr,
              inputFormatters: [
                NumericalDoubleRangeFormatter(
                  min: 0,
                  max: 1000,
                  maxDecimals: 3,
                )
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 5),
            /* Obx(
              () => SvTextLabel(
                "Rango de valor. Entre 0.5 a 5.5 (kg)",
                color: _conX.solucionMadreInRange.value
                    ? Colors.green
                    : Colors.red,
                textAlign: TextAlign.center,
              ),
            ) */
          ],
        );
      case InsumoExtraInputs.hipoSodio:
        return SearchDropdown<MedidaHipocloritos>(
          dropDownKey: _conX.hipoSodioDropdownKey,
          hint: 'Seleccione valor (litro)',
          showSearchBox: false,
          items: _conX.listHipocloritoSodio,
          itemAsString: (i) => i.nombre,
          onChanged: _conX.setHipocloritoSodioSelected,
        );
      case InsumoExtraInputs.briqueta:
        return SearchDropdown<MedidaBriqueta>(
          dropDownKey: _conX.briquetaDropdownKey,
          hint: 'Seleccione valor (kg)',
          showSearchBox: false,
          items: _conX.listBriquetas,
          itemAsString: (i) => i.nombre,
          onChanged: _conX.setBriquetaSelected,
        );

      default:
        return const SizedBox();
    }
  }
}

class _CalibracionSistema extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;

  const _CalibracionSistema({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: value,
          activeColor: akPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          onChanged: onChanged,
        ),
        const Expanded(
            child: AkText('Se calibró el sistema de cloración (opcional)')),
      ],
    );
  }
}
