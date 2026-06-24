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

  int checkedIn = 0;
  int checkedOut = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DatabaseHelper.instance.getAllDevices();

    int inCount = data.where((d) => d.checkedIn).length;
    int outCount = data.length - inCount;

    setState(() {
      devices = data;
      checkedIn = inCount;
      checkedOut = outCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Statistiken"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: checkedIn.toDouble(),
                      title: "$checkedIn",
                      radius: 100,
                      color: Colors.green,
                    ),
                    PieChartSectionData(
                      value: checkedOut.toDouble(),
                      title: "$checkedOut",
                      radius: 100,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Eingecheckt: $checkedIn",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),

            Text(
              "Nicht eingecheckt: $checkedOut",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Gesamtgeräte: ${devices.length}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}