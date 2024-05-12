import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/provider/provider_fecha.dart';
import 'package:glucolife_app/viewmodel/alimentos_viewmodel.dart';
import 'package:glucolife_app/vistas/alimentacion/tarjeta_alimentacion.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';
import 'package:provider/provider.dart';

class AgregarAlimentoVista extends StatefulWidget {
  final Alimentos producto;

  AgregarAlimentoVista({required this.producto});

  @override
  _AgregarAlimentoVistaState createState() => _AgregarAlimentoVistaState();
}

class _AgregarAlimentoVistaState extends State<AgregarAlimentoVista> {
  int unidades = 1;
  final AlimentosViewModel _alimentosViewModel = AlimentosViewModel();

  @override
  Widget build(BuildContext context) {
    /// Llamada al provider para poder mantener la vista actualizada
    final fechaSeleccionada =
        Provider.of<SeleccionarFechaProvider>(context).seleccionarFecha;

    /// Llamada al servico para calcular los valores nutricionales totales
    double totalCalorias =
        _alimentosViewModel.calcularTotalCalorias(widget.producto, unidades);

    /// Llamada al servico para calcular las proteinas totales
    double totalProteinas =
        _alimentosViewModel.calcularTotalProteinas(widget.producto, unidades);

    /// Llamada al servico para calcular las grasas totales
    double totalGrasas =
        _alimentosViewModel.calcularTotalGrasas(widget.producto, unidades);

    /// Llamada al servico para calcular los carbohidratos
    double totalCarbohidratos = _alimentosViewModel.calcularTotalCarbohidratos(
        widget.producto, unidades);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Alimento'),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.producto.descripcion,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            AssetImage('assets/imagenes/comida.webp'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TarjetaAlimentacionVista(
                            'Proteinas',
                            '$totalProteinas',
                            'g',
                          ),
                          TarjetaAlimentacionVista(
                            'Carbohidratos',
                            '$totalCarbohidratos',
                            'g',
                          ),
                          TarjetaAlimentacionVista(
                            'Grasas',
                            '$totalGrasas',
                            'g',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.0),
                          TarjetaAlimentacionVista(
                            'Total Calorías',
                            '$totalCalorias',
                            'kcal',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unidades: $unidades',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                unidades--;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.green,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.remove),
                                SizedBox(width: 4),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                unidades++;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.green,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  /// Llamada al servicio para almacenar el alimento en Firebase
                  await _alimentosViewModel.agregarAlimentoAFirebase(
                      widget.producto, unidades, fechaSeleccionada);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisualizarAlimentos(),
                    ),
                  );
                },
                child: Text(
                  'Agregar alimento',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      ),
    );
  }
}
