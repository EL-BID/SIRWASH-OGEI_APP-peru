import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/datos/datos_home_page.dart';
import 'package:sirwash/modules/encuestas/encuentas_home_page.dart';
import 'package:sirwash/modules/home/components/tabs_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';

import '../../profile/view/profile_view_page.dart';
import '../../settings/settings_page.dart';

class TabsWidget extends StatelessWidget {
  const TabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TabsController _tabx = Get.put(TabsController());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 3,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: akPrimaryColor,
            bottom: TabBar(
              controller: _tabx.controller,
              indicatorColor: const Color.fromARGB(255, 255, 231, 14),
              tabs: const [
                Tab(text: "Encuesta"),
                Tab(text: "Datos"),
                Tab(text: "Ajustes"),
                Tab(text: "Perfil"),
              ],
            ),
            toolbarHeight: 0,
          ),
          body: TabBarView(
            controller: _tabx.controller,
            children: [
              EncuestasHomePage(),
              DataHomePage(),
              SettingsPage(),
              ProfileViewPage(),
              //Text("content")
            ],
          ),
        ),
      ),
    );
  }
}
