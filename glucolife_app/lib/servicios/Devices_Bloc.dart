import 'package:flutter/material.dart';
import 'package:vital_devices/vital_devices.dart';

class DevicesBloc extends ChangeNotifier {
  /// Administrador de dispositivos.
  final DeviceManager dispositivosAdministrador;

  /// Lista de dispositivos de medición de glucosa.
  List<DeviceModel> glucometro = [];

  /// Constructor de la clase `DevicesBloc`.
  ///
  /// [dispositivosAdministrador]: El administrador de dispositivos.
  DevicesBloc(this.dispositivosAdministrador) {
    for (final device in dispositivosAdministrador.devices) {
      if (device.kind == DeviceKind.glucoseMeter) {
        glucometro.add(device);
      }
    }
  }
}
