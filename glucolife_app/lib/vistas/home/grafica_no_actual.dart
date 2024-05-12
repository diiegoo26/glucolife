import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LecturaNoActualVista extends StatelessWidget {
  LecturaNoActualVista({
    super.key,
    Color? valor_real,
    Color? valor_ideal,
    Color? betweenColor,
  })  : valor_real = valor_real ?? Colors.green,
        valor_ideal = valor_ideal ?? Colors.blue,
        betweenColor =
            betweenColor ?? Colors.red.withOpacity(0.5);

  final Color valor_real;
  final Color valor_ideal;
  final Color betweenColor;

  Widget ejeX(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '00:00';
        break;
      case 1:
        text = '02:00';
        break;
      case 2:
        text = '04:00';
        break;
      case 3:
        text = '06:00';
        break;
      case 4:
        text = '08:00';
        break;
      case 5:
        text = '10:00';
        break;
      case 6:
        text = '12:00';
        break;
      case 7:
        text = '14:00';
        break;
      case 8:
        text = '16:00';
        break;
      case 9:
        text = '18:00';
        break;
      case 10:
        text = '20:00';
        break;
      case 11:
        text = '22:00';
        break;
      default:
        return Container();
    }


    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget ejeY(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '50';
        break;
      case 1:
        text = '100';
        break;
      case 2:
        text = '130';
        break;
      case 3:
        text = '150';
        break;
      case 4:
        text = '180';
        break;
      case 5:
        text = '200';
        break;
      case 6:
        text = '220';
        break;
      case 7:
        text = '250';
        break;
      case 8:
        text = '300';
        break;
      case 9:
        text = '350';
        break;
      default:
        return Container();
    }


    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 18,
          top: 10,
          bottom: 4,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 4),
                  FlSpot(1, 3.5),
                  FlSpot(2, 4.5),
                  FlSpot(3, 1),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                  FlSpot(6, 6.5),
                  FlSpot(7, 6),
                  FlSpot(8, 4),
                  FlSpot(9, 6),
                  FlSpot(10, 6),
                  FlSpot(11, 7),
                ],
                isCurved: true,
                barWidth: 2,
                color: valor_real,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 7),
                  FlSpot(1, 3),
                  FlSpot(2, 4),
                  FlSpot(3, 2),
                  FlSpot(4, 3),
                  FlSpot(5, 4),
                  FlSpot(6, 5),
                  FlSpot(7, 3),
                  FlSpot(8, 1),
                  FlSpot(9, 8),
                  FlSpot(10, 1),
                  FlSpot(11, 3),
                ],
                isCurved: false,
                barWidth: 2,
                color: valor_ideal,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            betweenBarsData: [
              BetweenBarsData(
                fromIndex: 0,
                toIndex: 1,
                color: betweenColor,
              )
            ],
            minY: 0,
            borderData: FlBorderData(
              show: false,
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: ejeX,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: ejeY,
                  interval: 1,
                  reservedSize: 36,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}