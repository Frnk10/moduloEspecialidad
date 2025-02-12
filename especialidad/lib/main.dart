import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// INICIO ESPECIALIDAD
import 'package:especialidad/views/Especialidad/especialidad_form_view.dart';
import 'package:especialidad/views/Especialidad/especialidad_info_view.dart';
import 'package:especialidad/views/Especialidad/especialidades_listado_view.dart';
// FIN ESPECIALIDAD

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ocultar la etiqueta de debug
      title: "Módulo de Especialidad",
      initialRoute: '/especialidad/listado/',
      routes: {
        // INICIO ESPECIALIDAD
        '/especialidad/listado/': (context) => EspecialidadListadoView(),
        '/especialidad/info/': (context) => EspecialidadInfoView(),
        '/especialidad/form/': (context) => EspecialidadFormView(),
        // FIN ESPECIALIDAD
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
   builder: (context, child) {
        // Envolver la aplicación con un WidgetsBindingObserver para gestionar la barra de navegación
        return NavigationBarManager(child: child!);
      },
    );
  }
}
class NavigationBarManager extends StatefulWidget {
  final Widget child;
  // ignore: use_super_parameters
  const NavigationBarManager({Key? key, required this.child}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _NavigationBarManagerState createState() => _NavigationBarManagerState();
}
class _NavigationBarManagerState extends State<NavigationBarManager> {
  @override
  void initState() {
    super.initState();
    // Ocultar barra de navegación al iniciar la app
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (_) {
        // Detecta el deslizamiento hacia arriba
        _hideNavigationBar();
      },
      child: widget.child,
    );
  }
  // Función para ocultar la barra de navegación con un retraso
  void _hideNavigationBar() {
    Future.delayed(const Duration(seconds: 1), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    });
  }
}