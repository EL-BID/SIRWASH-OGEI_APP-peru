import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';
// import 'package:sirwash/modules/data/surveys_detail/surveys_detail_controller.dart';
import 'package:sirwash/modules/datos/datos_home_controller.dart';

import '../../themes/ak_ui.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DataHomePage extends StatelessWidget {
  final _conX = Get.put(DatosHomeController());

  DataHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: AkText(
              'Encuestas de información operativa',
              style:
                  TextStyle(color: akPrimaryColor, fontWeight: FontWeight.bold),
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
                        : _ResultList(conX: _conX)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final DatosHomeController conX;

  const _ResultList({Key? key, required this.conX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conX.encuestas.isEmpty) {
      return _NoItems();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: conX.encuestas.length,
      itemBuilder: (_, i) {
        return _ListItem(
          encuesta: conX.encuestas[i],
          onTap: (tipoEncuesta) {
            conX.onTipoEncuestaTap(tipoEncuesta);
          },
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final TipoEncuesta encuesta;
  final Function(TipoEncuesta tipoEncuesta)? onTap;

  const _ListItem({
    Key? key,
    required this.encuesta,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: akWhiteColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B8D8D).withOpacity(.10),
            offset: const Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: const Color(0xFFa5e8f0),
          highlightColor: const Color(0xFFa5e8f0),
          onTap: () async {
            onTap?.call(encuesta);
          },
          child: Container(
              color: Colors.transparent,
              child: /* Stack(
              children: [ */
                  Container(
                height: 140,
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 10,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            image: DecorationImage(
                              image: AssetImage(encuesta.imgPath),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: AkText(encuesta.titulo,
                                    style: TextStyle(
                                        fontSize: akFontSize - 1.0,
                                        color: akTitleColor,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              /*   ], */
              /*   ), */
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
