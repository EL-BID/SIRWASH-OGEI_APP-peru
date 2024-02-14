import 'package:flutter/material.dart';
import 'package:sirwash/themes/ak_ui.dart';
import 'package:sirwash/widgets/widgets.dart';

class FormsSaveButtons extends StatelessWidget {
  final VoidCallback? onSubmitTap;
  final VoidCallback? onCancelTap;
  final bool isLoading;

  const FormsSaveButtons({
    super.key,
    this.isLoading = false,
    this.onSubmitTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator(
            color: akPrimaryColor,
          )
        : _formButtons();
  }

  Widget _formButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: BasicButton(
            text: 'Cancelar',
            colorPrimary: const Color.fromARGB(255, 255, 255, 255),
            colorText: akPrimaryColor,
            onTap: () {
              onCancelTap?.call();
            },
          ),
        ),
        const Expanded(flex: 1, child: Text("")),
        Expanded(
          flex: 4,
          child: BasicButton(
            text: 'Guardar',
            colorPrimary: akPrimaryColor,
            colorText: Colors.white,
            onTap: () {
              onSubmitTap?.call();
            },
          ),
        ),
      ],
    );
  }
}

class FormsReturnButtons extends StatelessWidget {
  final VoidCallback? onReturnTap;
  final bool isLoading;

  const FormsReturnButtons({
    super.key,
    this.isLoading = false,
    this.onReturnTap,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator(
            color: akPrimaryColor,
          )
        : _formButtons();
  }

  Widget _formButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: BasicButton(
            text: 'Regresar',
            colorPrimary: akPrimaryColor,
            colorText: Colors.white,
            onTap: () {
              onReturnTap?.call();
            },
          ),
        ),
      ],
    );
  }
}
