import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/servicios/NutritionixService.dart';
import 'package:glucolife_app/viewmodel/alimentos_viewmodel.dart';
import 'package:glucolife_app/vistas/alimentacion/tarjeta_alimentacion.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';

class ItemDetailScreen extends StatefulWidget {
  final Alimentos product;

  ItemDetailScreen({required this.product});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int unidades = 1;
  final AlimentosViewModel viewModel = AlimentosViewModel();

  @override
  Widget build(BuildContext context) {
    USDAFood usdaFood = USDAFood(); // Instancia de la clase USDAFood

    double totalCalorias = double.parse((usdaFood.calcularCaloriasTotales([widget.product]) * unidades).toStringAsFixed(2));
    double totalProteinas = double.parse((usdaFood.calcularTotalProteinas([widget.product]) * unidades).toStringAsFixed(2));
    double totalGrasas = double.parse((usdaFood.calcularTotalGrasas([widget.product]) * unidades).toStringAsFixed(2));
    double totalCarbohidratos = double.parse(usdaFood.calcularTotalCarbohidratos([widget.product]).toStringAsFixed(2));

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Detalles del Alimento'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45.0),
            topRight: Radius.circular(45.0),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        widget.product.description,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: AssetImage('assets/imagenes/comida.webp'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TarjetaAlimentacion(
                            'Proteinas',
                            '$totalProteinas',
                            'g',
                          ),
                          TarjetaAlimentacion(
                            'Carbohidratos',
                            '$totalCarbohidratos',
                            'g',
                          ),
                          TarjetaAlimentacion(
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
              Expanded(
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TarjetaAlimentacion(
                          'Total Calorías',
                          '$totalCalorias',
                          'kcal',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                unidades++;
                              });
                            },
                            child: Text('Añadir unidad'),
                          ),
                          SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              if (unidades > 1) {
                                setState(() {
                                  unidades--;
                                });
                              }
                            },
                            child: Text('Quitar unidad'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Unidades: $unidades',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.agregarAlimentoAFirebase(
                      widget.product, unidades);
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
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
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
