import 'package:flutter/material.dart';
import 'package:sirwash/modules/home/components/tabs_widget.dart';
import 'package:sirwash/utils/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Wrapper que evita que la aplicación se cierre al
        /// hacer un gesto de retroceder por error.
        final result = await Helpers.confirmDialog(
          title: '¿Salir de la aplicación?',
          noText: 'Cancelar',
          yesText: 'Sí, salir',
        );

        return result ?? false;
      },
      child: const Scaffold(
        appBar: null,

        /// Contenedor de páginas scrolleables
        body: TabsWidget(),
      ),
    );
  }
}
