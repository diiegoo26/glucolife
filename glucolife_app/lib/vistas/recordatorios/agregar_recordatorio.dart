import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/Recordatorio.dart';
import 'package:glucolife_app/viewmodel/medicaciones_viewmodel.dart';
import 'package:glucolife_app/viewmodel/recordatorios.viewmodel.dart';
import 'package:glucolife_app/vistas/recordatorios/visualizar_recordatorios.dart';

class AgregarRecordatorio extends StatefulWidget {
  @override
  _AgregarRecordatorioState createState() =>
      _AgregarRecordatorioState();
}

class _AgregarRecordatorioState
    extends State<AgregarRecordatorio> {
  DateTime _selectedDateTime = DateTime.now();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _scheduleNotification() async {
    try {
      await RecordatoriosViewModel.showDelayedNotification2(
        title: 'Recordatorio',
        body: _descriptionController.text,
        payload: 'Payload de la notificación',
        scheduledDateTime: _selectedDateTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Notificación programada con éxito')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programar recordatorio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String descripcion = _descriptionController.text;
                DateTime fecha=_selectedDateTime;
                RecordatoriosViewModel.agregarRecordatorioAFirebase(Recordatorio(
                  descripcion: descripcion,
                  fecha: fecha,
                ));
                _scheduleNotification(); // Llama al método para programar la notificación
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarRecordatorios(),
                  ),
                );
                print('Recordatorio almacenado: ${_descriptionController.text}');
              },
              child: Text('Agregar recuerdo'),
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
}
