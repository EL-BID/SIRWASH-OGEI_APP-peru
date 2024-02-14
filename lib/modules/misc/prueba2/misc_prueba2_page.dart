import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/routes/app_pages.dart';
import 'package:sirwash/themes/ak_ui.dart';

class MiscPrueba2Page extends StatelessWidget {
  const MiscPrueba2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AkButton(
              onPressed: () {
                Get.toNamed(AppRoutes.MISC_PRUEBA);
              },
              text: 'Ir a prueba',
            ),
          )
        ],
      ),
    );
  }
}
