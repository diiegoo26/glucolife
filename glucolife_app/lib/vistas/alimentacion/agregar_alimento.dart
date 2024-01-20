import 'package:flutter/material.dart';
import 'package:glucolife_app/vistas/alimentacion/tarjeta.dart';
import 'package:glucolife_app/vistas/alimentacion/visualizacion_datos.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Buscador'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
            color: Colors.white,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 52.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Positioned(
                top: 65.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45.0),
                      topRight: Radius.circular(45.0),
                    ),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height - 100.0,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      // Foto en un círculo
                      Positioned(
                        top:
                            20.0, // Ajusta la posición vertical según tus necesidades
                        left: MediaQuery.of(context).size.width / 2 -
                            40.0, // Centrar la foto horizontalmente
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'imagenes/alimentos.jpg'), // Ajusta la ruta de la foto según tu proyecto
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 250.0,
                left: 25.0,
                right: 25.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 200.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: Colors.green),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.green,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Agregar unidades',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 150.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Tarjeta('WEIGHT', '300', 'G'), 
                          SizedBox(width: 10.0),
                          Tarjeta('CALORIES', '267', 'CAL'),
                          SizedBox(width: 10.0),
                          Tarjeta('VITAMINS', 'A, B6', 'VIT'), 
                          SizedBox(width: 10.0),
                          Tarjeta('AVAIL', 'NO', 'AV'), 
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: InkWell(
                        onTap: () {
                          // Lógica del botón
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisualizacionAlimentacion(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            color: Colors.green,
                          ),
                          height: 50.0,
                          child: Center(
                            child: Text(
                              'Agregar alimento',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
