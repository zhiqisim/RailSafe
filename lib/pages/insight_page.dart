import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class InsightPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InsightPageState();
  }
}

class _InsightPageState extends State<InsightPage> {

  Widget build(BuildContext context) {
      final data = [
      new LinearSleep('10pm', 2),
      new LinearSleep('12am', 1),
      new LinearSleep('2am', 1),
      new LinearSleep('4am', 0),
      new LinearSleep('6am', 3),
    ];

    var series = [
      new charts.Series<LinearSleep, String>(
          id: 'Sleep',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSleep sleep, _) => sleep.days,
          measureFn: (LinearSleep sleep, _) => sleep.sleepHours,
          data: data),
    ];

    var chart = new SimpleBarChart(series);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(20.0),
      child: new SizedBox(
        height: 400.0,
        child: chart,
      ),
    );
    return new Container(color: Colors.grey[200],
        child: chartWidget);
  }
}


class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.ChartTitle('Intermittent Sleep Analysis',
            // subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Time (2hrs intervals)',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('No. of times out of bed',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],
    );
  }
}

/// Sample linear data type.
class LinearSleep {
  final String days;
  final int sleepHours;

  LinearSleep(this.days, this.sleepHours);
}
