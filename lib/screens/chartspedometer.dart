import 'package:flutter/material.dart';
import 'package:pedometerproject/models/datetimeclass.dart';
import 'package:pedometerproject/utils/databasehelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartPedometer extends StatefulWidget {
  const ChartPedometer({Key? key}) : super(key: key);

  @override
  _ChartPedometerState createState() => _ChartPedometerState();
}

class _ChartPedometerState extends State<ChartPedometer> {
  List<StepDateTime> chartData = [];
  final Dbhelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(children: [Expanded(flex: 4,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                // Renders line chart
                LineSeries<StepDateTime, double>(
                    dataSource: chartData,
                    xValueMapper: (StepDateTime mydata, _) => mydata.date,
                    yValueMapper: (StepDateTime mydata, _) => mydata.step,
                    dataLabelSettings: const DataLabelSettings(isVisible: true)
                )
              ]
          ),
        ),Expanded(flex:1,child: FlatButton(onPressed: _queryAll, child: const Text("Reset")))],
        ));
  }

  void _queryAll() async {
    final allrows = await Dbhelper.queryAllRows();
    chartData.clear();
    allrows.forEach((row) {
      chartData.add(StepDateTime.fromMap(row));
      setState(() {});
      print(StepDateTime.fromMap(row).date);
    });
  }
}
