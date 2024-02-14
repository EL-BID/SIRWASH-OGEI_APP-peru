part of 'utils.dart';

enum SnackBarVariant { primary, success, error, info, warning }

class Helpers {
  static Future<void> sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static bool keyboardIsVisible() {
    final compare = Get.mediaQuery.viewInsets.bottom == 0.0;
    return !(compare);
  }

  static final logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static void showError(String message, {String? devError}) async {
    Helpers.logger.e(devError ?? message);
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => AppSnackbar().error(message: message));
  }

  static void snackbar(
      {String? title,
      String message = '',
      SnackBarVariant variant = SnackBarVariant.info,
      bool hideIcon = false,
      SnackPosition snackPosition = SnackPosition.BOTTOM,
      bool snackMini = false}) {
    Color color = akPrimaryColor;
    IconData icon = Icons.android;
    String titleMsg = '';
    switch (variant) {
      case SnackBarVariant.primary:
        color = akPrimaryColor;
        icon = Icons.check;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.success:
        color = akSuccessColor;
        icon = Icons.check;
        titleMsg = title ?? 'Exitoso';
        break;
      case SnackBarVariant.error:
        color = akErrorColor;
        icon = Icons.error;
        titleMsg = title ?? 'Hubo un error';
        break;
      case SnackBarVariant.info:
        color = akInfoColor;
        icon = Icons.info;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.warning:
        color = akWarningColor;
        icon = Icons.warning;
        titleMsg = title ?? 'Advertencia';
        break;
    }

    if (snackMini) {
      Get.snackbar(
        '',
        '',
        margin: EdgeInsets.all(0),
        snackPosition: snackPosition,
        messageText: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: color),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: AkText(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        titleText: SizedBox(),
        backgroundColor: Colors.transparent,
      );
      return;
    }

    if (hideIcon) {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: akRadiusSnackbar,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
      );
    } else {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
        borderRadius: akRadiusSnackbar,
        icon: Icon(icon, color: Colors.white),
      );
    }
  }

  static Future<bool> confirmCloseAppDialog() async {
    return await Get.dialog(
        AlertDialog(
          content: Container(
            child: AkText(
              '¿Desea cerrar la aplicación?',
              style: TextStyle(fontSize: akFontSize + 2.0),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkButton(
                      text: 'Sí',
                      contentPadding: EdgeInsets.all(8.0),
                      type: AkButtonType.outline,
                      onPressed: () {
                        Get.back(result: true);
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkButton(
                      text: 'No',
                      contentPadding: EdgeInsets.all(8.0),
                      onPressed: () {
                        Get.back(result: false);
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            )
          ],
        ),
        barrierDismissible: false);
  }

  static Future<bool?> confirmDialog({
    String? title,
    String? subTitle,
    String? noText,
    String? yesText,
    Color? yesBackgroundColor,
    Color? yesTextColor,
  }) async {
    return await Get.dialog(
        AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                    color: akPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (title != null && subTitle != null)
                const SizedBox(height: 15.0),
              if (subTitle != null)
                Text(
                  subTitle,
                  style: TextStyle(
                    color: akTextColor,
                  ),
                ),
            ],
          ),
          actions: [
            OutlinedButton(
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(color: akPrimaryColor),
                ),
              ),
              child: Text(
                noText ?? 'No',
                style: TextStyle(color: akPrimaryColor),
              ),
              onPressed: () {
                Get.back(result: false);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    yesBackgroundColor ?? akPrimaryColor),
              ),
              child: Text(
                yesText ?? 'Sí',
                style: TextStyle(
                  color: yesTextColor ?? Colors.white,
                ),
              ),
              onPressed: () {
                Get.back(result: true);
              },
            ),
          ],
        ),
        barrierDismissible: false);
  }

  static String capitalizeFirstLetter(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : s;

  static String getObfuscateEmail(String completeEmail) {
    List<String> arrs = completeEmail.split('@');
    if (arrs.length == 2) {
      String firstPart = arrs[0];
      String obfuscateFp = '';
      int fpLength = firstPart.length;
      if (fpLength >= 5) {
        int middleCount = fpLength - 4;
        obfuscateFp = '${firstPart[0]}${firstPart[1]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp +=
            '${firstPart[fpLength - 2]}${firstPart[fpLength - 1]}@${arrs[1]}';
      } else if (fpLength >= 3) {
        int middleCount = fpLength - 2;
        obfuscateFp = '${firstPart[0]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp += '${firstPart[fpLength - 1]}@${arrs[1]}';
      } else {
        obfuscateFp = completeEmail;
      }
      return obfuscateFp;
    } else {
      return completeEmail;
    }
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Color hexToColor(String code, double opacity) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000)
        .withOpacity(opacity);
  }

  static String extractDate(
    DateTime dateTime, {
    String separator = '/',
  }) {
    final dateFormat =
        formatDate(dateTime, [dd, '$separator', mm, '$separator', yyyy]);
    return dateFormat;
  }

  static String extractTime(
    DateTime dateTime, {
    bool seconds = false,
    bool upperCase = true,
  }) {
    var estructure = [hh, ':', nn];
    if (seconds) {
      estructure.addAll([':', ss]);
    }
    estructure.addAll([' ', am]);

    var timeFormat = formatDate(dateTime, estructure);
    timeFormat =
        upperCase ? timeFormat.toUpperCase() : timeFormat.toLowerCase();
    return timeFormat;
  }

  static String replaceBgColorJs(Color color) {
    final hexValue = color.value.toRadixString(16);
    final hexColor = '#${hexValue.substring(2, hexValue.length)}';

    return "const cssOverrideStyle = document.createElement('style');"
        "cssOverrideStyle.textContent = `body {background-color: $hexColor;}`;"
        "document.head.append(cssOverrideStyle);";
  }

  static String formatBytes(int numBytes) {
    String sizeFile = "";
    double numKb;
    double numMb;
    if (numBytes > 1000) {
      numKb = numBytes / 1000;
      if (numKb > 1000) {
        numMb = numKb / 1000;

        sizeFile = numMb.toStringAsFixed(2) + " mb";
      } else {
        sizeFile = numKb.toStringAsFixed(2) + " kb";
      }
    } else {
      sizeFile = numBytes.toStringAsFixed(2) + " bytes";
    }

    return sizeFile;
  }

  static bool checkIfDataBase64IsImage(String dataBase64) {
    return dataBase64.contains('image/jpeg') ||
        dataBase64.contains('image/png');
  }

  static Uint8List getDecodedBytes(String encodedString) {
    String cleanBase64 = encodedString;
    if (encodedString.contains(';base64,')) {
      cleanBase64 = encodedString.split(';base64,')[1];
    }
    return base64Decode(cleanBase64);
  }

  static String getInitials(bank_account_name) {
    bank_account_name = bank_account_name.replaceAll("de", "");
    bank_account_name = bank_account_name.replaceAll("del", "");
    // bank_account_name = bank_account_name.replaceAll("/", "");
    bank_account_name = bank_account_name.replaceAll("y", "");
    bank_account_name = bank_account_name.replaceAll("con", "");
    bank_account_name = bank_account_name.replaceAll("   ", " ");
    bank_account_name = bank_account_name.replaceAll("  ", " ");

    List<String> names = bank_account_name.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  static int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  static bool searchInField(dynamic item, String term, String fieldName) {
    return item['description'].toLowerCase().contains(term.toLowerCase());
  }

  // NEW fILTERS
  static bool filterInCentroPoblado(CentroPoblado item, String term) {
    return item.alias.toLowerCase().contains(term.toLowerCase());
  }

  static bool filterInSap(Sap item, String term) {
    return item.alias.toLowerCase().contains(term.toLowerCase());
  }

  static bool filterInComponente(Componente item, String term) {
    return item.alias.toLowerCase().contains(term.toLowerCase());
  }

  static bool filterInInsumo(Insumo item, String term) {
    return item.alias.toLowerCase().contains(term.toLowerCase());
  }

  static bool filterInPrestador(Prestador item, String term) {
    return item.alias.toLowerCase().contains(term.toLowerCase());
  }

  static double? toDoubleOrNull(String text) {
    return text.isEmpty ? null : double.parse(text);
  }

  static int? toIntOrNull(String text) {
    return text.isEmpty ? null : int.parse(text);
  }

  static Future<DateTime?> showDateTimePicker(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final onlyDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: akPrimaryColor,
              onSurface: akTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: akPrimaryColor, // button text color
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // this is the border radius of the picker
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (onlyDate == null) return null;

    final onlyTime = await showTimePicker(
      initialTime: initialDate != null
          ? TimeOfDay.fromDateTime(initialDate)
          : TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        final Widget mediaQueryWrapper = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );

        // Applying a custom theme
        final customWidget = Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: akPrimaryColor,
              onSurface: akTextColor,
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? akPrimaryColor
                      : Colors.transparent),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.white
                      : akTextColor),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: akPrimaryColor, // button text color
              ),
            ),
          ),
          child: mediaQueryWrapper,
        );

        // A hack to use the es_US dateTimeFormat value.
        // https://github.com/flutter/flutter/issues/54839#issuecomment-628767595
        if (Localizations.localeOf(context).languageCode == 'es') {
          return Localizations.override(
            context: context,
            locale: const Locale('es', 'US'),
            child: customWidget,
          );
        }

        return customWidget;
      },
    );

    if (onlyTime == null) return null;

    return DateTime(onlyDate.year, onlyDate.month, onlyDate.day, onlyTime.hour,
        onlyTime.minute);
  }

  // static Future<BitmapDescriptor?> getCustomIcon(GlobalKey iconKey) async {
  //   Future<Uint8List?> _capturePng(GlobalKey iconKey) async {
  //     try {
  //       final renderObject = iconKey.currentContext?.findRenderObject();

  //       if (renderObject != null) {
  //         RenderRepaintBoundary boundary =
  //             renderObject as RenderRepaintBoundary;
  //         ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //         ByteData? byteData =
  //             await image.toByteData(format: ui.ImageByteFormat.png);
  //         if (byteData != null) {
  //           var pngBytes = byteData.buffer.asUint8List();
  //           return pngBytes;
  //         }
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }

  //   Uint8List? imageData = await _capturePng(iconKey);
  //   if (imageData != null) {
  //     return BitmapDescriptor.fromBytes(imageData);
  //   }
  // }

  static String generateHashLetter(int times) {
    return '#' * times;
  }
}
