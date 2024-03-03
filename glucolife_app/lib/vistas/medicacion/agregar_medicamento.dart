import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/medicamentos.dart';
import 'package:glucolife_app/viewmodel/medicacion.viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AgregarMedicamento extends StatefulWidget {
  const AgregarMedicamento({Key? key}) : super(key: key);

  @override
  State<AgregarMedicamento> createState() => _AgregarMedicamentoState();
}

class _AgregarMedicamentoState extends State<AgregarMedicamento> {
  final _formKey = GlobalKey<FormState>();
  MedicamentoViewModel _viewModel=MedicamentoViewModel();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();

  // Variables para la frecuencia
  String _frecuencia = 'Diaria';
  List<int> _diasSeleccionados = [];

  // Variables para el recordatorio
  bool _recordatorioActivado = false;
  Map<int, TimeOfDay> _horariosRecordatorio = {};

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: 'Nombre del medicamento'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre del medicamento es obligatorio';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dosisController,
              decoration: const InputDecoration(labelText: 'Dosis'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La dosis del medicamento es obligatoria';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fechaInicioController,
              decoration: const InputDecoration(labelText: 'Fecha de inicio'),
              readOnly: true,
              onTap: () async {
                DateTime? fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (fecha != null) {
                  final formattedDate = DateFormat('dd-MM-yyyy').format(fecha);
                  _fechaInicioController.text = formattedDate;
                }
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha de comienzo es obligatoria';
                  }
                  return null;
                };
              },
            ),

            // Sección de frecuencia
            const Divider(),
            Text('Frecuencia de toma'),
            DropdownButton<String>(
              value: _frecuencia,
              items: [
                DropdownMenuItem(
                  value: 'Diaria',
                  child: Text('Diaria'),
                ),
                DropdownMenuItem(
                  value: 'Semanal',
                  child: Text('Semanal'),
                ),
              ],
              onChanged: (value) => setState(() => _frecuencia = value!),
            ),
            if (_frecuencia != 'Diaria') ...[
              const SizedBox(height: 10.0),
              Text('Días de la semana'),
              for (int day = 1; day <= 7; day++)
                CheckboxListTile(
                  title: Text(_getDayName(day)),
                  value: _diasSeleccionados.contains(day),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _diasSeleccionados.add(day);
                      } else {
                        _diasSeleccionados.remove(day);
                      }
                    });
                  },
                ),
            ],

            // Sección de recordatorio
            const Divider(),
            SwitchListTile(
              title: const Text('Activar Recordatorio'),
              value: _recordatorioActivado,
              onChanged: (value) {
                setState(() {
                  _recordatorioActivado = value;
                });
              },
            ),
            if (_recordatorioActivado) ...[
              const SizedBox(height: 10.0),
              Text('Días y Horarios del Recordatorio'),
              if (_frecuencia == 'Diaria') ...{
                Column(
                  children: [
                    Text(
                      'Diario',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () async {
                        TimeOfDay? hora = await showTimePicker(
                          context: context,
                          initialTime: _horariosRecordatorio[1] ?? TimeOfDay.now(),
                        );
                        if (hora != null) {
                          setState(() {
                            // Guardar la misma hora para todos los días en frecuencia diaria
                            for (int day = 1; day <= 7; day++) {
                              _horariosRecordatorio[day] = hora;
                            }
                          });
                        }
                      },
                      child: Text(
                        'Hora del recordatorio: ${_horariosRecordatorio[1]?.hour ?? 12}:${_horariosRecordatorio[1]?.minute ?? 0}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              } else ...{
                for (int day in _diasSeleccionados)
                  Column(
                    children: [
                      Text(
                        '${_getDayName(day)}',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? hora = await showTimePicker(
                            context: context,
                            initialTime: _horariosRecordatorio[day] ?? TimeOfDay.now(),
                          );
                          if (hora != null) {
                            setState(() {
                              _horariosRecordatorio[day] = hora;
                            });
                          }
                        },
                        child: Text(
                          'Hora del recordatorio: ${_horariosRecordatorio[day]?.hour ?? 12}:${_horariosRecordatorio[day]?.minute ?? 0}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
              },
            ],

            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Crear una instancia de Medicamento con los datos
                  Medicamento medicamento = Medicamento(
                    nombre: _nombreController.text,
                    dosis: _dosisController.text,
                    fechaInicio: _fechaInicioController.text,
                    frecuencia: _frecuencia,
                    diasSeleccionados: _diasSeleccionados,
                    recordatorioActivado: _recordatorioActivado,
                    horaRecordatorio: TimeOfDay.now(),
                    // Puedes agregar más campos según los atributos de tu clase Medicamento
                  );

                  // Obtener el día actualmente seleccionado (si es aplicable)
                  int? day = _diasSeleccionados.isNotEmpty ? _diasSeleccionados[0] : null;

                  if (_recordatorioActivado && day != null) {
                    // Configurar la hora del recordatorio para el día seleccionado
                    medicamento.horaRecordatorio = _horariosRecordatorio[day] ?? TimeOfDay.now();
                  }

                  // Llamar al método en el viewmodel para agregar el medicamento a Firebase
                  await _viewModel.agregarMedicamentoAFirebase(medicamento);

                  // Mostrar un mensaje de éxito o navegar a otra pantalla, según tus necesidades
                  // Ejemplo: Navigator.of(context).pop();
                  // O muestra un SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Medicamento guardado con éxito en Firestore'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }
}
