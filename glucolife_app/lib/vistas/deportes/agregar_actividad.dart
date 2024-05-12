import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/actividad.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/viewmodel/actividad_viewmodel.dart';
import 'package:glucolife_app/vistas/deportes/visualizar_actividad.dart';
import 'package:provider/provider.dart';

class AgregarActividadVista extends StatefulWidget {
  final Actividad ejercicio;

  AgregarActividadVista({required this.ejercicio});
  @override
  _AgregarActividadVistaState createState() => _AgregarActividadVistaState();
}

class _AgregarActividadVistaState extends State<AgregarActividadVista> {
  late String _selectedTiempo;
  late String _selectedIntensidad;
  double _caloriasQuemadas = 0.0;

  final ActividadViewModel _actividadViewModel = ActividadViewModel();

  List<String> intensidades = ['Baja', 'Moderada', 'Alta'];
  List<String> tiempos = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
    '90 min',
    '120 horas'
  ];

  @override
  void initState() {
    super.initState();
    _selectedTiempo = widget.ejercicio.tiempoRealizado;
    _selectedIntensidad = widget.ejercicio.intensidad;

    if (!tiempos.contains(_selectedTiempo)) {
      _selectedTiempo = tiempos.first;
    }

    if (!intensidades.contains(_selectedIntensidad)) {
      _selectedIntensidad = intensidades.first;
    }
  }

  /// Llamada al servicio para calcular las calorias consumidas
  void calcularYMostrarCalorias() {
    double caloriasQuemadas = _actividadViewModel.calcularTotalCaloriasQuemadas(
        _selectedTiempo, _selectedIntensidad);
    setState(() {
      _caloriasQuemadas = caloriasQuemadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Llamada al provider para poder mantener la vista actualizada
    final fechaSeleccionada =
        Provider.of<SeleccionarFechaProvider>(context).seleccionarFecha;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Ejercicio'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nombre del ejercicio:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.ejercicio.nombre,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            Text(
              'Tiempo realizado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuTheme(
                data: PopupMenuThemeData(
                  color: Colors.grey[200],
                ),
                child: DropdownButton<String>(
                  value: _selectedTiempo,
                  items: tiempos.map((String tiempo) {
                    return DropdownMenuItem<String>(
                      value: tiempo,
                      child: Text(
                        tiempo,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedTiempo = value!;
                    });
                  },
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 32,
                  elevation: 16,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.grey[200],
                  selectedItemBuilder: (BuildContext context) {
                    return tiempos.map<Widget>((String tiempo) {
                      return Center(
                        child: Text(
                          _selectedTiempo,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Intensidad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuTheme(
                data: PopupMenuThemeData(
                  color: Colors.grey[200],
                ),
                child: DropdownButton<String>(
                  value: _selectedIntensidad,
                  items: intensidades.map((String intensidad) {
                    return DropdownMenuItem<String>(
                      value: intensidad,
                      child: Text(
                        intensidad,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedIntensidad = value!;
                    });
                  },
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 32,
                  elevation: 16,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.grey[200],
                  selectedItemBuilder: (BuildContext context) {
                    return intensidades.map<Widget>((String intensidad) {
                      return Center(
                        child: Text(
                          _selectedIntensidad,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: calcularYMostrarCalorias,
              child: Text('Calcular Calorías Quemadas'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Calorías Quemadas: $_caloriasQuemadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  widget.ejercicio.tiempoRealizado = _selectedTiempo;
                  widget.ejercicio.intensidad = _selectedIntensidad;
                  widget.ejercicio.caloriasQuemadas = _caloriasQuemadas;
                });

                /// Llamada al servicio para almacenar la actividad en Firebase
                await Provider.of<ActividadViewModel>(context, listen: false)
                    .guardarActividad(widget.ejercicio, fechaSeleccionada);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarActividad(),
                  ),
                );
              },
              child: Text('Agregar actividad física'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
