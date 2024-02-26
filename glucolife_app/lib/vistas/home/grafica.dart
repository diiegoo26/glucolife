import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        double randomValue = math.Random().nextInt(151) + 50;
        double randomValue1 = math.Random().nextInt(151) + 50;
        sinPoints.add(FlSpot(xValue, randomValue));
        cosPoints.add(FlSpot(xValue, randomValue1));
      });
      xValue += step;
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
          'x: ${xValue.toStringAsFixed(1)}',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'sin: ${sinPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'cos: ${cosPoints.last.y.toStringAsFixed(1)}',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: LineChart(
              LineChartData(
                minY: 50,
                maxY: 200,
                minX: sinPoints.first.x,
                maxX: sinPoints.last.x,
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
        )
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}