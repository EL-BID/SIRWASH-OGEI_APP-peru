import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/modules/encuestas/widgets/forms_buttons.dart';
import 'package:sirwash/modules/encuestas/widgets/sv_input.dart';
import 'package:sirwash/modules/encuestas/widgets/sv_text_label.dart';
import 'package:sirwash/modules/form_map_wrapper/form_map_wrapper.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import '../widgets/multi_uploader.dart';
import 'componente_sap_controller.dart';

class EncuestaComponenteSapPage extends StatelessWidget {
  final _conX = Get.put(EncuestaComponenteSapController());

  EncuestaComponenteSapPage({super.key});

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
    return GetBuilder<EncuestaComponenteSapController>(
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
                          getTituloTipoEncuesta(EncuestaKey.componenteSap),
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

                          // Prestador
                          if (_conX.listPrestadores.isNotEmpty)
                            Obx(() => SearchDropdown<Prestador>(
                                  dropDownKey: _conX.prestadorDropdownKey,
                                  label: 'Prestador',
                                  items: _conX.listPrestadores,
                                  itemAsString: (i) => i.alias,
                                  filterFn: (i, t) =>
                                      Helpers.filterInPrestador(i, t),
                                  onChanged: _conX.setPrestadorSelected,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  isLoading: _conX.loadingPrestadorList.value,
                                )),

                          // Hipoclorito de Calcio
                          const SizedBox(height: 15.0),
                          const SvTextLabel(
                            '¿Cuál es la cantidad de Hipoclorito de Calcio utilizado? (En Kilogramos)',
                          ),
                          SvInput(
                            hint: 'Ingrese hipoclorito de calcio',
                            contr: _conX.calcloradaCtlr,
                            inputFormatters: [
                              NumericalDoubleRangeFormatter(
                                min: 0,
                                max: 1000,
                                maxDecimals: 3,
                              )
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          /* const SizedBox(height: 5),
                          Obx(
                            () => SvTextLabel(
                              "Rango de valor. Entre 0.5 a 4 kg",
                              color: _conX.hipocloritoInRange.value
                                  ? Colors.green
                                  : Colors.red,
                              textAlign: TextAlign.center,
                            ),
                          ), */
                        ],
                      ),
                    ),

                    const SizedBox(height: 25.0),

                    // GESTOR DE IMÁGENES
                    GetBuilder<EncuestaComponenteSapController>(
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
