import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:pedometerproject/models/datetimeclass.dart';
import 'package:pedometerproject/utils/databasehelper.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({Key? key}) : super(key: key);

  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }

  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  DateTime now = DateTime.now();
  final Dbhelper = DatabaseHelper.instance;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    var rng = new Random();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Steps taken:',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          _steps,
          style: const TextStyle(fontSize: 60),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => saveStep(
                      double.parse(DateFormat('dd').format(now)), double.parse(_steps)),
                  child: const Text("Kaydet")),
              ElevatedButton(
                  onPressed: () => sifirla(), child: const Text("Step'i sıfırla")),
              ElevatedButton(
                  onPressed: () => datayisil(), child: const Text("Datayı Sıfırla")),
            ],
          ),
        )
      ],
    );
  }

  saveStep(double date, var step) async {
    print(_steps.toString());
      try {
        Map<String, dynamic> data = {
          DatabaseHelper.columndate: date,
          DatabaseHelper.columnstep: 0,
        };
        StepDateTime stepclass = StepDateTime.fromMap(data);
        final id = await Dbhelper.insert(stepclass);
        print("$id, $date, $step");
      }
      catch (e) {
        print(e);
      }


  }

  sifirla() {
    int sifir = 0;
    setState(() {
      _steps = sifir.toString();
    });
  }
  datayisil() async{
    return await Dbhelper.deleteDatabase();
  }

}
