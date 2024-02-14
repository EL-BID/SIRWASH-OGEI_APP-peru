import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
import 'cloro_residual_controller.dart';

class EncuestaCloroResidualPage extends StatelessWidget {
  final _conX = Get.put(EncuestaCloroResidualController());

  EncuestaCloroResidualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormMapWrapper(
      _conX.wrapperX,
      body: Column(
        children: [_buildPanelBody(context)],
      ),
    );
  }

  Widget _buildPanelBody(BuildContext context) {
    return GetBuilder<EncuestaCloroResidualController>(
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
                            getTituloTipoEncuesta(EncuestaKey.cloroResidual),
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
                                    return _ == null
                                        ? 'SAP es requerido'
                                        : null;
                                  },
                                )),

                            GetBuilder<EncuestaCloroResidualController>(
                                id: _conX.gbExtraInputs,
                                builder: (_) => _conX.isVisibleExtraInputs
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(height: 10.0),
                                          SvTextLabel(
                                            'Punto de tomas de medición',
                                            fontWeight: FontWeight.w600,
                                            fontSize: akFontSize + 2.0,
                                          ),
                                          //********* BEGIN:: RESERVORIO ********/
                                          const SizedBox(height: 25),
                                          const SvTextLabel(
                                            'Reservorio',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          /* SvInput(
                                            disabled: true,
                                            textLabel:
                                                'Fecha y Hora del muestreo',
                                            hint: 'Seleccione fecha',
                                            contr: _conX.reservorioFechaCtlr,
                                            keyboardType: TextInputType.number,
                                            showCursor: false,
                                            readOnly: true,
                                            maxLines: null,
                                            onTap: () async {
                                              final date = await Helpers
                                                  .showDateTimePicker(
                                                context,
                                                initialDate: _conX
                                                    .reservorioDateTime.value,
                                              );
                                              if (date != null) {
                                                _conX.reservorioDateTime.value =
                                                    date;
                                              }
                                            },
                                          ), */
                                          SvInput(
                                            textLabel:
                                                'Cloración Residual (mg/L)',
                                            hint: 'Ingrese valor',
                                            contr: _conX.reservorioValorCtlr,
                                            inputFormatters: [
                                              NumericalDoubleRangeFormatter(
                                                min: 0,
                                                max: 10,
                                                maxDecimals: 3,
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                          /* const SizedBox(height: 5),
                                          Obx(
                                            () => SvTextLabel(
                                              "Rango de valor. Entre 0.5 a 2",
                                              color:
                                                  _conX.reservorioInRange.value
                                                      ? Colors.green
                                                      : Colors.red,
                                              textAlign: TextAlign.center,
                                            ),
                                          ), */
                                          //********* END:: RESERVORIO ********/

                                          //********* BEGIN:: PRIMERA VIVIENDA ********/
                                          const SizedBox(height: 25),
                                          const SvTextLabel(
                                            'Primera vivienda',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          /* SvInput(
                                            disabled: true,
                                            textLabel:
                                                'Fecha y Hora del muestreo',
                                            hint: 'Seleccione fecha',
                                            contr:
                                                _conX.primeraViviendaFechaCtlr,
                                            keyboardType: TextInputType.number,
                                            showCursor: false,
                                            readOnly: true,
                                            maxLines: null,
                                            onTap: () async {
                                              final date = await Helpers
                                                  .showDateTimePicker(
                                                context,
                                                initialDate: _conX
                                                    .primeraViviendaDateTime
                                                    .value,
                                              );
                                              if (date != null) {
                                                _conX.primeraViviendaDateTime
                                                    .value = date;
                                              }
                                            },
                                          ), */
                                          SvInput(
                                            textLabel:
                                                'Cloración Residual (mg/L)',
                                            hint: 'Ingrese valor',
                                            contr:
                                                _conX.primeraViviendaValorCtlr,
                                            inputFormatters: [
                                              NumericalDoubleRangeFormatter(
                                                min: 0,
                                                max: 10,
                                                maxDecimals: 3,
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                          /* const SizedBox(height: 5),
                                          Obx(
                                            () => SvTextLabel(
                                              "Rango de valor. Entre 0.5 a 1.2",
                                              color: _conX
                                                      .primeraViviendaInRange
                                                      .value
                                                  ? Colors.green
                                                  : Colors.red,
                                              textAlign: TextAlign.center,
                                            ),
                                          ), */
                                          SvInput(
                                            textLabel: 'D.N.I del Titular',
                                            hint: 'Ingrese D.N.I',
                                            contr: _conX.primeraViviendaDniCtlr,
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                  mask: '########',
                                                  filter: {
                                                    "#": RegExp(r'[0-9]')
                                                  })
                                            ],
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (_) {
                                              if (_?.isNotEmpty ?? false) {
                                                if (_!.length < 8) {
                                                  return 'Mínimo 8 caracteres';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                          //********* END:: PRIMERA VIVIENDA ********/

                                          //********* BEGIN:: VIVIENDA INTERMEDIA ********/
                                          const SizedBox(height: 25),
                                          const SvTextLabel(
                                            'Vivienda intermedia',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          /* SvInput(
                                            disabled: true,
                                            textLabel:
                                                'Fecha y Hora del muestreo',
                                            hint: 'Seleccione fecha',
                                            contr: _conX
                                                .viviendaIntermediaFechaCtlr,
                                            keyboardType: TextInputType.number,
                                            showCursor: false,
                                            readOnly: true,
                                            maxLines: null,
                                            onTap: () async {
                                              final date = await Helpers
                                                  .showDateTimePicker(
                                                context,
                                                initialDate: _conX
                                                    .viviendaIntermediaDateTime
                                                    .value,
                                              );
                                              if (date != null) {
                                                _conX.viviendaIntermediaDateTime
                                                    .value = date;
                                              }
                                            },
                                          ), */
                                          SvInput(
                                            textLabel:
                                                'Cloración Residual (mg/L)',
                                            hint: 'Ingrese valor',
                                            contr: _conX
                                                .viviendaIntermediaValorCtlr,
                                            inputFormatters: [
                                              NumericalDoubleRangeFormatter(
                                                min: 0,
                                                max: 10,
                                                maxDecimals: 3,
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                          /* const SizedBox(height: 5),
                                          Obx(
                                            () => SvTextLabel(
                                              "Rango de valor. Entre 0.5 a 0.8",
                                              color: _conX
                                                      .viviendaIntermediaInRange
                                                      .value
                                                  ? Colors.green
                                                  : Colors.red,
                                              textAlign: TextAlign.center,
                                            ),
                                          ), */
                                          SvInput(
                                            textLabel: 'D.N.I del Titular',
                                            hint: 'Ingrese D.N.I',
                                            contr:
                                                _conX.viviendaIntermediaDniCtlr,
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                  mask: '########',
                                                  filter: {
                                                    "#": RegExp(r'[0-9]')
                                                  })
                                            ],
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (_) {
                                              if (_?.isNotEmpty ?? false) {
                                                if (_!.length < 8) {
                                                  return 'Mínimo 8 caracteres';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                          //********* END:: VIVIENDA INTERMEDIA ********/

                                          //********* BEGIN:: ÚLTIMA VIVIENDA ********/
                                          const SizedBox(height: 25),
                                          const SvTextLabel(
                                            'Última vivienda',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          /* SvInput(
                                            disabled: true,
                                            textLabel:
                                                'Fecha y Hora del muestreo',
                                            hint: 'Seleccione fecha',
                                            contr:
                                                _conX.ultimaViviendaFechaCtlr,
                                            keyboardType: TextInputType.number,
                                            showCursor: false,
                                            readOnly: true,
                                            maxLines: null,
                                            onTap: () async {
                                              final date = await Helpers
                                                  .showDateTimePicker(
                                                context,
                                                initialDate: _conX
                                                    .ultimaViviendaDateTime
                                                    .value,
                                              );
                                              if (date != null) {
                                                _conX.ultimaViviendaDateTime
                                                    .value = date;
                                              }
                                            },
                                          ), */
                                          SvInput(
                                            textLabel:
                                                'Cloración Residual (mg/L)',
                                            hint: 'Ingrese valor',
                                            contr:
                                                _conX.ultimaViviendaValorCtlr,
                                            inputFormatters: [
                                              NumericalDoubleRangeFormatter(
                                                min: 0,
                                                max: 10,
                                                maxDecimals: 3,
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                          /* const SizedBox(height: 5),
                                          Obx(
                                            () => SvTextLabel(
                                              "Rango de valor. Entre 0.5 a 0.7",
                                              color: _conX.ultimaViviendaInRange
                                                      .value
                                                  ? Colors.green
                                                  : Colors.red,
                                              textAlign: TextAlign.center,
                                            ),
                                          ), */
                                          SvInput(
                                            textLabel: 'D.N.I del Titular',
                                            hint: 'Ingrese D.N.I',
                                            contr: _conX.ultimaViviendaDniCtlr,
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                  mask: '########',
                                                  filter: {
                                                    "#": RegExp(r'[0-9]')
                                                  })
                                            ],
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (_) {
                                              if (_?.isNotEmpty ?? false) {
                                                if (_!.length < 8) {
                                                  return 'Mínimo 8 caracteres';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                          //********* END:: ÚLTIMA VIVIENDA ********/
                                        ],
                                      )
                                    : const SizedBox()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25.0),

                      // GESTOR DE IMÁGENES
                      GetBuilder<EncuestaCloroResidualController>(
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
              ));
        });
  }
}
