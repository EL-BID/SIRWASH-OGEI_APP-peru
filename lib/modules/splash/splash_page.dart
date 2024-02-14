import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/splash/splash_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';

class SplashPage extends StatelessWidget {
  final _conX = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: akPrimaryColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  child: Image.asset('assets/img/mvcys-8.png',
                      fit: BoxFit.fitWidth, width: 340),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
              child: AkText(
                "APLICATIVO OFFLINE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 45,
                    color: akWhiteColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            /* Image.asset(
              'assets/img/sirwash_logo.jpg',
              fit: BoxFit.fitWidth,
            ), */
            Container(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
              child: AkText(
                "Programa para cerrar las brechas en la cobertura y calidad de los servicios de agua, saneamiento e higiene para asegurar servicios asequibles, sostenibles y de calidad en áreas rurales",
                style: TextStyle(
                    fontSize: akFontSize,
                    color: akWhiteColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/img/bid-8.png',
                          fit: BoxFit.fitWidth, width: 160),
                      Image.asset('assets/img/suiza-8.png',
                          fit: BoxFit.fitWidth, width: 160),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
