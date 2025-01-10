import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/settings/db_conecction.dart';

class EspecialidadRepository {
  final String tableName = 'especialidad'; // Nombre de la tabla

  // Función para crear especialidad
  Future<int> create(Especialidad especialidad) async {
    try {
      return await DbConecction.insert(tableName, especialidad.toMap());
    } catch (e) {
      print('Error al crear especialidad');
      rethrow;
    }
  }

  // Función para listar especialidades
  Future<List<Especialidad>> list() async {
    try {
      var data = await DbConecction.list(tableName);
      if (data.isEmpty) {
        return List.empty(); // Devolver lista vacía si no hay datos
      }
      return List.generate(data.length, (indice) => Especialidad.fromMap(data[indice]));
    } catch (e) {
      print('Error al obtener lista de especialidades');
      rethrow;
    }
  }

  // Función para actualizar el estado de la especialidad
  Future<void> updateEstado(int id, int nuevoEstado) async {
    try {
      // Se ejecuta la actualización del estado usando el método `update`
      await DbConecction.update(
        tableName,
        {'estadoEspe': nuevoEstado}, // Datos a actualizar
        id, // Id de la especialidad
      );
    } catch (e) {
      print('Error al actualizar el estado de la especialidad');
      rethrow;
    }
  }
}
