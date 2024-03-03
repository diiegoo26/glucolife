import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/servicios/NutritionixService.dart';
import 'package:glucolife_app/vistas/alimentacion/agregar_alimento.dart';

class BuscadorAlimentos extends StatefulWidget {
  @override
  _BusquedaAlimentosState createState() => _BusquedaAlimentosState();
}

class _BusquedaAlimentosState extends State<BuscadorAlimentos> {
  TextEditingController _controladorBusqueda = TextEditingController();
  USDAFood _usdaFood = USDAFood();
  List<Alimentos> _resultadosBusqueda = [];

  void _alTocarResultadoBusqueda(Alimentos producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(product: producto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador'),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorBusqueda,
              onChanged: _enCambioTextoBusqueda,
              decoration: InputDecoration(
                labelText: 'Buscar comida',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _resultadosBusqueda.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_resultadosBusqueda[index].description),
                    onTap: () =>
                        _alTocarResultadoBusqueda(_resultadosBusqueda[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enCambioTextoBusqueda(String query) async {
    List<Alimentos> resultados = await _usdaFood.performSearch(query);
    setState(() {
      _resultadosBusqueda = resultados;
    });
  }
}