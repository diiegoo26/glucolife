import 'package:flutter/material.dart';
import 'package:glucolife_app/modelos/alimentos.dart';
import 'package:glucolife_app/servicios/USDAFoodServicio.dart';
import 'package:glucolife_app/vistas/alimentacion/agregar_alimento.dart';

class BuscadorAlimentosVista extends StatefulWidget {
  @override
  _BusquedaAlimentosState createState() => _BusquedaAlimentosState();
}

class _BusquedaAlimentosState extends State<BuscadorAlimentosVista> {
  TextEditingController _controladorBusqueda = TextEditingController();
  ///Llamada al servicio de la API USDA Food
  USDAFood _usdaFood = USDAFood();
  List<Alimentos> _resultadosBusqueda = [];

  void _alTocarResultadoBusqueda(Alimentos producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarAlimentoVista(producto: producto),
      ),
    );
  }

  /// Llamada al servicio para realizar la busqueda
  void _enCambioTextoBusqueda(String query) async {
    List<Alimentos> resultados = await _usdaFood.buscarAlimento(query);
    setState(() {
      _resultadosBusqueda = resultados;
    });
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
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _resultadosBusqueda.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_resultadosBusqueda[index].descripcion),
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
}