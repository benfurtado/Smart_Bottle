import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum GraphType { line, bar, pie }

class GraphWidget extends StatelessWidget {
  final GraphType graphType;
  final List<double> data;
  final List<String>? labels; // For bar/pie charts
  final String? title;
  final Color color;

  const GraphWidget({
    Key? key,
    required this.graphType,
    required this.data,
    this.labels,
    this.title,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Column(
        children: [
          if (title != null)
            Text(title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (graphType) {
      case GraphType.line:
        return LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (labels != null && value.toInt() < labels!.length) {
                      return Text(labels![value.toInt()], style: TextStyle(fontSize: 12));
                    }
                    return Text('');
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (int i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i])
                ],
                isCurved: true,
                barWidth: 3,
                color: color,
                belowBarData: BarAreaData(show: true, color: color.withOpacity(0.3)),
              ),
            ],
          ),
        );
      case GraphType.bar:
        return BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (labels != null && value.toInt() < labels!.length) {
                      return Text(labels![value.toInt()], style: TextStyle(fontSize: 12));
                    }
                    return Text('');
                  },
                ),
              ),
            ),
            barGroups: [
              for (int i = 0; i < data.length; i++)
                BarChartGroupData(x: i, barRods: [BarChartRodData(toY: data[i], color: color)])
            ],
          ),
        );
      case GraphType.pie:
        return PieChart(
          PieChartData(
            sections: [
              for (int i = 0; i < data.length; i++)
                PieChartSectionData(
                  value: data[i],
                  color: color.withOpacity(0.5 + 0.5 * (i / data.length)),
                  title: labels != null && i < labels!.length ? labels![i] : '',
                  radius: 50,
                  titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 30,
          ),
        );
      default:
        return Center(child: Text('Unknown chart type'));
    }
  }
}
