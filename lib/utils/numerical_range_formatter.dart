part of 'utils.dart';

class NumericalDoubleRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;
  final int maxDecimals;

  NumericalDoubleRangeFormatter(
      {required this.min, required this.max, this.maxDecimals = 1});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      if (newValue.text == '') {
        return newValue;
      } else if (double.parse(newValue.text) < min) {
        return oldValue;
      } else {
        if (double.parse(newValue.text) > max) {
          return oldValue;
        } else {
          if (_countDecimals(double.parse(newValue.text)) > maxDecimals) {
            return oldValue;
          } else {
            return newValue;
          }
        }
      }
    } catch (e) {
      return oldValue;
    }
  }

  int _countDecimals(double number) {
    String numberString = number.toString();
    int dotIndex = numberString.indexOf('.');
    return dotIndex == -1 ? 0 : (numberString.length - dotIndex - 1);
  }
}
