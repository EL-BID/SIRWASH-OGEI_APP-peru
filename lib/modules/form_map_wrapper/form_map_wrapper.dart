import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/offline_map/offline_map.dart';
import 'package:sirwash/modules/osm_map/osm_map.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'form_map_wrapper_controller.dart';

part 'map_action_button.dart';

class FormMapWrapper extends StatelessWidget {
  final FormMapWrapperController _conX;
  final Widget? body;

  final _radiusPanel = 30.0;

  const FormMapWrapper(this._conX, {this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.onBackIntent(),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            _MapWidget(_conX),
            _MapButtons(_conX),
            _LoadingMessage(_conX),
            _getBuilderPanel(context)
          ],
        ),
      ),
    );
  }

  Widget _getBuilderPanel(BuildContext context) {
    _conX.panelHeightUpdated = false;
    _conX.heightFromWidgets = false;

    return GetBuilder<FormMapWrapperController>(
        id: _conX.gbSlidePanel,
        builder: (_) {
          return SlidingUpPanel(
            controller: _conX.slidePanelController,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(.35),
                  offset: const Offset(0, 8),
                  blurRadius: 8,
                  spreadRadius: 10)
            ],
            maxHeight: _conX.panelHeightOpen,
            minHeight: _conX.panelHeightClosed,
            backdropEnabled: true,
            backdropOpacity: .15,
            panelBuilder: (sc) => _buildPanelCard(sc, context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radiusPanel),
              topRight: Radius.circular(_radiusPanel),
            ),
            onPanelSlide: (double pos) {
              _conX.updatePanelMaxHeight();
            },
          );
        });
  }

  Widget _buildPanelCard(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          _buildPanelTitle(),
          Expanded(
            child: SingleChildScrollView(
              physics: _conX.heightFromWidgets
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              controller: sc,
              child: _buildPanelBody(body),
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildPanelTitle() {
    return RepaintBoundary(
      key: _conX.panelTitleKey,
      child: Column(children: [
        Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(bottom: 3.0),
                decoration: BoxDecoration(
                  color: akPrimaryColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(_radiusPanel)),
                ),
              ),
            ),
            Column(
              children: [
                Obx(() => Opacity(
                      opacity: _conX.latitudeLbl.value == 0.0 ? 0 : 1,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 17, 10, 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/gps.svg',
                              width: Get.size.width * 0.05,
                              color: akWhiteColor,
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: AkText(
                                _conX.latitudeLbl.value.toString() +
                                    ', ' +
                                    _conX.longitudeLbl.value.toString(),
                                type: AkTextType.comment,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: akWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(_radiusPanel))),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 35,
                            height: 4.5,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }

  RepaintBoundary _buildPanelBody(Widget? body) {
    return RepaintBoundary(
      key: _conX.panelBodyKey,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            body ?? const AkText('-- No body --'),
            const SizedBox(height: 25.0)
          ],
        ),
      ),
    );
  }
}

class _ProximityBar extends StatelessWidget {
  final FormMapWrapperController _conX;
  const _ProximityBar(
    this._conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_conX.accuracy.value == 0) return const SizedBox();

      Color barBgColor = const Color.fromARGB(255, 187, 38, 27);
      if (_conX.isGoodAccuracy) {
        barBgColor = const Color.fromARGB(255, 24, 138, 28);
      }

      return Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          decoration: BoxDecoration(
              color: barBgColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(
                30.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: barBgColor.withOpacity(.7),
                  offset: const Offset(0, 0),
                  blurRadius: 10.0,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Precisión del GPS'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.7),
                  fontSize: akFontSize - 4.0,
                  // fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                '${_conX.accuracy.value} m',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.7),
                  fontSize: akFontSize - 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _LoadingMessage extends StatelessWidget {
  final FormMapWrapperController _conX;
  const _LoadingMessage(
    this._conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => FadeOut(
          animate: !(_conX.loadingMap.value || _conX.localizando.value),
          child: MapPlaceholder(
            ignorePoint: !(_conX.loadingMap.value || _conX.localizando.value),
            text:
                _conX.loadingMap.value ? 'Cargando mapa...' : 'Localizando...',
          ),
        ));
  }
}

class _MapWidget extends StatelessWidget {
  final FormMapWrapperController _conX;

  const _MapWidget(
    this._conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _conX.buildMapWigets.value
          ? Column(
              children: [
                Expanded(
                  child: _conX.offlineMode
                      ? OfflineMap(
                          conX: _conX.offlineMapX,
                          onMapReady: _conX.onMapsWidgetsLoaded,
                        )
                      : OsmMap(
                          conX: _conX.osmMapX,
                          onMapReady: _conX.onMapsWidgetsLoaded,
                        ),
                ),
                Container(
                  color: akScaffoldBackgroundColor,
                  height: _conX.panelHeightClosed - 70,
                ),
              ],
            )
          : const SizedBox();
    });
  }
}

class _MapButtons extends StatelessWidget {
  final FormMapWrapperController conX;
  final delayedShow = const Duration(milliseconds: 0);
  final duration = const Duration(milliseconds: 500);

  const _MapButtons(
    this.conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(akContentPadding),
          child: Obx(
            () => conX.loadingMap.value || conX.localizando.value
                ? const SizedBox()
                : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FadeInLeft(
                              delay: delayedShow,
                              duration: duration,
                              child: _MapActionButton(
                                icon: Icons.arrow_back,
                                onTap: () async {
                                  if (await conX.backLogic()) Get.back();
                                },
                              )),
                          _ProximityBar(conX),
                          if (!conX.offlineMode)
                            FadeInRight(
                              delay: delayedShow,
                              duration: duration,
                              child: _MapActionButton(
                                icon: Icons.map_outlined,
                                onTap: conX.changeTileLayer,
                              ),
                            ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!conX.disableStreamPosition)
                            FadeInUp(
                              delay: delayedShow,
                              duration: duration,
                              child: _MapActionButton(
                                icon: Icons.my_location,
                                onTap: conX.centerToCurrentPosition,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: conX.panelHeightClosed)
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
