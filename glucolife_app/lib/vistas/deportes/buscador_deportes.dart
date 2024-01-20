import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/alimentacion/agregar_alimento.dart';

class BuscadorDeportes extends StatefulWidget {
  @override
  _BuscadorDeportesState createState() => _BuscadorDeportesState();
}

class _BuscadorDeportesState extends State<BuscadorDeportes> {
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
              decoration: InputDecoration(
                labelText: 'Buscar actividad',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Coloca aquí la lógica para manejar el filtro
                    // Puedes abrir un menú de filtro o realizar alguna otra acción.
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica del primer botón
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(),
                      ),
                    );
                  },
                  child: Text('Favoritos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica del segundo botón
                  },
                  child: Text('Recientes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica del tercer botón
                  },
                  child: Text('Recomendados'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Ejemplo de tarjeta 1
            _buildCard('Nombre 1', 'Información importante 1', 'imagenes/actividad.jpeg'),
            // Ejemplo de tarjeta 2
            _buildCard('Nombre 2', 'Información importante 2', 'imagenes/actividad.jpeg'),
            // Ejemplo de tarjeta 3
            _buildCard('Nombre 3', 'Información importante 3', 'imagenes/actividad.jpeg'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String nombre, String informacion, String imagen) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailScreen(),
        ),
      );
    },
    child: Card(
      elevation: 10,
      shadowColor: Colors.green, // Cambiar el color de la sombra al seleccionar
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            child: Image.asset(
              imagen,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    informacion,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}


