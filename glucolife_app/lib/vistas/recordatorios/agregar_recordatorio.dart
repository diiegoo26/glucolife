import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/recordatorio.dart';
import 'package:glucolife_app/servicios/NotificacionServicio.dart';
import 'package:glucolife_app/servicios/RecordatorioServicio.dart';
import 'package:glucolife_app/viewmodel/notificacion_viewmodel.dart';
import 'package:glucolife_app/viewmodel/recordatorio_viewmodel.dart';
import 'package:glucolife_app/vistas/recordatorios/visualizar_recordatorios.dart';

class AgregarRecordatorio extends StatefulWidget {
  @override
  _AgregarRecordatorioState createState() => _AgregarRecordatorioState();
}

class _AgregarRecordatorioState extends State<AgregarRecordatorio> {
  RecordatorioViewModel _recordatorioViewModel = RecordatorioViewModel(recordatorioServicio: RecordatorioServicio());
  NotificacionViewModel _notificacionViewModel = NotificacionViewModel(notificacionServicio: NotificacionServicio());
  DateTime _selectedDateTime = DateTime.now();
  TextEditingController _descriptionController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programar recordatorio'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: _selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDateTime != null) {
                  setState(() {
                    _selectedDateTime = DateTime(
                      pickedDateTime.year,
                      pickedDateTime.month,
                      pickedDateTime.day,
                      _selectedDateTime.hour,
                      _selectedDateTime.minute,
                    );
                  });
                }
              },
              child: Text('Seleccionar Fecha'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedDateTime = DateTime(
                      _selectedDateTime.year,
                      _selectedDateTime.month,
                      _selectedDateTime.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              },
              child: Text('Seleccionar Hora'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String descripcion = _descriptionController.text;
                DateTime fecha = _selectedDateTime;
                /// Llamada al servicio para almacenar el recordatorio en Firebase
                _recordatorioViewModel.agregarRecordatorio(Recordatorio(descripcion: descripcion,fecha: fecha));
                _scheduleNotification(); // Llama al método para programar la notificación
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarRecordatorios(),
                  ),
                );
                print('Recordatorio almacenado: ${_descriptionController.text}');
              },
              child: Text('Agregar recordatorio'),
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

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _scheduleNotification() async {
    try {
      /// Llamada al servicio para mostrar la notificacion
      await _notificacionViewModel.mostrarNotificacionRecordatorios(
        titulo: 'Recordatorio',
        cuerpo: _descriptionController.text,
        frecuencia: NotificationFrequency.daily,
        payload: 'Payload de la notificación',
        scheduledDateTime: _selectedDateTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notificación programada con éxito'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
