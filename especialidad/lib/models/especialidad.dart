class Especialidad {
  //Atributos
  int? id;
  String titulo;
  String descripcion;
  int? orden;
  int? estado;
  String? imagen;
  DateTime? fechaCreacion; //Atributo para las fechas
  DateTime? fechaActualizacion;

  
  //Constructor
  Especialidad({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.orden,
    required this.estado,
    this.imagen,
    this.fechaCreacion,
    this.fechaActualizacion
  });

  //Funciones

  //Funcion para convertir de Class a Map(insert,update)
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nombreEspe': titulo,
      'descripcionEspe': descripcion,
      'ordenEspe': orden,
      'estadoEspe': estado,
      'imagenEspe': imagen,
      'fechaCreacionEspe': fechaCreacion?.toIso8601String(), // Formato ISO 8601 - 2024-12-28T15:30:00 puede ser facilmente parseable
      'fechaActualizacionEspe': fechaActualizacion?.toIso8601String()
    };
  }

  //Funcion para convertir de Mapa a Class(select)
  static Especialidad fromMap(Map<String, dynamic> map){
    return Especialidad(
      id: map['id'],
      titulo: map['nombreEspe'],
      descripcion: map['descripcionEspe'],
      orden: map['ordenEspe'],
      estado: map['estadoEspe'],
      imagen: map['imagenEspe'],
      fechaCreacion: map['fechaCreacionEspe'] !=null //Fechas recuperadas como cadenas de texto
        ? DateTime.parse(map['fechaCreacionEspe']) //Las cadenas se convierten a objetos DateTime
        : null,
      fechaActualizacion: map['fechaActualizacionEspe'] !=null
        ? DateTime.parse(map['fechaActualizacionEspe'])
        : null,
    );
  }
}