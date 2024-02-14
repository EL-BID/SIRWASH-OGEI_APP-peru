import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sirwash/data/models/models.dart';
import 'package:sirwash/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async =>
      _database ??= await _initiateDatabase();

  void _createCloracionesV1(Batch batch) {
    batch.execute('''
        CREATE TABLE "TRS_CLORACIONES" (
          "CLORACIONES_ID"	integer NOT NULL,
          "CALIBRACION_SISTEMA_CLORACION"	CHAR(1) DEFAULT 0,
          "FECHA_INSITU"	DATETIME NOT NULL,
          "RECOLECTOR"	VARCHAR(15),
          "LATITUD"	NUMERIC NOT NULL,
          "LONGITUD"	NUMERIC NOT NULL,
          "INSUMO_VALOR"	NUMERIC,
          "CENTRO_POBLADOS_ID" INTEGER NOT NULL,
          "SOLUCION_MADRE"	NUMERIC,
          "SAP_ID" INTEGER NOT NULL,
          "COMPONENTES_ID"	INTEGER,
          "INSUMOS_ID"	INTEGER,
          "MEDIDA_GAS_ID"	INTEGER,
          "MEDIDA_HIPOCLORITOS_ID"	INTEGER,
          "MEDIDA_BRIQUETAS_ID"	INTEGER,
          "VALIDADO"	CHAR(1) DEFAULT 0,
          "HISTORIAL"	CHAR(1) DEFAULT 1,
          "USUARIO_REGISTRO"	VARCHAR(15),
          "COMPLETO" INTEGER NOT NULL,
          "ENVIADO"	INTEGER NOT NULL,
          "BACKEND_ID"	INTEGER,
          "FECHA_ENVIADO"	datetime,
          FOREIGN KEY("COMPONENTES_ID") REFERENCES "MAE_COMPONENTES"("COMPONENTES_ID"),
          FOREIGN KEY("MEDIDA_HIPOCLORITOS_ID") REFERENCES "MAE_MEDIDA_HIPOCLORITOS"("MEDIDA_HIPOCLORITOS_ID"),
          FOREIGN KEY("INSUMOS_ID") REFERENCES "MAE_INSUMOS"("INSUMOS_ID"),
          FOREIGN KEY("MEDIDA_GAS_ID") REFERENCES "MAE_MEDIDA_GAS"("MEDIDA_GAS_ID"),
          FOREIGN KEY("MEDIDA_BRIQUETAS_ID") REFERENCES "MAE_MEDIDA_BRIQUETAS"("MEDIDA_BRIQUETAS_ID"),
          PRIMARY KEY("CLORACIONES_ID")
        );
      ''');
  }

  void _createCloroResidualesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_CLORO_RESIDUALES" (
        "CLORO_RESIDUALES_ID"	integer NOT NULL,
        "RESERVORIO_CLORO"	numeric,
        "RESERVORIO_FECHA"	datetime,
        "PRIMERA_VIVIENDA_CLORO"	numeric,
        "PRIMERA_VIVIENDA_FECHA"	datetime,
        "PRIMERA_VIVIENDA_DNI"	varchar(10) COLLATE NOCASE,
        "VIVIENDA_INTERMEDIA_CLORO"	numeric,
        "VIVIENDA_INTERMEDIA_FECHA"	datetime,
        "VIVIENDA_INTERMEDIA_DNI"	varchar(10) COLLATE NOCASE,
        "ULTIMA_VIVIENDA_CLORO"	numeric,
        "ULTIMA_VIVIENDA_FECHA"	datetime,
        "ULTIMA_VIVIENDA_DNI"	varchar(10) COLLATE NOCASE,
        "FECHA_INSITU"	datetime NOT NULL,
        "RECOLECTOR"	varchar(15) COLLATE NOCASE,
        "LATITUD"	numeric NOT NULL,
        "LONGITUD"	numeric NOT NULL,
        "CENTRO_POBLADOS_ID" integer NOT NULL,
        "SAP_ID"	integer NOT NULL,
        "VALIDADO"	char(1) DEFAULT 0 COLLATE NOCASE,
        "HISTORIAL"	char(1) DEFAULT 1 COLLATE NOCASE,
        "USUARIO_REGISTRO"	varchar(15) COLLATE NOCASE,
        "COMPLETO" INTEGER NOT NULL,
        "ENVIADO"	INTEGER NOT NULL,
        "BACKEND_ID"	INTEGER,
        "FECHA_ENVIADO"	datetime,
        PRIMARY KEY("CLORO_RESIDUALES_ID"),
        FOREIGN KEY("CENTRO_POBLADOS_ID") REFERENCES "MAE_CENTRO_POBLADOS"("CENTRO_POBLADOS_ID"),
        FOREIGN KEY("SAP_ID") REFERENCES "MAE_SAP"("SAP_ID")
      );
    ''');
  }

  void _createComponenteSAPV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_COMPONENTE_SAP" (
        "COMPONENTESAP_ID"	integer NOT NULL,
        "HIPOCLORITO"	numeric,
        "FECHA_INSITU"	datetime NOT NULL,
        "RECOLECTOR"	varchar(15) COLLATE NOCASE,
        "VALIDADO"	char(1) DEFAULT 0 COLLATE NOCASE,
        "LATITUD"	numeric NOT NULL,
        "LONGITUD"	numeric NOT NULL,
        "CENTRO_POBLADOS_ID" integer NOT NULL,
        "SAP_ID"	integer NOT NULL,
        "PRESTADORES_ID"	integer,
        "HISTORIAL"	char(1) DEFAULT 1 COLLATE NOCASE,
        "USUARIO_REGISTRO"	varchar(15) COLLATE NOCASE,
        "COMPLETO" INTEGER NOT NULL,
        "ENVIADO"	INTEGER NOT NULL,
        "BACKEND_ID"	INTEGER,
        "FECHA_ENVIADO"	datetime,
        PRIMARY KEY("COMPONENTESAP_ID"),
        FOREIGN KEY("SAP_ID") REFERENCES "MAE_SAP"("SAP_ID"),
        FOREIGN KEY("CENTRO_POBLADOS_ID") REFERENCES "MAE_CENTRO_POBLADOS"("CENTRO_POBLADOS_ID"),
        FOREIGN KEY("PRESTADORES_ID") REFERENCES "MAE_PRESTADORES"("PRESTADORES_ID")
      );
    ''');
  }

  void _createContinuidadServiciosV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_CONTINUIDAD_SERVICIOS" (
        "CONTINUIDAD_SERVICIOS_ID"	integer NOT NULL,
        "CAUDAL_TIEMPO1"	numeric,
        "CAUDAL_TIEMPO2"	numeric,
        "CAUDAL_TIEMPO3"	numeric,
        "FECHA_INSITU"	datetime NOT NULL,
        "RECOLECTOR"	varchar(15) COLLATE NOCASE,
        "VALIDADO"	char(1) DEFAULT 0 COLLATE NOCASE,
        "LATITUD"	numeric NOT NULL,
        "LONGITUD"	numeric NOT NULL,
        "CENTRO_POBLADOS_ID" integer NOT NULL,
        "SAP_ID" integer NOT NULL,
        "FRECUENCIAS_ID"	integer,
        "HORAS_ID"	integer,
        "CAUDAL_AGUAS_ID"	integer,
        "HISTORIAL"	char(1) DEFAULT 1 COLLATE NOCASE,
        "USUARIO_REGISTRO"	varchar(15) COLLATE NOCASE,
        "COMPLETO" INTEGER NOT NULL,
        "ENVIADO"	INTEGER NOT NULL,
        "BACKEND_ID"	INTEGER,
        "FECHA_ENVIADO"	datetime,
        PRIMARY KEY("CONTINUIDAD_SERVICIOS_ID"),
        FOREIGN KEY("CENTRO_POBLADOS_ID") REFERENCES "MAE_CENTRO_POBLADOS"("CENTRO_POBLADOS_ID"),
        FOREIGN KEY("CAUDAL_AGUAS_ID") REFERENCES "MAE_CAUDAL_AGUAS"("CAUDAL_AGUAS_ID"),
        FOREIGN KEY("FRECUENCIAS_ID") REFERENCES "MAE_FRECUENCIAS"("FRECUENCIAS_ID"),
        FOREIGN KEY("SAP_ID") REFERENCES "MAE_SAP"("SAP_ID"),
        FOREIGN KEY("HORAS_ID") REFERENCES "MAE_HORAS"("HORAS_ID")
      );
    ''');
  }

  void _createMAECaudalAguasV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_CAUDAL_AGUAS" (
        "CAUDAL_AGUAS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "VALOR"	smallint NOT NULL,
        PRIMARY KEY("CAUDAL_AGUAS_ID")
      );
    ''');
  }

  void _createMAECentroPobladosV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_CENTRO_POBLADOS" (
        "CENTRO_POBLADOS_ID"	integer NOT NULL,
        "CODIGO_CENTRO_POBLADOS"	varchar(15) NOT NULL COLLATE NOCASE,
        "NOMBRE"	varchar(100) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "DEPARTAMENTO"	varchar(50) NOT NULL COLLATE NOCASE,
        "PROVINCIA"	varchar(50) NOT NULL COLLATE NOCASE,
        "DISTRITO"	varchar(50) NOT NULL COLLATE NOCASE,
        PRIMARY KEY("CENTRO_POBLADOS_ID")
      );
    ''');
  }

  void _createMAEComponentesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_COMPONENTES" (
        "COMPONENTES_ID"	integer NOT NULL,
        "NOMBRE"	varchar(100) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        PRIMARY KEY("COMPONENTES_ID")
      );
    ''');
  }

  void _createMAEFrecuenciasV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_FRECUENCIAS" (
        "FRECUENCIAS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "VALOR"	smallint NOT NULL,
        PRIMARY KEY("FRECUENCIAS_ID")
      );
    ''');
  }

  void _createMAEHorasV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_HORAS" (
        "HORAS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "VALOR"	smallint NOT NULL,
        PRIMARY KEY("HORAS_ID")
      );
    ''');
  }

  void _createMAEInsumosV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_INSUMOS" (
        "INSUMOS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        PRIMARY KEY("INSUMOS_ID")
      );
    ''');
  }

  void _createMAEMedidasBriquetasV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_MEDIDA_BRIQUETAS" (
        "MEDIDA_BRIQUETAS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "VALOR"	numeric NOT NULL,
        PRIMARY KEY("MEDIDA_BRIQUETAS_ID")
      );
    ''');
  }

  void _createMAEMedidaGasV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_MEDIDA_GAS" (
        "MEDIDA_GAS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(50) NOT NULL COLLATE NOCASE,
        "VALOR"	smallint NOT NULL,
        PRIMARY KEY("MEDIDA_GAS_ID")
      );
    ''');
  }

  void _createMAEMedidaHipocloritosV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_MEDIDA_HIPOCLORITOS" (
        "MEDIDA_HIPOCLORITOS_ID"	integer NOT NULL,
        "NOMBRE"	varchar(50) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(200) NOT NULL COLLATE NOCASE,
        "VALOR"	numeric NOT NULL,
        PRIMARY KEY("MEDIDA_HIPOCLORITOS_ID")
      );
    ''');
  }

  void _createMAEPrestadoresV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_PRESTADORES" (
        "PRESTADORES_ID"	integer NOT NULL,
        "CODIGO"	varchar(25) NOT NULL COLLATE NOCASE,
        "NOMBRE"	varchar(150) NOT NULL COLLATE NOCASE,
        "ALIAS"	varchar(150) NOT NULL COLLATE NOCASE,
        "CENTRO_POBLADOS_ID"	integer,
        "CODIGO_CENTRO_POBLADOS"	varchar(10) NOT NULL COLLATE NOCASE,
        PRIMARY KEY("PRESTADORES_ID")
      );
    ''');
  }

  void _createMAETipoImagenesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_TIPO_IMAGENES" (
        "TIPO_IMAGENES_ID"	integer NOT NULL,
        "NOMBRE"	varchar(70) NOT NULL COLLATE NOCASE,
        "GRUPO"	varchar(20) NOT NULL COLLATE NOCASE,
        "REQUERIDO"	char(1) NOT NULL COLLATE NOCASE,
        "ORDEN"	char(2) DEFAULT 0 COLLATE NOCASE,
        PRIMARY KEY("TIPO_IMAGENES_ID")
      );
    ''');
  }

  void _createMAESapV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "MAE_SAP" (
        "SAP_ID"	integer NOT NULL,
        "CODIGO"	varchar(13) NOT NULL COLLATE NOCASE,
        "NOMBRE"	varchar(150) COLLATE NOCASE,
        "ALIAS"	varchar(200) COLLATE NOCASE,
        "CODIGO_CENTRO_POBLADOS"	varchar(10) NOT NULL COLLATE NOCASE,
        "CENTRO_POBLADOS_ID"	integer,
        "HISTORIAL"	char(1) NOT NULL DEFAULT 1 COLLATE NOCASE,
        PRIMARY KEY("SAP_ID")
      );
    ''');
  }

  void _createRELCloracionesTipoImagenesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_CLORACIONES_TIPO_IMAGENES" (
        "IMAGEN_ID"	integer NOT NULL,
        "NOMBRE"	varchar(300) NOT NULL COLLATE NOCASE,
        "RUTA"	varchar(500) NOT NULL COLLATE NOCASE,
        "TIPO_IMAGEN_ID"	integer NOT NULL,
        "FECHA_INSITU"	datetime NOT NULL,
        "CLORACIONES_ID"	integer NOT NULL,
        "USUARIO_REGISTRO"	varchar(15),
        "LATITUD"	NUMERIC NOT NULL,
        "LONGITUD"	NUMERIC NOT NULL,
        PRIMARY KEY("IMAGEN_ID"),
        FOREIGN KEY("TIPO_IMAGEN_ID") REFERENCES "MAE_TIPO_IMAGENES"("TIPO_IMAGENES_ID"),
        FOREIGN KEY("CLORACIONES_ID") REFERENCES "TRS_CLORACIONES"("CLORACIONES_ID")
      );
    ''');
  }

  void _createRELCloroResidualesTipoImagenesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_CLORO_RESIDUALES_TIPO_IMAGENES" (
        "IMAGEN_ID"	integer NOT NULL,
        "NOMBRE"	varchar(300) NOT NULL COLLATE NOCASE,
        "RUTA"	varchar(500) NOT NULL COLLATE NOCASE,
        "TIPO_IMAGEN_ID"	integer NOT NULL,
        "FECHA_INSITU"	datetime NOT NULL,
        "CLORO_RESIDUALES_ID"	integer NOT NULL,
        "USUARIO_REGISTRO"	varchar(15),
        "LATITUD"	NUMERIC NOT NULL,
        "LONGITUD"	NUMERIC NOT NULL,
        PRIMARY KEY("IMAGEN_ID"),
        FOREIGN KEY("TIPO_IMAGEN_ID") REFERENCES "MAE_TIPO_IMAGENES"("TIPO_IMAGENES_ID"),
        FOREIGN KEY("CLORO_RESIDUALES_ID") REFERENCES "TRS_CLORO_RESIDUALES"("CLORO_RESIDUALES_ID")
      );
    ''');
  }

  void _createRELComponentesSapTipoImagenesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_COMPONENTES_SAP_TIPO_IMAGENES" (
        "IMAGEN_ID"	integer NOT NULL,
        "NOMBRE"	varchar(300) NOT NULL COLLATE NOCASE,
        "RUTA"	varchar(500) NOT NULL COLLATE NOCASE,
        "TIPO_IMAGEN_ID"	integer NOT NULL,
        "FECHA_INSITU"	datetime NOT NULL,
        "COMPONENTESAP_ID"	integer NOT NULL,
        "USUARIO_REGISTRO"	varchar(15),
        "LATITUD"	NUMERIC NOT NULL,
        "LONGITUD"	NUMERIC NOT NULL,
        PRIMARY KEY("IMAGEN_ID"),
        FOREIGN KEY("TIPO_IMAGEN_ID") REFERENCES "MAE_TIPO_IMAGENES"("TIPO_IMAGENES_ID"),
        FOREIGN KEY("COMPONENTESAP_ID") REFERENCES "TRS_COMPONENTE_SAP"("COMPONENTESAP_ID")
      );
    ''');
  }

  void _createRELContinuidadServiciosTipoImagenesV1(Batch batch) {
    batch.execute('''
      CREATE TABLE "TRS_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES" (
        "IMAGEN_ID"	integer NOT NULL,
        "NOMBRE"	varchar(300) NOT NULL COLLATE NOCASE,
        "RUTA"	varchar(500) NOT NULL COLLATE NOCASE,
        "TIPO_IMAGEN_ID"	integer NOT NULL,
        "FECHA_INSITU"	datetime NOT NULL,
        "CONTINUIDAD_SERVICIOS_ID"	integer NOT NULL,
        "USUARIO_REGISTRO"	varchar(15),
        "LATITUD"	NUMERIC NOT NULL,
        "LONGITUD"	NUMERIC NOT NULL,
        PRIMARY KEY("IMAGEN_ID"),
        FOREIGN KEY("TIPO_IMAGEN_ID") REFERENCES "MAE_TIPO_IMAGENES"("TIPO_IMAGENES_ID"),
        FOREIGN KEY("CONTINUIDAD_SERVICIOS_ID") REFERENCES "TRS_CONTINUIDAD_SERVICIOS"("CONTINUIDAD_SERVICIOS_ID")
      );
    ''');
  }

  void _createUniqueIndexesV1(Batch batch) {
    batch.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS "MAE_CENTRO_POBLADOS_UNQ_TB_CENTRO_POBLADO_COD_CENTRO_POBLADO" ON "MAE_CENTRO_POBLADOS" (
        "CODIGO_CENTRO_POBLADOS"	DESC
      );
      CREATE UNIQUE INDEX IF NOT EXISTS "MAE_CENTRO_POBLADOS_UNQ_TB_CENTRO_POBLADO_ID_CENTRO_POBLADO" ON "MAE_CENTRO_POBLADOS" (
        "CENTRO_POBLADOS_ID"	DESC
      );
      CREATE UNIQUE INDEX IF NOT EXISTS "MAE_PRESTADORES_UNQ_TB_PRESTADOR_COD_PRESTADOR" ON "MAE_PRESTADORES" (
        "CODIGO"	DESC
      );
      CREATE UNIQUE INDEX IF NOT EXISTS "MAE_SAP_UNQ_TB_SAP_COD_SAP" ON "MAE_SAP" (
        "CODIGO"	DESC
      );
      CREATE UNIQUE INDEX IF NOT EXISTS "MAE_SAP_UNQ_TB_SAP_ID_SAP" ON "MAE_SAP" (
        "SAP_ID"	DESC
      );
    ''');
  }

  /// Función inicial para instanciar la base de Datos SQLite
  /// La primera vez inicializa la base de datos.
  ///
  /// En las llamadas posteriores, devuelve la misma instancia.
  Future<Database> _initiateDatabase() async {
    final path = join(await getDatabasesPath(), 'sirwash.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      Helpers.logger.w('Creando base de datos');

      final batch = db.batch();
      _createCloracionesV1(batch);
      _createCloroResidualesV1(batch);
      _createComponenteSAPV1(batch);
      _createContinuidadServiciosV1(batch);
      _createMAECaudalAguasV1(batch);
      _createMAECentroPobladosV1(batch);
      _createMAEComponentesV1(batch);
      _createMAEFrecuenciasV1(batch);
      _createMAEHorasV1(batch);
      _createMAEInsumosV1(batch);
      _createMAEMedidasBriquetasV1(batch);
      _createMAEMedidaGasV1(batch);
      _createMAEMedidaHipocloritosV1(batch);
      _createMAEPrestadoresV1(batch);
      _createMAETipoImagenesV1(batch);
      _createMAESapV1(batch);
      _createRELCloracionesTipoImagenesV1(batch);
      _createRELCloroResidualesTipoImagenesV1(batch);
      _createRELComponentesSapTipoImagenesV1(batch);
      _createRELContinuidadServiciosTipoImagenesV1(batch);
      _createUniqueIndexesV1(batch);
      await batch.commit();
    });
  }

  /// Comodín para probar la conexión a la base de datos
  Future<void> ping() async {
    await database;
  }

  // BEGIN :: MAE_CENTRO_POBLADOS
  Future<int> deleteAllCentroPoblado() async {
    final db = await database;
    final res = await db.delete('MAE_CENTRO_POBLADOS');
    return res;
  }

  Future<void> insertCentroPoblado(List<CentroPoblado> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_CENTRO_POBLADOS', item.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<List<CentroPoblado>> listAllCentroPoblado() async {
    final db = await database;
    final list = await db.query('MAE_CENTRO_POBLADOS');
    return List<CentroPoblado>.from(
      list.map((e) => CentroPoblado.fromSQLite(e)),
    );
  }

  Future<CentroPoblado?> listCentroPobladoById(int id) async {
    final db = await database;
    final list = await db.query('MAE_CENTRO_POBLADOS',
        where: 'CENTRO_POBLADOS_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? CentroPoblado.fromSQLite(list.first) : null;
  }

  Future<List<CentroPoblado>> listAllCentroPobladoInArray(
      List<MisCentroPoblados> codes) async {
    final stringQueryCodes =
        codes.map((c) => "'${c.codigoCentroPoblados}'").toList().join(',');

    final db = await database;
    final list = await db.query('MAE_CENTRO_POBLADOS',
        where: "CODIGO_CENTRO_POBLADOS IN ($stringQueryCodes)");
    return List<CentroPoblado>.from(
      list.map((e) => CentroPoblado.fromSQLite(e)),
    );
  }
  // END :: MAE_CENTRO_POBLADOS

  // BEGIN :: MAE_SAP
  Future<int> deleteAllSap() async {
    final db = await database;
    final res = await db.delete('MAE_SAP');
    return res;
  }

  Future<void> insertSap(List<Sap> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_SAP', item.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Sap>> listSapByCodCentroPoblado(String codCentroPoblado) async {
    final db = await database;
    final list = await db.query('MAE_SAP',
        where: 'CODIGO_CENTRO_POBLADOS = ?', whereArgs: [codCentroPoblado]);
    return List<Sap>.from(
      list.map((e) => Sap.fromSQLite(e)),
    );
  }

  Future<Sap?> listSapById(int id) async {
    final db = await database;
    final list =
        await db.query('MAE_SAP', where: 'SAP_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? Sap.fromSQLite(list.first) : null;
  }
  // END :: MAE_SAP

  // BEGIN :: MAE_PRESTADORES
  Future<int> deleteAllPrestadores() async {
    final db = await database;
    final res = await db.delete('MAE_PRESTADORES');
    return res;
  }

  Future<void> insertPrestadores(List<Prestador> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_PRESTADORES', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Prestador>> listPrestadorByCodCentroPoblado(
      String codCentroPoblado) async {
    final db = await database;
    final list = await db.query('MAE_PRESTADORES',
        where: 'CODIGO_CENTRO_POBLADOS = ?', whereArgs: [codCentroPoblado]);
    return List<Prestador>.from(
      list.map((e) => Prestador.fromSQLite(e)),
    );
  }

  Future<Prestador?> listPrestadorById(int id) async {
    final db = await database;
    final list = await db
        .query('MAE_PRESTADORES', where: 'PRESTADORES_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? Prestador.fromSQLite(list.first) : null;
  }
  // END :: MAE_PRESTADORES

  // BEGIN :: MAE_CAUDAL_AGUAS
  Future<int> deleteAllCaudalAguas() async {
    final db = await database;
    final res = await db.delete('MAE_CAUDAL_AGUAS');
    return res;
  }

  Future<void> insertCaudalAguas(List<CaudalAgua> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_CAUDAL_AGUAS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<CaudalAgua>> listAllCaudalAguas() async {
    final db = await database;
    final list = await db.query('MAE_CAUDAL_AGUAS');
    return List<CaudalAgua>.from(
      list.map((e) => CaudalAgua.fromSQLite(e)),
    );
  }
  // END :: MAE_CAUDAL_AGUAS

  // BEGIN :: MAE_COMPONENTES
  Future<int> deleteAllComponentes() async {
    final db = await database;
    final res = await db.delete('MAE_COMPONENTES');
    return res;
  }

  Future<void> insertComponentes(List<Componente> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_COMPONENTES', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Componente>> listAllComponentes() async {
    final db = await database;
    final list = await db.query('MAE_COMPONENTES');
    return List<Componente>.from(
      list.map((e) => Componente.fromSQLite(e)),
    );
  }
  // END :: MAE_COMPONENTES

  // BEGIN :: MAE_FRECUENCIAS
  Future<int> deleteAllFrecuencias() async {
    final db = await database;
    final res = await db.delete('MAE_FRECUENCIAS');
    return res;
  }

  Future<void> insertFrecuencias(List<Frecuencia> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_FRECUENCIAS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Frecuencia>> listAllFrecuencias() async {
    final db = await database;
    final list = await db.query('MAE_FRECUENCIAS');
    return List<Frecuencia>.from(
      list.map((e) => Frecuencia.fromSQLite(e)),
    );
  }
  // END :: MAE_FRECUENCIAS

  // BEGIN :: MAE_HORAS
  Future<int> deleteAllHoras() async {
    final db = await database;
    final res = await db.delete('MAE_HORAS');
    return res;
  }

  Future<void> insertHoras(List<Hora> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_HORAS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Hora>> listAllHoras() async {
    final db = await database;
    final list = await db.query('MAE_HORAS');
    return List<Hora>.from(
      list.map((e) => Hora.fromSQLite(e)),
    );
  }
  // END :: MAE_HORAS

  // BEGIN :: MAE_INSUMOS
  Future<int> deleteAllInsumos() async {
    final db = await database;
    final res = await db.delete('MAE_INSUMOS');
    return res;
  }

  Future<void> insertInsumos(List<Insumo> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_INSUMOS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Insumo>> listAllInsumos() async {
    final db = await database;
    final list = await db.query('MAE_INSUMOS');
    return List<Insumo>.from(
      list.map((e) => Insumo.fromSQLite(e)),
    );
  }
  // END :: MAE_INSUMOS

  // BEGIN :: MAE_MEDIDA_BRIQUETAS
  Future<int> deleteAllMedidaBriquetas() async {
    final db = await database;
    final res = await db.delete('MAE_MEDIDA_BRIQUETAS');
    return res;
  }

  Future<void> insertMedidaBriquetas(List<MedidaBriqueta> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_MEDIDA_BRIQUETAS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<MedidaBriqueta>> listAllMedidaBriquetas() async {
    final db = await database;
    final list = await db.query('MAE_MEDIDA_BRIQUETAS');
    return List<MedidaBriqueta>.from(
      list.map((e) => MedidaBriqueta.fromSQLite(e)),
    );
  }
  // END :: MAE_MEDIDA_BRIQUETAS

  // BEGIN :: MAE_MEDIDA_GAS
  Future<int> deleteAllMedidaGas() async {
    final db = await database;
    final res = await db.delete('MAE_MEDIDA_GAS');
    return res;
  }

  Future<void> insertMedidaGas(List<MedidaGas> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_MEDIDA_GAS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<MedidaGas>> listAllMedidaGas() async {
    final db = await database;
    final list = await db.query('MAE_MEDIDA_GAS');
    return List<MedidaGas>.from(
      list.map((e) => MedidaGas.fromSQLite(e)),
    );
  }
  // END :: MAE_MEDIDA_GAS

  // BEGIN :: MAE_MEDIDA_HIPOCLORITOS
  Future<int> deleteAllMedidaHipocloritos() async {
    final db = await database;
    final res = await db.delete('MAE_MEDIDA_HIPOCLORITOS');
    return res;
  }

  Future<void> insertMedidaHipocloritos(List<MedidaHipocloritos> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_MEDIDA_HIPOCLORITOS', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<MedidaHipocloritos>> listAllMedidaHipocloritos() async {
    final db = await database;
    final list = await db.query('MAE_MEDIDA_HIPOCLORITOS');
    return List<MedidaHipocloritos>.from(
      list.map((e) => MedidaHipocloritos.fromSQLite(e)),
    );
  }
  // END :: MAE_MEDIDA_HIPOCLORITOS

  // BEGIN :: MAE_TIPO_IMAGENES
  Future<int> deleteAllTipoImagenes() async {
    final db = await database;
    final res = await db.delete('MAE_TIPO_IMAGENES');
    return res;
  }

  Future<void> insertTipoImagenes(List<TipoImagen> list) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in list) {
      batch.insert('MAE_TIPO_IMAGENES', item.toSQLite());
    }
    await batch.commit(noResult: true);
  }

  Future<List<TipoImagen>> listAllTipoImagenByGrupo(String grupo) async {
    final db = await database;
    final list = await db.query('MAE_TIPO_IMAGENES',
        where: 'GRUPO = ?', whereArgs: [grupo], orderBy: 'ORDEN');
    return List<TipoImagen>.from(
      list.map((e) => TipoImagen.fromSQLite(e)),
    );
  }
  // END :: MAE_TIPO_IMAGENES

  // BEGIN :: CLORO_RESIDUALES
  Future<int> getNewIdCloroResidual() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CLORO_RESIDUALES',
      column: 'CLORO_RESIDUALES_ID',
    );
    return newId;
  }

  Future<List<CloroResidual>> listAllCloroResiduales(
      {required bool enviado, String? filterByUser}) async {
    final db = await database;

    String wheres = 'ENVIADO = ?';
    List whereArgs = [enviado ? 1 : 0];
    if (filterByUser != null) {
      wheres = '$wheres AND USUARIO_REGISTRO = ?';
      whereArgs.add(filterByUser);
    }

    final list = await db.query(
      'TRS_CLORO_RESIDUALES',
      where: wheres,
      whereArgs: whereArgs,
      orderBy: 'CLORO_RESIDUALES_ID DESC',
    );

    return List<CloroResidual>.from(
      list.map((e) => CloroResidual.fromSQLite(e)),
    );
  }

  Future<CloroResidual?> listCloroResidualById(int id) async {
    final db = await database;
    final list = await db.query('TRS_CLORO_RESIDUALES',
        where: 'CLORO_RESIDUALES_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? CloroResidual.fromSQLite(list.first) : null;
  }

  Future<void> insertCloroResidual(CloroResidual form) async {
    final db = await database;
    await db.insert('TRS_CLORO_RESIDUALES', form.toSQLite());
  }

  Future<void> updateCloroResidual(CloroResidual form) async {
    final db = await database;
    await db.update(
      'TRS_CLORO_RESIDUALES',
      form.toSQLite(),
      where: 'CLORO_RESIDUALES_ID = ?',
      whereArgs: [form.cloroResidualesId],
    );
  }

  Future<void> deleteCloroResidualById(int id) async {
    final db = await database;
    await db.delete('TRS_CLORO_RESIDUALES',
        where: 'CLORO_RESIDUALES_ID = ?', whereArgs: [id]);
  }

  Future<void> deleteAllCloroResidual() async {
    final db = await database;
    await db.delete('TRS_CLORO_RESIDUALES');
  }
  // END :: CLORO_RESIDUALES

  // BEGIN :: COMPONENTE_SAP
  Future<int> getNewIdComponenteSap() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_COMPONENTE_SAP',
      column: 'COMPONENTESAP_ID',
    );
    return newId;
  }

  Future<List<ComponenteSap>> listAllComponenteSap(
      {required bool enviado, String? filterByUser}) async {
    final db = await database;

    String wheres = 'ENVIADO = ?';
    List whereArgs = [enviado ? 1 : 0];
    if (filterByUser != null) {
      wheres = '$wheres AND USUARIO_REGISTRO = ?';
      whereArgs.add(filterByUser);
    }

    final list = await db.query(
      'TRS_COMPONENTE_SAP',
      where: wheres,
      whereArgs: whereArgs,
      orderBy: 'COMPONENTESAP_ID DESC',
    );

    return List<ComponenteSap>.from(
      list.map((e) => ComponenteSap.fromSQLite(e)),
    );
  }

  Future<ComponenteSap?> listComponenteSapById(int id) async {
    final db = await database;
    final list = await db.query('TRS_COMPONENTE_SAP',
        where: 'COMPONENTESAP_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? ComponenteSap.fromSQLite(list.first) : null;
  }

  Future<void> insertComponenteSap(ComponenteSap form) async {
    final db = await database;
    await db.insert('TRS_COMPONENTE_SAP', form.toSQLite());
  }

  Future<void> updateComponenteSap(ComponenteSap form) async {
    final db = await database;
    await db.update(
      'TRS_COMPONENTE_SAP',
      form.toSQLite(),
      where: 'COMPONENTESAP_ID = ?',
      whereArgs: [form.componentesapId],
    );
  }

  Future<void> deleteComponenteSapById(int id) async {
    final db = await database;
    await db.delete('TRS_COMPONENTE_SAP',
        where: 'COMPONENTESAP_ID = ?', whereArgs: [id]);
  }

  Future<void> deleteAllComponenteSap() async {
    final db = await database;
    await db.delete('TRS_COMPONENTE_SAP');
  }
  // END :: COMPONENTE_SAP

  // BEGIN :: CONTINUIDAD_SERVICIO
  Future<int> getNewIdContinuidadServicio() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CONTINUIDAD_SERVICIOS',
      column: 'CONTINUIDAD_SERVICIOS_ID',
    );
    return newId;
  }

  Future<List<ContinuidadServicio>> listAllContinuidadServicio(
      {required bool enviado, String? filterByUser}) async {
    final db = await database;

    String wheres = 'ENVIADO = ?';
    List whereArgs = [enviado ? 1 : 0];
    if (filterByUser != null) {
      wheres = '$wheres AND USUARIO_REGISTRO = ?';
      whereArgs.add(filterByUser);
    }

    final list = await db.query(
      'TRS_CONTINUIDAD_SERVICIOS',
      where: wheres,
      whereArgs: whereArgs,
      orderBy: 'CONTINUIDAD_SERVICIOS_ID DESC',
    );

    return List<ContinuidadServicio>.from(
      list.map((e) => ContinuidadServicio.fromSQLite(e)),
    );
  }

  Future<ContinuidadServicio?> listContinuidadServicioById(int id) async {
    final db = await database;
    final list = await db.query('TRS_CONTINUIDAD_SERVICIOS',
        where: 'CONTINUIDAD_SERVICIOS_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? ContinuidadServicio.fromSQLite(list.first) : null;
  }

  Future<void> insertContinuidadServicio(ContinuidadServicio form) async {
    final db = await database;
    await db.insert('TRS_CONTINUIDAD_SERVICIOS', form.toSQLite());
  }

  Future<void> updateContinuidadServicio(ContinuidadServicio form) async {
    final db = await database;
    await db.update(
      'TRS_CONTINUIDAD_SERVICIOS',
      form.toSQLite(),
      where: 'CONTINUIDAD_SERVICIOS_ID = ?',
      whereArgs: [form.continuidadServiciosId],
    );
  }

  Future<void> deleteContinuidadServicioById(int id) async {
    final db = await database;
    await db.delete('TRS_CONTINUIDAD_SERVICIOS',
        where: 'CONTINUIDAD_SERVICIOS_ID = ?', whereArgs: [id]);
  }

  Future<void> deleteAllContinuidadServicio() async {
    final db = await database;
    await db.delete('TRS_CONTINUIDAD_SERVICIOS');
  }
  // END :: CONTINUIDAD_SERVICIO

  // BEGIN :: CLORACIONES
  Future<int> getNewIdCloracion() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CLORACIONES',
      column: 'CLORACIONES_ID',
    );
    return newId;
  }

  Future<List<Cloracion>> listAllCloraciones(
      {required bool enviado, String? filterByUser}) async {
    final db = await database;

    String wheres = 'ENVIADO = ?';
    List whereArgs = [enviado ? 1 : 0];
    if (filterByUser != null) {
      wheres = '$wheres AND USUARIO_REGISTRO = ?';
      whereArgs.add(filterByUser);
    }

    final list = await db.query(
      'TRS_CLORACIONES',
      where: wheres,
      whereArgs: whereArgs,
      orderBy: 'CLORACIONES_ID DESC',
    );

    return List<Cloracion>.from(
      list.map((e) => Cloracion.fromSQLite(e)),
    );
  }

  Future<Cloracion?> listCloracionById(int id) async {
    final db = await database;
    final list = await db
        .query('TRS_CLORACIONES', where: 'CLORACIONES_ID = ?', whereArgs: [id]);
    return list.isNotEmpty ? Cloracion.fromSQLite(list.first) : null;
  }

  Future<void> insertCloracion(Cloracion form) async {
    final db = await database;
    await db.insert('TRS_CLORACIONES', form.toSQLite());
  }

  Future<void> updateCloracion(Cloracion form) async {
    final db = await database;
    await db.update(
      'TRS_CLORACIONES',
      form.toSQLite(),
      where: 'CLORACIONES_ID = ?',
      whereArgs: [form.cloracionesId],
    );
  }

  Future<void> deleteCloracionById(int id) async {
    final db = await database;
    await db.delete('TRS_CLORACIONES',
        where: 'CLORACIONES_ID = ?', whereArgs: [id]);
  }

  Future<void> deleteAllCloraciones() async {
    final db = await database;
    await db.delete('TRS_CLORACIONES');
  }
  // END :: CLORACIONES

  // BEGIN :: REL_CLORO_RESIDUALES_TIPO_IMAGENES
  Future<int> getNewIdImagenCloroResidual() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CLORO_RESIDUALES_TIPO_IMAGENES',
      column: 'IMAGEN_ID',
    );
    return newId;
  }

  Future<void> insertImagenCloroResidual(
      RelCloroResidualTipoImagen form) async {
    final db = await database;
    await db.insert('TRS_CLORO_RESIDUALES_TIPO_IMAGENES', form.toSQLite());
  }

  Future<List<RelCloroResidualTipoImagen>> listImagenCloroResidualByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    final list = await db.query(
      'TRS_CLORO_RESIDUALES_TIPO_IMAGENES',
      where: 'CLORO_RESIDUALES_ID = ?',
      whereArgs: [encuestaId],
    );
    return List<RelCloroResidualTipoImagen>.from(
      list.map((e) => RelCloroResidualTipoImagen.fromSQLite(e)),
    );
  }

  Future<void> deleteAllImagenCloroResidualByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    await db.delete(
      'TRS_CLORO_RESIDUALES_TIPO_IMAGENES',
      where: 'CLORO_RESIDUALES_ID = ?',
      whereArgs: [encuestaId],
    );
  }
  // END :: REL_CLORO_RESIDUALES_TIPO_IMAGENES

  // BEGIN :: REL_COMPONENTES_SAP_TIPO_IMAGENES
  Future<int> getNewIdImagenComponenteSap() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_COMPONENTES_SAP_TIPO_IMAGENES',
      column: 'IMAGEN_ID',
    );
    return newId;
  }

  Future<void> insertImagenComponenteSap(
      RelComponenteSapTipoImagen form) async {
    final db = await database;
    await db.insert('TRS_COMPONENTES_SAP_TIPO_IMAGENES', form.toSQLite());
  }

  Future<List<RelComponenteSapTipoImagen>> listImagenComponenteSapByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    final list = await db.query(
      'TRS_COMPONENTES_SAP_TIPO_IMAGENES',
      where: 'COMPONENTESAP_ID = ?',
      whereArgs: [encuestaId],
    );
    return List<RelComponenteSapTipoImagen>.from(
      list.map((e) => RelComponenteSapTipoImagen.fromSQLite(e)),
    );
  }

  Future<void> deleteAllImagenComponenteSapByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    await db.delete(
      'TRS_COMPONENTES_SAP_TIPO_IMAGENES',
      where: 'COMPONENTESAP_ID = ?',
      whereArgs: [encuestaId],
    );
  }
  // END :: REL_COMPONENTES_SAP_TIPO_IMAGENES

  // BEGIN :: REL_CLORACIONES_TIPO_IMAGENES
  Future<int> getNewIdImagenCloracion() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CLORACIONES_TIPO_IMAGENES',
      column: 'IMAGEN_ID',
    );
    return newId;
  }

  Future<void> insertImagenCloracion(RelCloracionTipoImagen form) async {
    final db = await database;
    await db.insert('TRS_CLORACIONES_TIPO_IMAGENES', form.toSQLite());
  }

  Future<List<RelCloracionTipoImagen>> listImagenCloracionByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    final list = await db.query(
      'TRS_CLORACIONES_TIPO_IMAGENES',
      where: 'CLORACIONES_ID = ?',
      whereArgs: [encuestaId],
    );
    return List<RelCloracionTipoImagen>.from(
      list.map((e) => RelCloracionTipoImagen.fromSQLite(e)),
    );
  }

  Future<void> deleteAllImagenCloracionByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    await db.delete(
      'TRS_CLORACIONES_TIPO_IMAGENES',
      where: 'CLORACIONES_ID = ?',
      whereArgs: [encuestaId],
    );
  }
  // END :: REL_CLORACIONES_TIPO_IMAGENES

  // BEGIN :: REL_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES
  Future<int> getNewIdImagenContinuidadServicio() async {
    final newId = await _getAvailablePrimaryKey(
      table: 'TRS_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES',
      column: 'IMAGEN_ID',
    );
    return newId;
  }

  Future<void> insertImagenContinuidadServicio(
      RelContinuidadServicioTipoImagen form) async {
    final db = await database;
    await db.insert('TRS_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES', form.toSQLite());
  }

  Future<List<RelContinuidadServicioTipoImagen>>
      listImagenContinuidadServicioByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    final list = await db.query(
      'TRS_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES',
      where: 'CONTINUIDAD_SERVICIOS_ID = ?',
      whereArgs: [encuestaId],
    );
    return List<RelContinuidadServicioTipoImagen>.from(
      list.map((e) => RelContinuidadServicioTipoImagen.fromSQLite(e)),
    );
  }

  Future<void> deleteAllImagenContinuidadServicioByEncuestaId(
    int encuestaId,
  ) async {
    final db = await database;
    await db.delete(
      'TRS_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES',
      where: 'CONTINUIDAD_SERVICIOS_ID = ?',
      whereArgs: [encuestaId],
    );
  }
  // END :: REL_CONTINUIDAD_SERVICIOS_TIPO_IMAGENES

  // Respaldo y restauración base de datos
  Future<void> backupDB() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    final storageStatus = await Permission.storage.status;

    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }

    try {
      // Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // final path = join(documentsDirectory.path, 'sirwash.db');

      final path = join(await getDatabasesPath(), 'sirwash.db');
      File dbFile = File(path);
      Directory folderPathForDbFile =
          Directory('/storage/emulated/0/SirwashDatabase/');
      await folderPathForDbFile.create();
      await dbFile.copy('/storage/emulated/0/SirwashDatabase/sirwash.db');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> restoreDB() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    final storageStatus = await Permission.storage.status;

    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }

    try {
      File savedDbFile = File('/storage/emulated/0/SirwashDatabase/sirwash.db');
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'sirwash.db');
      await savedDbFile.copy(path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<int> _getAvailablePrimaryKey(
      {required String table, required String column}) async {
    final db = await database;
    final rows =
        await db.rawQuery('SELECT MAX($column) + 1 AS NEXT_ID FROM $table');
    final nextId = (rows.first['NEXT_ID'] ?? 0) as int;
    return nextId;
  }
}
