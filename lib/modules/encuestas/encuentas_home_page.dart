import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirwash/data/models/tipo_encuesta.dart';

import '../../themes/ak_ui.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'encuestas_home_controller.dart';

class EncuestasHomePage extends StatelessWidget {
  final _conX = Get.put(EncuestasHomeController());

  EncuestasHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* const SizedBox(height: 10),
          _Caroucel(), */
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
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: akContentPadding * 0.8,
              ),
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
    );
  }
}

class _ResultList extends StatelessWidget {
  final EncuestasHomeController conX;

  const _ResultList({Key? key, required this.conX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conX.encuestas.isEmpty) {
      return _NoItems();
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: conX.encuestas.length,
      itemBuilder: (_, i) {
        return _ListItem(
          encuesta: conX.encuestas[i],
          onTap: (selected) {
            conX.onSelectItem(selected);
          },
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final TipoEncuesta encuesta;

  final Function(TipoEncuesta selected)? onTap;

  const _ListItem({
    Key? key,
    required this.encuesta,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  onTap?.call(encuesta);
                },
                child: SizedBox(
                    height: 300,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(encuesta.imgPath)),
                          ),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      10.0, 5.0, 10.0, 5.0),
                                  child: Text(
                                    encuesta.titulo,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                            )
                          ],
                        ),
                      ]),
                    )),
              );
            }));
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
          //physics: const NeverScrollableScrollPhysics(),
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
      //physics: NeverScrollableScrollPhysics(),
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
