import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ensure this is added for graphs

class GraphWidget extends StatelessWidget {
  final bool isWeekly;

  GraphWidget({required this.isWeekly}); // Accept the isWeekly parameter

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
          Text(
            isWeekly ? "Weekly Progress" : "Monthly Progress",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          isWeekly
                              ? ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][value.toInt()]
                              : ["Week 1", "Week 2", "Week 3", "Week 4"][value.toInt()],
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: isWeekly
                        ? [FlSpot(0, 2), FlSpot(1, 2.5), FlSpot(2, 3), FlSpot(3, 2.8), FlSpot(4, 2.2), FlSpot(5, 2.4), FlSpot(6, 2.7)]
                        : [FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 15), FlSpot(3, 14)], 
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,

                    belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
