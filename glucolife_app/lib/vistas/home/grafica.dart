import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({super.key});

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;
  late double randValue;
  late double cosValue;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        // Generar valores aleatorios entre 80 y 200
        randValue = (math.Random().nextDouble() * (300 - 50) + 80);

        // Ajustar el valor de la línea 2 en consecuencia
        cosValue = (math.Random().nextDouble() * (300 - 50) + 80);

        sinPoints.add(FlSpot(xValue, randValue));
        cosPoints.add(FlSpot(xValue, cosValue));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLine1OutOfRange = sinPoints.isNotEmpty &&
        (sinPoints.last.y < 80 || sinPoints.last.y > 200);

    // Ajustar el color del fondo según las condiciones especificadas
    Color backgroundColor = isLine1OutOfRange
        ? Colors.red
        : (randValue >= 80 && randValue <= 100) ||
                (randValue >= 170 && randValue <= 200)
            ? Colors.yellow
            : Colors.green;

    return cosPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                'Nivel actual: ${randValue.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nivel aconsejado: ${cosValue.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AspectRatio(
                aspectRatio: 4.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                    ),
                    child: LineChart(
                      LineChartData(
                        minY: 50,
                        maxY: 300,
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
      color: Color.fromARGB(255, 0, 0, 0), // Cambiar el color a negro
      dotData: const FlDotData(
        show: false,
      ),
      barWidth: 2, // Puedes ajustar este valor según tu preferencia
      isCurved: true,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      color: Colors.black, // Cambiar el color a negro
      dotData: const FlDotData(
        show: false,
      ),
      barWidth: 2, // Puedes ajustar este valor según tu preferencia
      isCurved: true,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
