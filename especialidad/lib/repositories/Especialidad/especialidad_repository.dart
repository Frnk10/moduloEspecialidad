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


}