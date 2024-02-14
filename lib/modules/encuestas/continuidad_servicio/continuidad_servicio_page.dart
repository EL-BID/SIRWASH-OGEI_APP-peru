import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/constants/constants.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import '../../form_map_wrapper/form_map_wrapper.dart';
import '../widgets/forms_buttons.dart';
import '../widgets/multi_uploader.dart';
import '../widgets/sv_input.dart';
import '../widgets/sv_text_label.dart';
import 'continuidad_servicio_controller.dart';

class EncuestaContinuidadServicioPage extends StatelessWidget {
  final _conX = Get.put(EncuestaContinuidadServicioController());

  EncuestaContinuidadServicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormMapWrapper(
      _conX.wrapperX,
      body: Column(
        children: [_buildPanelBody(context)],
      ),
    );
  }

  Widget _buildPanelBody(context) {
    return GetBuilder<EncuestaContinuidadServicioController>(
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
                          getTituloTipoEncuesta(
                              EncuestaKey.continuidadServicio),
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

                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Expanded(
                                child: SvTextLabel(
                                  'Días a la semana de servicio / horas de servicio:',
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),

                          // Frecuencia
                          Obx(() => SearchDropdown<Frecuencia>(
                                showSearchBox: false,
                                dropDownKey: _conX.frecuenciaDropdownKey,
                                hint: 'Días de la semana',
                                items: _conX.listFrecuencias,
                                itemAsString: (i) => i.nombre,
                                onChanged: _conX.setFrecuenciaSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isLoading: _conX.loadingFrecuenciaList.value,
                              )),

                          // Horas
                          Obx(() => SearchDropdown<Hora>(
                                showSearchBox: false,
                                dropDownKey: _conX.horaDropdownKey,
                                hint: 'Horas de servicio',
                                items: _conX.listHoras,
                                itemAsString: (i) => i.nombre,
                                onChanged: _conX.setHoraSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isLoading: _conX.loadingHoraList.value,
                              )),

                          const SizedBox(height: 10.0),

                          // Caudales
                          Obx(() => SearchDropdown<CaudalAgua>(
                                showSearchBox: false,
                                dropDownKey: _conX.caudalAguaDropdownKey,
                                label: 'Cálculo de caudal (litros)',
                                hint: 'Seleccione balde (litros)',
                                items: _conX.listCaudalAgua,
                                itemAsString: (i) => i.nombre,
                                onChanged: _conX.setCaudalAguaSelected,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isLoading: _conX.loadingCaudalList.value,
                              )),

                          GetBuilder<EncuestaContinuidadServicioController>(
                              id: _conX.gbExtraInputs,
                              builder: (_) => _conX.isVisibleExtraInputs
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SvInput(
                                          textLabel: 'Tiempo 1 (s)',
                                          hint: 'Ingrese valor',
                                          contr: _conX.tiempo1Ctlr,
                                          inputFormatters: [
                                            NumericalDoubleRangeFormatter(
                                              min: 0,
                                              max: 1000,
                                              maxDecimals: 3,
                                            )
                                          ],
                                          keyboardType: TextInputType.number,
                                        ),
                                        SvInput(
                                          textLabel: 'Tiempo 2 (s)',
                                          hint: 'Ingrese valor',
                                          contr: _conX.tiempo2Ctlr,
                                          inputFormatters: [
                                            NumericalDoubleRangeFormatter(
                                              min: 0,
                                              max: 1000,
                                              maxDecimals: 3,
                                            )
                                          ],
                                          keyboardType: TextInputType.number,
                                        ),
                                        SvInput(
                                          textLabel: 'Tiempo 3 (s)',
                                          hint: 'Ingrese valor',
                                          contr: _conX.tiempo3Ctlr,
                                          inputFormatters: [
                                            NumericalDoubleRangeFormatter(
                                              min: 0,
                                              max: 1000,
                                              maxDecimals: 3,
                                            )
                                          ],
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 10.0),
                                        SvTextLabel(
                                          'litros / segundos (l/s)',
                                          color:
                                              akPrimaryColor.withOpacity(.45),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 15.0),
                                        Obx(() => SvTextLabel(
                                              'Promedio   ${_conX.resultadoPromedio.value.toStringAsFixed(2)}   l/s',
                                              color: akPrimaryColor
                                                  .withOpacity(.75),
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontSize: akFontSize + 1.0,
                                            )),
                                      ],
                                    )
                                  : const SizedBox()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25.0),

                    // GESTOR DE IMÁGENES
                    GetBuilder<EncuestaContinuidadServicioController>(
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
