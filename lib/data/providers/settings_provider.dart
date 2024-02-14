import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sirwash/config/config.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/utils/utils.dart';

/// Proveedor utilizado para solicitar las tablas maestras al backend
/// y sincronizarlas de manera local con la base SQLite de la aplicación
class SettingsProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<List<CentroPoblado>> listAllCentrosPoblado() async {
    final resp = await _dioClient.get('/centropoblado');
    return List<CentroPoblado>.from(
      resp.map((e) => CentroPoblado.fromJson(e)),
    );
  }

  Future<List<Sap>> listAllSap() async {
    final resp = await _dioClient.get('/sap');
    return List<Sap>.from(
      resp.map((e) => Sap.fromJson(e)),
    );
  }

  Future<List<Prestador>> listAllPrestadores() async {
    final resp = await _dioClient.get('/prestador');
    return List<Prestador>.from(
      resp.map((e) => Prestador.fromBackend(e)),
    );
  }

  Future<List<CaudalAgua>> listAllCaudalAguas() async {
    final resp = await _dioClient.get('/caudal_agua');
    return List<CaudalAgua>.from(
      resp.map((e) => CaudalAgua.fromBackend(e)),
    );
  }

  Future<List<Componente>> listAllComponentes() async {
    final resp = await _dioClient.get('/componente');
    return List<Componente>.from(
      resp.map((e) => Componente.fromBackend(e)),
    );
  }

  Future<List<Frecuencia>> listAllFrecuencias() async {
    final resp = await _dioClient.get('/frecuencia');
    return List<Frecuencia>.from(
      resp.map((e) => Frecuencia.fromBackend(e)),
    );
  }

  Future<List<Hora>> listAllHoras() async {
    final resp = await _dioClient.get('/horas');
    return List<Hora>.from(
      resp.map((e) => Hora.fromBackend(e)),
    );
  }

  Future<List<Insumo>> listAllInsumos() async {
    final resp = await _dioClient.get('/insumo');
    return List<Insumo>.from(
      resp.map((e) => Insumo.fromBackend(e)),
    );
  }

  Future<List<MedidaBriqueta>> listAllMedidaBriquetas() async {
    final resp = await _dioClient.get('/medida_briquetas');
    return List<MedidaBriqueta>.from(
      resp.map((e) => MedidaBriqueta.fromBackend(e)),
    );
  }

  Future<List<MedidaGas>> listAllMedidaGas() async {
    final resp = await _dioClient.get('/medida_gas');
    return List<MedidaGas>.from(
      resp.map((e) => MedidaGas.fromBackend(e)),
    );
  }

  Future<List<MedidaHipocloritos>> listAllMedidaHipocloritos() async {
    final resp = await _dioClient.get('/medida_hipocloritos');
    return List<MedidaHipocloritos>.from(
      resp.map((e) => MedidaHipocloritos.fromBackend(e)),
    );
  }

  Future<List<TipoImagen>> listAllTipoImagenes() async {
    final resp = await _dioClient.get('/TipoImagen');
    return List<TipoImagen>.from(
      resp.map((e) => TipoImagen.fromBackend(e)),
    );
  }

  Future<void> downloadMap(String destination,
      {Function(int received, int total)? onReceiveProgress,
      CancelToken? cancelToken}) async {
    final dio = Dio(BaseOptions(
      baseUrl: Config.URL_API,
    ));
    await dio.download(
      '/mapa_base/download',
      destination,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}
