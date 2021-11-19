import 'package:pedometerproject/utils/databasehelper.dart';

class StepDateTime {
  StepDateTime(this.id,this.date, this.step);
  late  int id;
  late  double date;
  late  double step;

StepDateTime.fromMap(Map<String,dynamic> map){
id = map["id"] ?? 0;
date = map["date"];
step = map["step"];
}
Map<String,dynamic> toMap(){
  return {
    DatabaseHelper.columnid : id,
    DatabaseHelper.columndate : date,
    DatabaseHelper.columnstep : step
  };
}
}

// class SalesData {
//   SalesData(this.year, this.sales);
//   final double year;
//   final double sales;
// }