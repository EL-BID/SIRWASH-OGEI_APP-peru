import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sirwash/modules/login/form/login_form_controller.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/utils/utils.dart';

// ignore: use_key_in_widget_constructors
class LoginFormPage extends StatelessWidget {
  final _conX = Get.put(LoginFormController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: akPrimaryColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(height: 10),
                  _HeaderApp(),
                  _InputsLogin(_conX),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 70, 45),
                          // padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        ),
                        onPressed:
                            _conX.loading.value ? null : _conX.onLoginButtonTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _conX.loading.value
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                      width: 15.0,
                                      height: 15.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  )
                                : const Text('Ingresar')
                          ],
                        )),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      if (_conX.loading.value) return;
                      _conX.loginWithNoCredentials();
                    },
                    child: const Text("Recolectar sin credenciales",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _FotterApp(),
          )
        ],
      ),
    );
  }
}

class _InputsLogin extends StatelessWidget {
  final LoginFormController _conX;

  const _InputsLogin(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const hintStyle = TextStyle(
      color: Color(0xFFc0c0c0),
    );
    const textStyle = TextStyle(
      color: Color.fromARGB(255, 68, 141, 190),
    );

    const inputDecoration = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: '',
      hintStyle: hintStyle,
      counterText: '',
      border: OutlineInputBorder(borderSide: BorderSide.none),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Column(
        children: [
          TextFormField(
              controller: _conX.usernameCtlr,
              decoration: inputDecoration.copyWith(hintText: 'usuario'),
              cursorColor: const Color(0xFF606060),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: Helpers.generateHashLetter(30),
                  filter: {
                    "#": RegExp(r'[0-9a-zA-Z]'),
                  },
                )
              ],
              style: textStyle,
              maxLength: 30),
          const SizedBox(height: 12.0),
          TextFormField(
            controller: _conX.passwordCtlr,
            textInputAction: TextInputAction.done,
            decoration: inputDecoration.copyWith(hintText: 'contraseña'),
            cursorColor: const Color(0xFF606060),
            obscureText: true,
            style: textStyle,
            maxLength: 30,
          )
        ],
      ),
    );
  }
}

class _HeaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Image.asset('assets/img/mvcys-8.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width - 50),
          ),
          const SizedBox(height: 35),
          /* Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
            child: Align(
              alignment: Alignment.center,
              child: AkText(
                "SIRWASH",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 160,
                    color: akWhiteColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ), */
          Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
            child: Image.asset(
              'assets/img/sirwash_logo.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
            child: AkText(
              "Recolección de Información a Nivel Comunitario",
              style: TextStyle(
                  fontSize: akFontSize,
                  color: akWhiteColor,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _FotterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/img/bid-8.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width - 250),
            Image.asset('assets/img/suiza-8.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width - 250),
          ],
        ),
      ),
    );
  }
}
