import 'package:flutter/material.dart';
import 'package:elderest/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  static var data = [new LinearSales(1, 7), new LinearSales(2, 5)];

  static var series = [
    new charts.Series(
      id: 'Sleep hours',
      domainFn: (LinearSales clickData, _) => clickData.year,
      measureFn: (LinearSales clickData, _) => clickData.sales,
      data: data,
    ),
  ];

  static var chart = new PointsLineChart(series);
  var chartWidget = new Padding(
    padding: new EdgeInsets.all(32.0),
    child: new SizedBox(
      height: 200.0,
      child: chart,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('eldeREst'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: Column(children: <Widget>[
          Flexible(child: new FallList()), // fall list widget
          chartWidget
        ]));
  }
}

class FallList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('test').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                if (document['alert']) {
                  return new AlertCard();
                } else {
                  return new NormalCard();
                  // return new ListTile(
                  // title: new Text("FALSE"),
                  // );
                }
              }).toList(),
            );
        }
      },
    );
  }
}

class AlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning),
              title: Text('FALL DETECTED'),
              subtitle:
                  Text('System has detected a fall. Respond immediately!'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CALL'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NormalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.offline_pin),
              title: Text('SYSTEM NORMAL'),
              subtitle: Text('Connection is established to system.'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CALL'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData() {
    return new PointsLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
