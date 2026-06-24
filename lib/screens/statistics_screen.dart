import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../database/database_helper.dart';
import '../models/device.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Device> devices = [];

  List<double> last5Days = [0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DatabaseHelper.instance.getAllDevices();

    final now = DateTime.now();

    List<double> counts = List.filled(5, 0);

    for (final d in data) {
      final diff = now.difference(d.createdAt).inDays;

      if (diff >= 0 && diff < 5) {
        counts[4 - diff] += 1;
      }
    }

    setState(() {
      devices = data;
      last5Days = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Letzte 5 Tage"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const labels = ["-4", "-3", "-2", "-1", "Heute"];
                          return Text(
                            labels[value.toInt()],
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  barGroups: List.generate(5, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: last5Days[i],
                          color: Colors.blueAccent,
                          width: 20,
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Gesamt Geräte: ${devices.length}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}