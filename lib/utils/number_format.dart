part of 'utils.dart';

class NumberFormat {
  static String bytesToMB(int bytes) {
    return (bytes / (1024 * 1024)).toStringAsFixed(1);
  }
}
