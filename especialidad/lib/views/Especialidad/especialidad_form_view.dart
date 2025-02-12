import 'dart:io';
import 'package:flutter/material.dart';
import 'package:especialidad/views/EstructuraEstilos/nav_bar.dart'; // NavBar
import 'package:especialidad/views/EstructuraEstilos/formulario_funciones.dart'; // Funciones para el Formulario
import 'package:especialidad/models/especialidad.dart'; // Models
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart'; // Repositorios

class EspecialidadFormView extends StatefulWidget {
  const EspecialidadFormView({super.key});

  @override
  State<EspecialidadFormView> createState() => _EspecialidadFormViewState();
}

class _EspecialidadFormViewState extends State<EspecialidadFormView>{
  Especialidad? _especialidad; // Declarar clase especialidad
  final _formEspecialidadKey = GlobalKey<FormState>(); //Clave global: transaccionar datos del formulario
  //Controladores para los campos de especialidad
  final nombreEspeController = TextEditingController();
  final descripcionEspeController = TextEditingController();
  final ordenEspeController = TextEditingController();
  bool estado = true; //Variable para switch con estado inicial true
  final imagenEspeController = TextEditingController();
  // Instanciar la clase que gestiona la funciones para imagenes
  final ImagePickerHelper imagePickerHelper = ImagePickerHelper();
  File? _imagenSeleccionada; //Guarda la imagen seleccionada como un objeto File

  // Color del cursor de escritura global
  final _colorCursor = const Color.fromARGB(255, 105, 103, 103);
  // Metodo para seleccionar la imagen
  void _seleccionarImagen(File imagen) {
    setState(() {
      _imagenSeleccionada = imagen;
      imagenEspeController.text = imagen.path;
    });
  }
  @override
  Widget build(BuildContext context) {
    _especialidad = ModalRoute.of(context)!.settings.arguments as Especialidad?; // Atrapar los argumentos de especialidad
    if(_especialidad != null){ // Verificar si especialidad tiene datos
      // Cargar los datos de especialidad a los controladores
      nombreEspeController.text = _especialidad!.titulo; // Cargar nombre de especialidad
      descripcionEspeController.text = _especialidad!.descripcion;
      ordenEspeController.text = _especialidad!.orden.toString();
      _especialidad!.estado == 1 ? estado= true : estado=false;
      imagenEspeController.text = _especialidad!.imagen ?? ''; // Asignar la ruta de la imagen al controlador
    }
    return NavBar(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size:40.0),
          onPressed: (){
            Navigator.pushNamed(context,'/especialidad/listado/');
          }, 
        ),            
        title: Text(_especialidad == null ? "Crear Especialidad" : "Actualizar Especialidad", //Verifica y cambia el titulo
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20), // Espacio entre el body y el nav
        child: Form(
          key: _formEspecialidadKey, //Asignar clave global al formulario, (token)
          child: ListView(
            children: [
              Text(
                "Especialidad",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height:25),
              FormularioFunciones.textFormFieldTipo1(
                nombreEspeController,
                maxLength:25,
                'Nombre de la especialidad',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dato obligatorio'; // Mensaje de error si el campo está vacío
                  }
                  // Verificar que la longitud esté entre 5 y 25 caracteres
                  if (value.length < 5 || value.length > 25) {
                    return 'El nombre debe tener entre 5 y 25 caracteres';
                  }
                  // Expresión regular para validar solo letras, tildes, ñ y espacios (sin números)
                  RegExp regExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$');
                  if (!regExp.hasMatch(value)) {
                    return 'El nombre no puede contener caracteres especiales';
                  }
                  return null;
                },
              ),
              SizedBox(height: 35), // Espacio entre textfields
              FormularioFunciones.textFormFieldTipo2(
                descripcionEspeController,
                'Descripción',
                maxLength: 25,
                validator:  (value) {
                   // Verificar que el valor no esté vacío
                  if (value == null || value.isEmpty) {
                    return 'Dato obligatorio';
                  }
                  // Expresión regular para validar letras, tildes, ñ, y mayúsculas
                  RegExp regExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$');
                  if (!regExp.hasMatch(value)) {
                    return 'Descripción no debe contener caracteres especiales';
                  }
                  return null; // Si la validación pasa, no hay errores
                }
              ),
              SizedBox(height:25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, //Alineacion de los elementos en el Row
                children: [
                  Expanded( //Que los elementos ocupen el espacio del row, column o flex
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center, //Alinea los elementos dentro de la columna a la izquierda
                      children: [
                        Text(
                          "Orden",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height:2),
                        SizedBox(// Para definir el ancho de un textfield
                          width: 100,
                          child: TextFormField(
                            controller: ordenEspeController, //Controlador para el orden
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: _colorCursor, //Color del cursor de escritura
                            readOnly: true, //Campo de solo lectura
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 227, 231, 1),
                                  width: 2
                                )
                              ),
                              hintText: 'Id',
                              hintStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)), //Color del hintText
                              focusedBorder: OutlineInputBorder( //Efecto hover para borde
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 227, 231, 1),
                                  width: 2
                                )
                              ),
                            ),
                            //Aqui validacion
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Text(
                          "Estado",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:4),
                        Switch(
                          value: estado, //Valor del switch (true) por defecto
                          activeColor: Colors.white, //Color boton cuando esta activa
                          activeTrackColor: const Color.fromRGBO(46, 154, 172, 1), // Color pista cuando esta activada
                          onChanged: (bool newEstado){
                            setState((){
                              estado = newEstado; //Actualiza el estado del switch pulsandolo
                              if (_especialidad != null) {
                                _especialidad!.estado = newEstado ? 1 : 0;
                              } 
                            });
                          }
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              SizedBox(height:35),
              // Seccionar de imagen
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Imagen:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () => imagePickerHelper.mostrarModal(context, _seleccionarImagen), // Mostrar modal
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imagenSeleccionada != null
                          ? FileImage(_imagenSeleccionada!)
                          : imagenEspeController.text.isNotEmpty
                            ? FileImage(File(imagenEspeController.text)) // Cargar la imagen desde la ruta
                            : null, // Si no hay imagen, mostrar un fondo transparente
                        child: _imagenSeleccionada == null && imagenEspeController.text.isEmpty 
                          ? const Icon(Icons.add_a_photo, size: 32)
                          : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45),
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async{
                          if(_formEspecialidadKey.currentState!.validate()){
                            //Convertir el estado del switch (true o false) a 1 o 0
                            int estadoEspecialidad = estado ? 1 : 0;
                            // ✅ Mantener la imagen existente si no se selecciona una nueva
                            String imagenFinal = _imagenSeleccionada != null ? _imagenSeleccionada!.path  : (_especialidad?.imagen ?? '');
                            //Objeto con datos recopilados
                            Especialidad especialidad = Especialidad(
                              titulo: nombreEspeController.text,
                              descripcion: descripcionEspeController.text,
                              orden: int.parse(ordenEspeController.text),
                              estado: estadoEspecialidad,
                              imagen: imagenFinal, //Guardar la ruta de la imagen
                              fechaCreacion: _especialidad == null ? DateTime.now().toLocal() : _especialidad!.fechaCreacion,
                            );
                            int resultado; //Variable para mostrar id de especialidad cuando se crea o actualiza
                            if(_especialidad == null){
                              try{
                                resultado = await EspecialidadRepository().create(especialidad); //Llamar a la funcion para crear una especialidad
                                // ignore: avoid_print
                                print('El id de la especialidad es: ${resultado.toString()}');
                              }catch(e){
                                // ignore: avoid_print
                                print('Error al crear la especialidad: $e');
                              }
                            }else{
                              // Si la espeecialidad ya existe, actualizarla
                              try{
                                especialidad.id = _especialidad!.id;
                                resultado =  await EspecialidadRepository().update(especialidad); //Llamar a la funcion para crear una especialidad
                                // ignore: avoid_print
                                print('El id de la especialidad actualizada: ${resultado.toString()}');
                              }catch(e){
                                // ignore: avoid_print
                                print('Error al actualizar la especialidad: $e');
                              }
                            }
                            if(context.mounted){
                              Navigator.pushNamed(context,'/especialidad/listado/'); //Redirige a la ventana principal
                            }                           
                          }
                        },
                        icon: Icon(Icons.save,color: Colors.white,size: 40),
                        label: Text(_especialidad == null ? "Guardar" : "Aceptar",
                          style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w600)
                        ),
                        iconAlignment: IconAlignment.start, //Posicion del icono (izquierdo)
                        style: ElevatedButton.styleFrom(//Estilo para el boton
                          backgroundColor: Color.fromRGBO(73, 182, 199, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        )
                      ),
                    )
                  ),
                  SizedBox(width:16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: (){
                          Navigator.pushNamed(context,'/especialidad/listado/');
                        },
                        icon: Icon(Icons.cancel_rounded, color: Colors.white,size:40),
                        label: Text("Cancelar", style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.start, // Posicion del icono al inicio (izquierda)
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 52, 58, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        )
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //NavBar
      indiceSeleccion: 0, //Indice principal del navBar
      onNavTap: (indice){
        if(indice == 0){
          Navigator.pushNamed(context,'/especialidad/listado/');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form/');
        }
      },
    );
  }
}


