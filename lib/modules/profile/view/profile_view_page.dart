import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sirwash/modules/profile/view/profile_view_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/widgets/profile_widget.dart';
import 'package:sirwash/widgets/widgets.dart';

// ignore: use_key_in_widget_constructors
class ProfileViewPage extends StatelessWidget {
  final _conX = Get.put(ProfileViewController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 40),
        ProfileWidget(
          imagePath: 'assets/img/user.jpg',
          onClicked: () async {
            // Get.toNamed(AppRoutes.PROFILE_PASSWORD);
          },
        ),
        const SizedBox(height: 40),
        _NameAndRol(_conX),
        _BodyContent(_conX)
      ],
    );
  }
}

class _BodyContent extends StatelessWidget {
  // final _authX = Get.find<AuthController>();
  final ProfileViewController conX;

  const _BodyContent(
    this.conX, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tipoDocEmp = conX.employee?.employee.idTypeDocument;
    var tipoDoc = "";
    switch (tipoDocEmp) {
      case 1:
        {
          tipoDoc = "DNI";
        }
        break;

      case 2:
        {
          tipoDoc = "RUC";
        }
        break;

      default:
        {
          tipoDoc = "";
        }
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Content(
          child: Column(
            children: [
              if (conX.registeredUser)
                Column(
                  children: [
                    const SizedBox(height: 20.0),
                    // _DataItem(
                    //     label: 'Tipo de documento',
                    //     text: tipoDoc,
                    //     iconColor: akTitleColor,
                    //     icon: 'user'),
                    _DataItem(
                        label: 'Número de documento',
                        text: conX.userCredentials.dni ?? '',
                        icon: 'id_card'),
                    _DataItem(
                      label: 'Usuario',
                      text: conX.userCredentials.usuarioAlias ?? '',
                      icon: 'user',
                      iconColor: akTitleColor,
                      /* iconWidth: akFontSize + 3.0, */
                    ),
                    _DataItem(
                      label: 'Perfil',
                      text: conX.userCredentials.perfil ?? '',
                      icon: 'folder_document',
                      iconColor: akTitleColor,
                      /* iconWidth: akFontSize + 3.0, */
                    ),
                    /* _DataItem(
                      label: 'Estado',
                      text: conX.userCredentials.estado ?? '',
                      icon: 'folder_document',
                      iconColor: akTitleColor,
                    ), */
                    // const SizedBox(height: 10.0),
                    // _ActionButtons(
                    //     text: 'Cambiar contraseña',
                    //     colorPrimary: const Color.fromARGB(255, 255, 255, 255),
                    //     colorText: const Color.fromARGB(255, 0, 0, 0),
                    //     onTap: conX.onChangePasswordButtonTap),
                  ],
                ),
              const SizedBox(height: 8.0),
              _ActionButtons(
                text: 'Cerrar sesión',
                colorPrimary: const Color.fromARGB(255, 77, 77, 77),
                colorText: const Color.fromARGB(255, 255, 255, 255),
                onTap: conX.onLogoutButtonTap,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _NameAndRol extends StatelessWidget {
  final ProfileViewController conX;

  const _NameAndRol(
    this.conX, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final nombreCompleto =
        '${conX.userCredentials.nombre} ${conX.userCredentials.apellido}';
    return Column(
      children: [
        Text(
          // ignore: unnecessary_null_comparison
          conX.userCredentials.nombre != null
              ? nombreCompleto
              : 'Usuario Sin Credenciales (anónimo)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          conX.employee?.employee.rol.description ?? '',
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String text;
  final Color colorPrimary;
  final Color colorText;
  final void Function()? onTap;

  const _ActionButtons(
      {Key? key,
      required this.text,
      required this.colorPrimary,
      required this.colorText,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorText,
        backgroundColor: colorPrimary,
        side: const BorderSide(width: 1.0, color: Colors.grey),
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize: Size(MediaQuery.of(context).size.width - 60, 45),
      ),
      onPressed: () {
        onTap?.call();
      },
      child: Text(text),
    );
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String text;
  final String icon;
  final Color? iconColor;
  final double? iconWidth;

  const _DataItem({
    Key? key,
    required this.label,
    required this.text,
    required this.icon,
    this.iconWidth,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalIconSize = this.iconWidth ?? akFontSize + 2.0;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AkText(
            label,
            style: TextStyle(
              color: akTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: akFontSize + 4.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: akFontSize * 2.2,
                child: SvgPicture.asset(
                  'assets/icons/$icon.svg',
                  width: finalIconSize,
                  color: iconColor ?? akTextColor,
                ),
              ),
              Expanded(
                child: AkText(
                  text,
                  style: TextStyle(
                    fontSize: akFontSize,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
