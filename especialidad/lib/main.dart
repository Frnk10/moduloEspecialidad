import 'package:especialidad/views/Especialidad/especialidad_nueva.dart';
import 'package:especialidad/views/Especialidad/listar_especialidades.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ocultar la etiqueta de debug
      title: "Módulo de Especialidad",
      initialRoute: '/especialidad/index',
      routes: {
        '/especialidad/index': (context) => ListarEspecialidad(),
        '/especialidad/form': (context) => const EspecialidadNueva(),
      },
      theme: ThemeData( //Configuración global para modulos
        fontFamily: 'Prompt', //Tipo de letra
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme( //Color de fondo
          backgroundColor: Color(0xFF142e38),
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize:22,fontWeight: FontWeight.bold,fontFamily: 'Prompt')
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(fontFamily: 'Prompt'),
          bodyMedium: TextStyle(fontFamily: 'Prompt'),
          bodyLarge: TextStyle(fontFamily: 'Prompt'),
          headlineSmall: TextStyle(fontFamily: 'Prompt'),
          headlineMedium: TextStyle(fontFamily: 'Prompt'),
          headlineLarge: TextStyle(fontFamily: 'Prompt'),
        ),
      ),
    );
  }
}
