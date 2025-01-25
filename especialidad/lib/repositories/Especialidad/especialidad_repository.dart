import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/settings/db_conecction.dart';

class EspecialidadRepository{
  final String tableName = 'especialidad'; //Envia dinamicamente el nombre de la tabla a afectar

  //Funcion para crear especialidad
  Future<int> create(Especialidad especialidad) async{
    //Manejo de errores
    try{
      return await DbConecction.insert(tableName, especialidad.toMap());
    }catch (e){
      // ignore: avoid_print
      print('Error al crear especialidad');
      rethrow;
    }
  }

  //Funcion para listar especialidades
  Future<List<Especialidad>> list() async{
    try{
      var data = await DbConecction.list(tableName);
      if(data.isEmpty){//Comprobrar si esta vacia la lista
        return List.empty(); //Devolver una lista vacia
      }
      return List.generate(data.length, (indice) => Especialidad.fromMap(data[indice])); //Transformar de lista a mapas
    }catch (e){
      // ignore: avoid_print
      print('Error al obtener lista de especialidades');
      rethrow;
    }
  } 

  //Funcion para actualizar especialidad
  Future<int> update(Especialidad especialidad) async{
    try{
      return await DbConecction.update(tableName, especialidad.toMap(),especialidad.id as int); // Llamado a la funcion update del DbConnection
    }catch (e){
      // ignore: avoid_print
      print('Error al actualizar la especialidad');
      rethrow;
    }
  }

  // Funcion para actualizar campos especificos en este caso el estado de la especialidad
  Future<int> updateEstado(int id) async{
    try{
      // Mapa con el campo 'estado' y su nuevo valor
      Map<String, dynamic> data = {'estadoEspe': 0};
      String condicion = 'id = ?'; // Se usa '?' como marcador de posición para el valor de id
      List<dynamic> arguments = [id]; // Argumentos para la condición
      int filas = await DbConecction.updateFields(tableName, data, condicion, arguments); // Llamado funcion updateFields
      return filas;
    } catch (e){
      // ignore: avoid_print
      print('Error al actualizar el estado de la especialidad $id: $e');
      rethrow;
    }
  }

  //Funcion para eliminar especialidad
  Future<int> delete(int id) async{
    try{
      return await DbConecction.delete(tableName, id); // Llamado a la funcion delete del DbConnection
    }catch (e){
      // ignore: avoid_print
      print('Error al eliminar la especialidad');
      rethrow;
    }
  }

}