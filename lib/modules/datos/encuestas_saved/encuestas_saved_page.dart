import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sirwash/modules/datos/encuestas_saved/encuestas_saved_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sirwash/widgets/widgets.dart';

import 'selectable_entity.dart';

// ignore: use_key_in_widget_constructors
class EncuestasSavedPage extends StatelessWidget {
  final _conX = Get.put(EncuestasSavedController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EncuestasSavedController>(
        id: _conX.gbScaffold,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => await _conX.handleBack(),
              child: Scaffold(
                backgroundColor: akScaffoldBackgroundColor,
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  title: const Text(
                    "Lista de datos de encuestas",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: GestureDetector(
                    onTap: _conX.onArrowBackTap,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: akPrimaryColor,
                  actions: [
                    PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) {
                          return [
                            if (!_conX.isSentViewMode) ...[
                              PopupMenuItem<int>(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.send),
                                    SizedBox(width: 6.0),
                                    Text("Enviar")
                                  ],
                                ),
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  _conX.onActionSendTap();
                                },
                              ),
                              PopupMenuItem<int>(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.check_box_outlined),
                                    SizedBox(width: 6.0),
                                    Text("Seleccionar todo")
                                  ],
                                ),
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _conX.onActionSelectAllTap();
                                },
                              ),
                              PopupMenuItem<int>(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.check_box_outline_blank_rounded),
                                    SizedBox(width: 6.0),
                                    Text("Deseleccionar todo")
                                  ],
                                ),
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _conX.onActionUnselectAllTap();
                                },
                              )
                            ],
                            PopupMenuItem<int>(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_conX.isSentViewMode
                                      ? Icons.hourglass_bottom_rounded
                                      : Icons.checklist_rtl_rounded),
                                  const SizedBox(width: 6.0),
                                  Text(_conX.isSentViewMode
                                      ? 'Ver pendientes'
                                      : 'Ver enviados')
                                ],
                              ),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _conX.onToggleViewMode();
                              },
                            ),
                            /* PopupMenuItem<int>(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add),
                                  SizedBox(width: 6.0),
                                  Text("Nuevo registro")
                                ],
                              ),
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                // todo: hacer
                                // _conX.addPoll();
                              },
                            ), */
                          ];
                        }),
                  ],
                ),
                body: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: AkText(
                            _conX.tipoEncuesta.titulo,
                            style: TextStyle(
                                color: akPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _conX.inputSearchCtlr,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: "Centro Poblado / SAP",
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: akPrimaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: akPrimaryColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: akPrimaryColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Ink(
                                decoration: BoxDecoration(
                                  color: Helpers.darken(
                                      akScaffoldBackgroundColor, 0.07),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: IconButton(
                                  onPressed: _conX.onCleanInputTap,
                                  icon: Icon(
                                    Icons.close,
                                    color: akPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _conX.fetching.value
                                    ? _ResultSkeletonList()
                                    : _ResultList(conX: _conX),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() => LoadingLayer(
                          _conX.savingBackend.value,
                          text: 'Enviando al servidor...',
                        ))
                  ],
                ),
              ));
        });
  }
}

class _ResultList extends StatelessWidget {
  final EncuestasSavedController conX;

  const _ResultList({Key? key, required this.conX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EncuestasSavedController>(
        id: conX.gbLista,
        builder: (controller) {
          if (conX.filteredList.isEmpty) {
            return _NoItems();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: conX.filteredList.length,
            itemBuilder: (_, i) {
              final item = conX.filteredList[i];
              return _ListItem(
                onlyView: conX.isSentViewMode,
                selectableItem: item,
                onChanged: (value) {
                  if (value == null) return;
                  conX.onItemCheckTap(value, i, item);
                },
                onTap: () {
                  conX.onItemTap(i, item);
                },
                onDeleteTap: () {
                  conX.onDeleteItemTap(i, item);
                },
              );
            },
          );
        });
  }
}

class _ListItem extends StatelessWidget {
  final bool onlyView;
  final SelectableEntity selectableItem;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;

  const _ListItem({
    Key? key,
    this.onlyView = false,
    required this.selectableItem,
    this.onChanged,
    this.onTap,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: akWhiteColor,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 2.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B8D8D).withOpacity(.10),
            offset: const Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: AkText(
                  selectableItem.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: akTitleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: akFontSize - 2,
                    height: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: AkText(
                  selectableItem.subTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: akTitleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: akFontSize - 2,
                    height: 1.4,
                  ),
                ),
              ),
              CheckboxWidget(
                onlyView: onlyView,
                selectableItem,
                onChanged: onChanged,
                onTapItem: onTap,
                onDeleteTap: onDeleteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .6,
      child: Container(
        color: Colors.transparent,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: akContentPadding * 2,
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Get.width * 0.35),
              const AkText(
                'No hay resultados',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultSkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, i) => _SkeletonItem(),
    );
  }
}

class CheckboxWidget extends StatelessWidget {
  final bool onlyView;
  final SelectableEntity selectableItem;

  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTapItem;
  final VoidCallback? onDeleteTap;
  const CheckboxWidget(
    this.selectableItem, {
    super.key,
    this.onlyView = false,
    this.onChanged,
    this.onTapItem,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final datetimeFormat = DateFormat('dd/MM/yyyy hh:mm a');

    final body = Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapItem,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5.0),
                Row(children: <Widget>[
                  /* SvgPicture.asset('assets/img/position2.svg',
                        width: 30.0,
                        color: const Color.fromRGBO(255, 195, 13, .5)),
                    const SizedBox(width: 10.0), */
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AkText(
                          selectableItem.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF979797),
                            fontWeight: FontWeight.w400,
                            fontSize: akFontSize,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        _SurveyStatus(
                          sent: selectableItem.enviado,
                          completed: selectableItem.completo,
                        ),
                        if (selectableItem.fechaEnviado != null)
                          Column(
                            children: [
                              AkText(
                                'Enviado el:\n${datetimeFormat.format(selectableItem.fechaEnviado!)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF979797),
                                  fontWeight: FontWeight.w400,
                                  fontSize: akFontSize,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 15.0),
                      ]),
                  if (!onlyView) const Spacer(),
                  if (!onlyView)
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            semanticLabel: 'Eliminar',
                            color:
                                Helpers.darken(akScaffoldBackgroundColor, 0.17),
                          ),
                          onPressed: onDeleteTap,
                        ),
                      ],
                    )
                ]),
              ],
            ),
          ),
        ),
      ],
    );

    if (onlyView) {
      return ListTile(
        title: body,
      );
    }

    return CheckboxListTile(
      title: body,
      controlAffinity: ListTileControlAffinity.leading,
      value: selectableItem.selected, // todo:"pollDetail['value']",
      onChanged: onChanged,
      activeColor: akPrimaryColor,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class _SurveyStatus extends StatelessWidget {
  final bool completed;
  final bool sent;
  const _SurveyStatus({
    required this.completed,
    required this.sent,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    Color textColor = Colors.black;

    if (completed && sent) {
      text = 'Encuesta enviada';
      textColor = const Color(0xFF52BA52);
    } else if (completed && !sent) {
      text = 'Encuesta completa';
      textColor = const Color(0xFFD98D41);
    } else {
      text = 'Encuesta incompleta';
      textColor = const Color(0xFFD22121);
    }

    return AkText(text,
        style: TextStyle(
            fontSize: akFontSize - 1.0,
            color: textColor,
            fontWeight: FontWeight.w400));
  }
}

class _SkeletonItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Content(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Helpers.darken(akScaffoldBackgroundColor, 0.02)),
        child: Opacity(
          opacity: .55,
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(flex: 8, child: Skeleton(fluid: true, height: 18.0)),
                  Expanded(flex: 4, child: SizedBox())
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                children: const [
                  Expanded(flex: 4, child: Skeleton(fluid: true, height: 12.0)),
                  Expanded(flex: 6, child: SizedBox()),
                  Expanded(flex: 2, child: Skeleton(fluid: true, height: 12.0))
                ],
              ),
              const SizedBox(height: 2.0),
            ],
          ),
        ),
      ),
    );
  }
}
