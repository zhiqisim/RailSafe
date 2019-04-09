import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DefaultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DefaultPageState();
  }
}

class _DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    final data = [
      new LinearSleep(0, 7),
      new LinearSleep(1, 4),
      new LinearSleep(2, 8),
      new LinearSleep(3, 10),
      new LinearSleep(4, 5),
      new LinearSleep(5, 6),
      new LinearSleep(6, 11)
    ];

    var series = [
      new charts.Series<LinearSleep, int>(
          id: 'Sleep',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSleep sleep, _) => sleep.days,
          measureFn: (LinearSleep sleep, _) => sleep.sleepHours,
          data: data),
    ];

    var chart = new PointsLineChart(series);
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


class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.ChartTitle('Amount of Sleep',
            // subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Day',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Hours',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],
    );
  }
}

/// Sample linear data type.
class LinearSleep {
  final int days;
  final int sleepHours;

  LinearSleep(this.days, this.sleepHours);
}