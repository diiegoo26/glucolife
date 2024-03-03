import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glucolife_app/viewmodel/home_viewmodel.dart';

class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({Key? key}) : super(key: key);

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;

  late Timer addDataTimer;
  late Timer clearDataTimer;

  final HomeViewModel _homeViewModel=HomeViewModel();

  double hiperglucemiaLimite = 60.0;
  double hipoglucemiaLimite = 160.0;

  // Establecer el límite deseado


  @override
  void initState() {
    super.initState();

    _homeViewModel.obtenerHiperglucemia().then((double hiperglucemia) {
      // Establecer el límite de hiperglucemia
      hiperglucemiaLimite = hiperglucemia;
    });

    _homeViewModel.obtenerHipoglucemia().then((double hipoglucemia) {
      // Establecer el límite de hiperglucemia
      hipoglucemiaLimite = hipoglucemia;
    });

    // Timer para agregar nuevos valores cada 2 segundos
    addDataTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        double randomValue = math.Random().nextInt(151) + 50;
        double randomValue1 = math.Random().nextInt(151) + 50;
        _homeViewModel.guardarDatosGlucosa(randomValue);
        sinPoints.add(FlSpot(xValue, randomValue));
        cosPoints.add(FlSpot(xValue, randomValue1));
      });
      xValue += step;
    });

    // Timer para limpiar datos cada 60 segundos
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Nivel ideal: ${cosPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 18,
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
                    sinLine(sinPoints),
                    cosLine(cosPoints),
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

  LineChartBarData sinLine(List<FlSpot> points) {
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

  LineChartBarData cosLine(List<FlSpot> points) {
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
        if (lastY <= hiperglucemiaLimite && lastY >= 0) {
          return Colors.red.withOpacity(0.5);
        } else if (lastY >= hipoglucemiaLimite) {
          return Colors.red.withOpacity(0.5);
        } else if(lastY>=hiperglucemiaLimite && lastY<=hipoglucemiaLimite){
          return Colors.green.withOpacity(0.5);
          return Colors.transparent;
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
