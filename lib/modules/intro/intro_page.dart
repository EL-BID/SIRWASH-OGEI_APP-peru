import 'package:sirwash/modules/intro/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatelessWidget {
  final _conX = Get.put(IntroController());

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image:
            SvgPicture.asset('assets/img/intro1.svg', width: Get.width * 0.88),
        title: "Bienvenido",
        body: "a",
        footer: const Text("SIRWASH"),
        /* decoration: const PageDecoration(
            pageColor: Color.fromARGB(255, 229, 231, 233),
          ) */
      ),
      PageViewModel(
        image:
            SvgPicture.asset('assets/img/intro2.svg', width: Get.width * 0.60),
        title: " ",
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        footer: const Text(""),
      ),
      PageViewModel(
        image:
            SvgPicture.asset('assets/img/intro3.svg', width: Get.width * 0.70),
        title: "",
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        footer: const Text(""),
      ),
      PageViewModel(
        image:
            SvgPicture.asset('assets/img/intro4.svg', width: Get.width * 0.80),
        title: "",
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        footer: const Text(""),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        showNextButton: true,
        next: const Text("Siguiente",
            style: TextStyle(fontWeight: FontWeight.w600)),
        showSkipButton: true,
        done: const Text("Finalizar",
            style: TextStyle(fontWeight: FontWeight.w600)),
        skip: const Text("Saltar"),
        onDone: _conX.onDoneButtonTap,
      ),
    );
  }
}
