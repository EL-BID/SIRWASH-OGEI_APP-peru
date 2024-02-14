// ignore_for_file: constant_identifier_names

class Config {
  // ********** HACER UN HOT RESTART SIEMPRE QUE SE COMENTE O DESCOMENTE **********
  // *************************** NO OLVIDAR ***************************************
  // - Desarrollo
  static const URL_API = 'https://devsirwash.vivienda.gob.pe:5000';
  static const URL_API_PG = 'https://devsirwash.vivienda.gob.pe:5000';

  // ********** HACER UN HOT RESTART SIEMPRE QUE SE COMENTE O DESCOMENTE **********
  // *************************** NO OLVIDAR ***************************************
  // - QA
  // static const URL_API = 'https://presirwash.vivienda.gob.pe:5000';
  // static const URL_API_PG = 'https://presirwash.vivienda.gob.pe:5000';

  // ********** HACER UN HOT RESTART SIEMPRE QUE SE COMENTE O DESCOMENTE **********
  // *************************** NO OLVIDAR ***************************************
  // - Produccion
  // static const URL_API = 'http://178.128.158.138:8094';
  // static const URL_API_PG = 'http://178.128.158.138:8094';

  // ****** Fotos Config ************
  // Calidad de captura para las fotos. Rango [1-100]
  static const int photoQuality = 30;
  // Ancho y alto máximo para las fotos capturadas
  static const double photoMaxWidth = 960.0;
  static const double photoMaxHeight = 1280.0;
}
