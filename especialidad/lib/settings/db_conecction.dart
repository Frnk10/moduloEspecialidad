import 'package:sqflite/sqflite.dart'; //Importar conexion a sqflite
import 'package:path/path.dart'; //Importar gestor de rutas

class DbConecction {
  static const vesrion = 1; //
  static const String dbname = "hospital.db"; //Nombre BDD

  //Variable asincrona: cargar datos intermitentemente
  static Future<Database> conectionDataBase() async{
    return openDatabase(
      join(await getDatabasesPath(),dbname), //Estandarizar ruta de la BDD en el movil
      version: vesrion,
      onCreate: (db, version) async =>{ //Verifica si tiene una BDD creada y sino la crea.
        await db.execute("""
          CREATE TABLE especialidad(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreEspe TEXT NOT NULL,
            descripcionEspe TEXT NOT NULL,
            ordenEspe INTEGER,
            estadoEspe INTEGER NOT NULL,
            imagenEspe BLOB,
            fechaCreacionEspe DATETIME DEFAULT CURRENT_TIMESTAMP,
            fechaActualizacionEspe DATETIME DEFAULT CURRENT_TIMESTAMP
          );
        """),
        await db.execute("""
          CREATE TRIGGER actualizarFecha 
          AFTER UPDATE ON especialidad
          FOR EACH ROW
          BEGIN
            UPDATE especialidad SET fechaActualizacionEspe = CURRENT_TIMESTAMP WHERE id = OLD.id;
          END;
        """),
        await db.execute("""
          INSERT INTO especialidad(nombreEspe,descripcionEspe,ordenEspe,estadoEspe) VALUES
          ('Odontología','Cuidar tus dientes',1,1);
        """)
      }
    );
  }

  //Insertar usando helper
  static Future<int> insert(String tableName, dynamic data) async{
    final db = await conectionDataBase(); //Establecer conexion con la base de datos
    return db.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Insertar usando sentencias SQL
  static Future<int> insertSql(String sql) async{
    final db = await conectionDataBase();
    return db.rawInsert(sql); 
  }

  //Actualizar usando helper
  static Future<int> update(String tableName, dynamic data, int id) async{
    final db = await conectionDataBase();
    return db.update(
      tableName,
      data,
      where: "id = ?", //Id indica que registro actualizar
      whereArgs: [id], //Argumentos en orden para la ejecucion
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  //Actualizar usando sentencias SQL
  static Future<int> updateSql(String sql) async{
    final db = await conectionDataBase();
    return db.rawUpdate(sql);
  }
  
  //Elimninar usando helper
  static Future<int> delete(String tableName, int id) async{
    final db = await conectionDataBase();
    return db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  //Eliminar usando sentencias SQL
  static Future<int> deleteSql(String sql) async{
    final db = await conectionDataBase();
    return db.rawDelete(sql);
  }

  //Listar usando helper
  static Future<List<Map<String, dynamic>>> list(String tableName) async{
    final db = await conectionDataBase();
    return await db.query(tableName,orderBy: 'id');
  }

  //Listar usando sentencias SQL
  static Future<List<Map<String, dynamic>>> listSql(String sql) async{
    final db = await conectionDataBase();
    return db.rawQuery(sql);
  }
}
