import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const ExpenseChart({Key? key, required this.categoryExpenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryExpenses.isEmpty) {
      return const Center(
        child: Text('No expenses to show'),
      );
    }

    return PieChart(
      PieChartData(
        sections: _buildPieChartSections(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = categoryExpenses.values.fold(0.0, (sum, value) => sum + value);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return categoryExpenses.entries.map((entry) {
      final index = categoryExpenses.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / total) * 100;
      
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        color: colors[index % colors.length],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
