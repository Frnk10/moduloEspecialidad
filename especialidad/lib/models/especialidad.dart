import 'dart:convert';
import 'dart:typed_data';

class Especialidad {
  //Atributos
  int? id;
  String nombreEspe;
  String descripcionEspe;
  int? ordenEspe;
  int? estadoEspe;
  Uint8List? imagenEspe; //Atributo para la imagen
  DateTime? fechaCreacionEspe; //Atributo para las fechas
  DateTime? fechaActualizacionEspe;

  
  //Constructor
  Especialidad({
    this.id,
    required this.nombreEspe,
    required this.descripcionEspe,
    this.ordenEspe,
    required this.estadoEspe,
    this.imagenEspe,
    required this.fechaCreacionEspe,
    required this.fechaActualizacionEspe
  });

  //Funciones

  //Funcion para convertir de Class a Map(insert,update)
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nombreEspe': nombreEspe,
      'descripcionEspe': descripcionEspe,
      'ordenEspe': ordenEspe,
      'estadoEspe': estadoEspe,
      'imagenEspe': imagenEspe != null ? base64Encode(imagenEspe!) : null, //Convertir a formato correcto
      'fechaCreacionEspe': fechaCreacionEspe?.toIso8601String(), // Formato ISO 8601 - 2024-12-28T15:30:00 puede ser facilmente parseable
      'fechaActualizacionEspe': fechaActualizacionEspe?.toIso8601String()
    };
  }

  //Funcion para convertir de Mapa a Class(select)
  static Especialidad fromMap(Map<String, dynamic> map){
    return Especialidad(
      id: map['id'],
      nombreEspe: map['nombreEspe'],
      descripcionEspe: map['descripcionEspe'],
      ordenEspe: map['ordenEspe'],
      estadoEspe: map['estadoEspe'],
      imagenEspe: map['imagenEspe'] != null ? base64Decode(map['imagenEspe']) : null,
      fechaCreacionEspe: map['fechaCreacionEspe'] !=null //Fechas recuperadas como cadenas de texto
        ? DateTime.parse(map['fechaCreacionEspe']) //Las cadenas se convierten a objetos DateTime
        : null,
      fechaActualizacionEspe: map['fechaActualizacionEspe'] !=null
        ? DateTime.parse(map['fechaActualizacionEspe'])
        : null,
    );
  }
}