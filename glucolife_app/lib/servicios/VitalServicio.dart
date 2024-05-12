import 'dart:async';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_devices/vital_devices.dart';
import 'package:permission_handler/permission_handler.dart';

/// Clase que maneja la lógica con la biblioteca Vital
class DeviceBloc extends ChangeNotifier {
  final DeviceManager dispositivosAdministradro;
  final DeviceModel deviceModel;

  bool isScanning = false;
  StreamSubscription? scanSubscription;

  List<ScannedDevice> connectedDevices = [];
  List<ScannedDevice> scannedDevices = [];
  List<QuantitySample> glucometroResultados = [];

  /// Constructor de la clase `DeviceBloc`.
  ///
  /// [context]: El contexto de la aplicación.
  /// [dispositivosAdministradro]: El administrador de dispositivos.
  /// [deviceModel]: El modelo del dispositivo.
  DeviceBloc(BuildContext context, this.dispositivosAdministradro, this.deviceModel) {
    dispositivosAdministradro.init();
    pedirPermisos();
    escanear(context);
  }

  /// Solicita permisos necesarios para el funcionamiento de la aplicación.
  void pedirPermisos() async {
    if (Platform.isIOS) {
      await Permission.bluetooth.request();
    } else {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }
  }

  /// Escanea dispositivos disponibles.
  ///
  /// [context]: El contexto de la aplicación.
  void escanear(BuildContext context) {
    dispositivosAdministradro.getConnectedDevices(deviceModel).then((devices) {
      connectedDevices = devices;
      notifyListeners();
    });

    scanSubscription =
        dispositivosAdministradro.scanForDevice(deviceModel).listen((newDevice) {
          if (!scannedDevices.contains(newDevice)) {
            scannedDevices.add(newDevice);
            notifyListeners();
          }
        }, onError: (error) {
          Fimber.i('Error al escanear los dispositivos: $error');
        });

    notifyListeners();
  }

  /// Detiene el escaneo de dispositivos.
  ///
  /// [context]: El contexto de la aplicación.
  void pararEscaneo(BuildContext context) {
    scanSubscription?.cancel();
    scanSubscription = null;
    notifyListeners();
  }

  /// Empareja el dispositivo seleccionado.
  ///
  /// [context]: El contexto de la aplicación.
  /// [scannedDevice]: El dispositivo escaneado que se va a emparejar.
  void conectar(BuildContext context, ScannedDevice scannedDevice) {
    Fimber.i('Request to pair device: ${scannedDevice.deviceModel.name}');

    dispositivosAdministradro.pair(scannedDevice).then((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Vinculación correcta")));
      Fimber.i('Vinculación correcta con el dispositivo: ${scannedDevice.deviceModel.name}');

      notifyListeners();
    }, onError: (error, stackTrace) {
      Fimber.i(error.toString(), stacktrace: stackTrace);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error al vincular: $error")));
    });
  }

  /// Lee los datos del dispositivo seleccionado.
  ///
  /// [context]: El contexto de la aplicación.
  /// [scannedDevice]: El dispositivo escaneado del cual se leerán los datos.
  void leerDatos(BuildContext context, ScannedDevice scannedDevice) {
    Fimber.i(
        'Request to read data from device: ${scannedDevice.deviceModel.name}');

    switch (scannedDevice.deviceModel.kind) {
      case DeviceKind.glucoseMeter:
        dispositivosAdministradro.readGlucoseMeterData(scannedDevice).then(
              (List<QuantitySample> newReadings) {
            Fimber.i(
                'Received ${newReadings.length} samples from device: ${scannedDevice.deviceModel.name}');

            for (var newReading in newReadings) {
              if (!glucometroResultados
                  .any((e) => e.startDate == newReading.startDate)) {
                glucometroResultados.add(newReading);
              }
            }

            glucometroResultados
                .sort((a, b) => b.startDate.compareTo(a.startDate));

            notifyListeners();
          },
          onError: (error, stackTrace) =>
              mostrarErrores(error, stackTrace, context),
        );
        break;
      case DeviceKind.bloodPressure:
      // TODO: Handle this case.
    }
    notifyListeners();
  }

  /// Muestra un mensaje de error al leer los datos.
  ///
  /// [error]: El error que ocurrió.
  /// [stackTrace]: El stacktrace del error.
  /// [context]: El contexto de la aplicación.
  void mostrarErrores(error, stackTrace, BuildContext context) {
    Fimber.i(error.toString(), stacktrace: stackTrace);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error al leer los datos: $error")));
  }

  /// Libera los recursos y limpia el administrador de dispositivos.
  @override
  void dispose() {
    dispositivosAdministradro.cleanUp();
    super.dispose();
  }
}
