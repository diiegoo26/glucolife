import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/viewmodel/home_viewmodel.dart';

class LecturaActualVista extends StatefulWidget {
  const LecturaActualVista({Key? key}) : super(key: key);

  @override
  State<LecturaActualVista> createState() => _LecturaActualVistaState();
}

class _LecturaActualVistaState extends State<LecturaActualVista> {
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  final double step = 0.1;

  late Timer addDataTimer;
  late Timer clearDataTimer;

  final HomeViewModel _homeViewModel=HomeViewModel();

  double hiperglucemiaLimite = 60.0;
  double hipoglucemiaLimite = 160.0;



  @override
  void initState() {
    super.initState();
    /// Llamada al metodo para obtner el valor de hiperglucemia
    _homeViewModel.obtenerHiperglucemia().then((double hiperglucemia) {
      hiperglucemiaLimite = hiperglucemia;
    });
    /// Llamada al metodo para obtner el valor de hipoglucemia
    _homeViewModel.obtenerHipoglucemia().then((double hipoglucemia) {
      hipoglucemiaLimite = hipoglucemia;
    });

    addDataTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        double actual = math.Random().nextDouble() * 100 + 50;
        double ideal = actual + (math.Random().nextDouble() * 20 - 10);
        /// Llamada al metodo para almacenar los datos en Firebase
        _homeViewModel.guardarDatosGlucosa(actual);
        sinPoints.add(FlSpot(xValue, actual));
        cosPoints.add(FlSpot(xValue, ideal));
      });
      xValue += step;
    });

    clearDataTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        sinPoints.clear();
        cosPoints.clear();
        xValue = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return cosPoints.isNotEmpty
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Text(
          'Nivel actual: ${sinPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Nivel ideal: ${cosPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Valor de hiperglucemia: ${hiperglucemiaLimite}',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Valor de hipoglucemia: ${hipoglucemiaLimite}',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          color: _getBackgroundColor(),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: LineChart(
                LineChartData(
                  minY: 50,
                  maxY: 200,
                  minX: sinPoints.isNotEmpty ? sinPoints.first.x : 0,
                  maxX: sinPoints.isNotEmpty ? sinPoints.last.x : 1,
                  lineTouchData: const LineTouchData(enabled: false),
                  clipData: const FlClipData.all(),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    valor_real(sinPoints),
                    valor_ideal(cosPoints),
                  ],
                  titlesData: const FlTitlesData(
                    show: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    )
        : Container();
  }

  LineChartBarData valor_real(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [Colors.blue.withOpacity(0), Colors.blue],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
      belowBarData: BarAreaData(show: false),
      aboveBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData valor_ideal(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [Colors.pink.withOpacity(0), Colors.pink],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
      belowBarData: BarAreaData(show: false),
      aboveBarData: BarAreaData(show: false),
    );
  }
  
  /// Permite cambiar el fondo de color cuando el usuario se encuentra en estado de hiperglucemia o hipoglucemia
  Color _getBackgroundColor() {
    if (sinPoints.isEmpty) {
      return Colors.transparent;
    }

    final double lastY = sinPoints.last.y;

    switch (lastY) {
      case double.nan:
      case double.infinity:
      case double.negativeInfinity:
        return Colors.transparent;
      case double.negativeInfinity:
        return Colors.transparent;
      case double.nan:
        return Colors.transparent;
      default:
        if (lastY >= hiperglucemiaLimite && lastY >= 0) {
          return Colors.red.withOpacity(0.5);
        } else if (lastY <= hipoglucemiaLimite) {
          return Colors.red.withOpacity(0.5);
        } else if(lastY<=hiperglucemiaLimite && lastY>=hipoglucemiaLimite){
          return Colors.green.withOpacity(0.5);
        }else{
          return Colors.transparent;
        }
    }
  }
  
  @override
  void dispose() {
    addDataTimer.cancel();
    clearDataTimer.cancel();
    super.dispose();
  }
}
