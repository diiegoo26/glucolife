import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/medicamento.dart';
import 'package:glucolife_app/servicios/MedicamentoServicio.dart';
import 'package:glucolife_app/servicios/NotificacionServicio.dart';
import 'package:glucolife_app/viewmodel/medicamentos_viewmodel.dart';
import 'package:glucolife_app/viewmodel/notificacion_viewmodel.dart';
import 'package:glucolife_app/vistas/medicacion/visualizar_medicamentos.dart';

class AgregarMedicamentos extends StatefulWidget {
  @override
  _AgregarMedicamentosState createState() => _AgregarMedicamentosState();
}

class _AgregarMedicamentosState extends State<AgregarMedicamentos> {
  MedicamentoViewModel _medicamentoViewModel = MedicamentoViewModel(medicamentoServicio: MedicamentoServicio());
  NotificacionViewModel _notificacionViewModel = NotificacionViewModel(notificacionServicio: NotificacionServicio());
  String? _selectedIntervalo;
  String? _intervaloPersonalizado;
  TextEditingController _nombreMedicamentoController = TextEditingController();
  TextEditingController _dosisController = TextEditingController();

  List<String> intervalos = [
    'Cada 6 horas',
    'Cada 12 horas',
    'Cada 24 horas',
    'Diariamente',
    'Semanalmente',
    'Personalizado'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Medicamento'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre del medicamento'),
              controller: _nombreMedicamentoController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Dosis'),
              keyboardType: TextInputType.number,
              controller: _dosisController,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Intervalo'),
              value: _selectedIntervalo,
              items: intervalos.map((String intervalo) {
                return DropdownMenuItem(
                  value: intervalo,
                  child: Text(intervalo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIntervalo = value as String?;
                  if (_selectedIntervalo == 'Personalizado') {
                    _intervaloPersonalizado = null;
                  }
                });
              },
            ),
            if (_selectedIntervalo == 'Personalizado')
              TextFormField(
                decoration: InputDecoration(labelText: 'Intervalo Personalizado (segundos)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _intervaloPersonalizado = value;
                  });
                },
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String nombreMedicamento = _nombreMedicamentoController.text;
                  int dosis = int.tryParse(_dosisController.text) ?? 0;
                  String intervalo = _selectedIntervalo == 'Personalizado' ? _intervaloPersonalizado ?? '' : _selectedIntervalo ?? '';
                  /// Llamada al servicio para agregar el medicamento en Firebase
                  _medicamentoViewModel.agregarMedicamento(Medicamento(
                    nombre: nombreMedicamento,
                    dosis: dosis,
                    intervalo: intervalo,
                  ));
                  mostrarNotificaciones();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisualizarMedicamentos(),
                    ),
                  );
                  print('Medicamentos almacenado: ${_nombreMedicamentoController.text}');
                },
                child: Text(
                  'Registrar Medicamento',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Para mostrar las notificaciones
  void mostrarNotificaciones() {
    if (_selectedIntervalo != null && _intervaloPersonalizado != null && _intervaloPersonalizado!.isNotEmpty) {
      int intervalo = int.tryParse(_intervaloPersonalizado!) ?? 0;
      if (intervalo > 0) {
        String nombreMedicamento = _nombreMedicamentoController.text;
        String dosis = _dosisController.text;
        String intervaloTexto = 'cada $_intervaloPersonalizado segundos';
        String titulo = 'Nuevo medicamento registrado';
        String cuerpo = 'Medicamento: $nombreMedicamento\nDosis: $dosis\nIntervalo: $intervaloTexto';
        /// Llamada el servicio para generar la notificacion
        _notificacionViewModel.mostrarNotificacionMedicamentos(
            titulo: titulo,
            cuerpo: cuerpo,
            payload: 'payload',
            frecuencia: NotificationFrequency.custom,
            intervaloPersonalizado: intervalo,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Medicamento registrado exitosamente!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
