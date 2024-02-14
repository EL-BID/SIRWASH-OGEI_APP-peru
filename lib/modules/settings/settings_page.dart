// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/settings/settings_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: akPrimaryColor,
      body: Container(
          child: ListViewSettings(),
          decoration: BoxDecoration(color: akWhiteColor)),
    );
  }
}

class ListViewSettings extends StatelessWidget {
  final _conX = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    _conX.setContext(context);

    return GetBuilder<SettingsController>(
        id: _conX.gbSettings,
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              /* Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AkText("Modo Oscuro",
                      style: TextStyle(
                          color: akPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              ListTile(
                  title: const Text("Modo oscuro"),
                  subtitle:
                      const Text("Seleccione para aplicar el modo oscuro."),
                  leading: const Icon(Icons.mode_night),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Obx(() => Switch(
                            value: _conX.isLightThemeDark,
                            onChanged: (val) => _conX.changeThemeMode(),
                          )),
                    ],
                  )), */
              const SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AkText("Conectividad",
                      style: TextStyle(
                          color: akPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              const SizedBox(height: 5.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AkText("Muestra los mapas sin necesidad de internet.",
                      style: TextStyle(
                        color: akPrimaryColor,
                      ))),
              ListTile(
                  minLeadingWidth: 25,
                  title: const Text("Modo offline"),
                  /* subtitle: const Text(
                      "Muestra los mapas sin necesidad de internet."), */
                  leading: const Icon(Icons.network_check_rounded),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GetBuilder<SettingsController>(
                        id: _conX.gbOptionOffline,
                        builder: (_) => Switch(
                          value: _conX.globalSettings.isOfflineMode,
                          onChanged: (val) => _conX.changeAppMode(),
                        ),
                      ),
                    ],
                  )),
              _DownloadMapOption(conX: _conX),
              const SizedBox(height: 25.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AkText("Sincronizar datos de encuestas",
                      style: TextStyle(
                          color: akPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              const SizedBox(height: 5.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      AkText("Para sincronizar se necesita acceso a internet",
                          style: TextStyle(
                            color: akPrimaryColor,
                          ))),
              Obx(
                () => ListTile(
                  title: const Text("Centros poblados."),
                  // subtitle: const Text("Sincronizar..."),
                  trailing: _ButtonSync(
                      onTap: _conX.centroPobladoSync,
                      isLoading: _conX.synchronizingCentro.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text("SAP (Sistema de agua potable.)"),
                  // subtitle: const Text("Sincronizar..."),
                  trailing: _ButtonSync(
                      onTap: _conX.sapSync,
                      isLoading: _conX.synchronizingSap.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text("Prestadores"),
                  // subtitle: const Text("Sincronizar..."),
                  trailing: _ButtonSync(
                      onTap: _conX.prestadoresSync,
                      isLoading: _conX.synchronizingPrestadores.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text("Dominios"),
                  // subtitle: const Text("Sincronizar..."),
                  trailing: _ButtonSync(
                      onTap: _conX.dominiosSync,
                      isLoading: _conX.synchronizingDominios.value),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AkText("Limpieza",
                      style: TextStyle(
                          color: akPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              const SizedBox(height: 5.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AkText(
                      "Elimina las encuestas para liberar espacio. Incluyendo enviadas y no enviadas ",
                      style: TextStyle(
                        color: akPrimaryColor,
                      ))),
              const SizedBox(height: 5.0),
              Obx(
                () => ListTile(
                  title: const Text("Eliminar: Cloro residual"),
                  subtitle: const Text("Todas las encuestas"),
                  trailing: _DeleteSync(
                      onTap: _conX.deleteCloroResidual,
                      isLoading: _conX.deletingCloroResidual.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text(
                      "Eliminar: Limpieza y Desinfección de componentes del SAP"),
                  subtitle: const Text("Todas las encuestas"),
                  trailing: _DeleteSync(
                      onTap: _conX.deleteComponenteSap,
                      isLoading: _conX.deletingComponenteSap.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text("Eliminar: Continuidad de Servicio"),
                  subtitle: const Text("Todas las encuestas"),
                  trailing: _DeleteSync(
                      onTap: _conX.deleteContinuidadServicio,
                      isLoading: _conX.deletingContinuidadServicio.value),
                ),
              ),
              Obx(
                () => ListTile(
                  title: const Text("Eliminar: Cloración"),
                  subtitle: const Text("Todas las encuestas"),
                  trailing: _DeleteSync(
                      onTap: _conX.deleteCloraciones,
                      isLoading: _conX.deletingCloracion.value),
                ),
              ),

              /*Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AkText("Respaldo y restauración",
                      style: TextStyle(
                          color: akPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              GetBuilder<SettingsController>(
                  id: _conX.gbCloracion,
                  builder: (controller) {
                    return ListTile(
                        title: const Text("Respaldo"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _conX.createBackup();
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img/refresh.png'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ));
                  }),
              GetBuilder<SettingsController>(
                  id: _conX.gbCloracion,
                  builder: (controller) {
                    return ListTile(
                        title: const Text("Restaurar"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _conX.restoreBackup();
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img/refresh.png'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ));
                  }),*/
            ],
          );
        });
  }
}

class _DownloadMapOption extends StatelessWidget {
  const _DownloadMapOption({
    Key? key,
    required SettingsController conX,
  })  : _conX = conX,
        super(key: key);

  final SettingsController _conX;

  @override
  Widget build(BuildContext context) {
    /*    return Obx(() => Text(_conX.storedMap.value != null
        ? '${_conX.storedMap.value!.length}'
        : 'no hay')); */

    return Obx(() {
      return ListTile(
        minLeadingWidth: 25,
        leading: const Icon(Icons.map_outlined),
        title: const Text("Archivo .map"),
        subtitle: Row(
          children: [
            if (_conX.storedMapSize.value != null)
              const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.check_circle,
                  size: 16.0,
                  color: Colors.green,
                ),
              ),
            Expanded(
              child: Text(_conX.storedMapSize.value != null
                  ? 'Descargado (${NumberFormat.bytesToMB(_conX.storedMapSize.value!)} MB)'
                  : 'No descargado'),
            )
          ],
        ),
        trailing: _conX.storedMapSize.value != null
            ? _DeleteSync(
                onTap: _conX.borrarMapaOffline,
                isLoading: false,
              )
            : GestureDetector(
                onTap: _conX.empezarDescargaMapa,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(15.0),
                  child: const Icon(Icons.download, color: Colors.blueAccent),
                ),
              ),
      );
    });
  }
}

class _ButtonSync extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _ButtonSync({
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/refresh.png'),
          ),
        ),
      ),
    );

    return isLoading
        ? const Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                color: Color(0xFF1689FC),
              ),
            ),
          )
        : button;
  }
}

class _DeleteSync extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _DeleteSync({
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: SvgPicture.asset('assets/icons/delete.svg'),
      ),
    );

    return isLoading
        ? const Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                color: Color(0xFFFA5634),
              ),
            ),
          )
        : button;
  }
}
