import 'package:flutter/material.dart';
import 'package:elderest/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './default_page.dart' as default_page;
import './insight_page.dart' as insight_page;
import './chat_page.dart' as chat_page;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<MyTabs> _tabs = [
    new MyTabs(title: "Insights"),
    new MyTabs(title: "Home"),
    new MyTabs(title: "Chat")
  ];

  MyTabs handler;
  TabController controller;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3, initialIndex: 1);
    handler = _tabs[1];
    controller.addListener(handleSelected);
     _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
  //   var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

  //   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings, selectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSelected() {
    setState(() {
      handler = _tabs[controller.index];
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final data = [
    //   new LinearSleep(0, 7),
    //   new LinearSleep(1, 4),
    //   new LinearSleep(2, 8),
    //   new LinearSleep(3, 10),
    //   new LinearSleep(4, 5),
    //   new LinearSleep(5, 6),
    //   new LinearSleep(6, 11)
    // ];

    // var series = [
    //   new charts.Series<LinearSleep, int>(
    //       id: 'Sleep',
    //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    //       domainFn: (LinearSleep sleep, _) => sleep.days,
    //       measureFn: (LinearSleep sleep, _) => sleep.sleepHours,
    //       data: data),
    // ];

    // var chart = new PointsLineChart(series);
    // var chartWidget = new Padding(
    //   padding: new EdgeInsets.all(20.0),
    //   child: new SizedBox(
    //     height: 400.0,
    //     child: chart,
    //   ),
    // );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('RailSafe'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        bottomNavigationBar: new Material(
            color: Colors.white,
            child: new TabBar(
                controller: controller,
                tabs: <Tab>[
                  new Tab(icon: new Icon(Icons.insert_chart)),
                  new Tab(icon: new Icon(Icons.home)),
                  new Tab(icon: new Icon(Icons.chat))
                ],
                indicatorColor: Colors.red,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey)),
        body: Column(children: <Widget>[
          Flexible(child: new FallList(), flex: 1), // fall list widget
          Flexible(
              child: new TabBarView(controller: controller, children: <Widget>[
            new insight_page.InsightPage(),
            new default_page.DefaultPage(),
            new chat_page.ChatPage()
          ]), flex: 3)
        ]));
  }
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
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
                    child: const Text('OFF ALARM'),
                    onPressed: () {/* ... */},
                  ),
                  // FlatButton(
                  //   child: const Text('LISTEN'),
                  //   onPressed: () {/* ... */},
                  // ),
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
                    child: const Text('SEND ALARM'),
                    onPressed: () {/* ... */},
                  ),
                  // FlatButton(
                  //   child: const Text('LISTEN'),
                  //   onPressed: () {/* ... */},
                  // ),
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

  // /// Creates a [LineChart] with sample data and no transition.
  // factory PointsLineChart.withSampleData() {
  //   return new PointsLineChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

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
    // defaultRenderer: new charts.LineRendererConfig(includePoints: true)
  }

  // /// Create one series with sample hard coded data.
  // static List<charts.Series<LinearSleep, int>> _createSampleData() {
  //   final data = [
  //     new LinearSleep(0, 5),
  //     new LinearSleep(1, 25),
  //     new LinearSleep(2, 100),
  //     new LinearSleep(3, 75),
  //   ];

  //   return [
  //     new charts.Series<LinearSleep, int>(
  //       id: 'Sales',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (LinearSleep sales, _) => sales.days,
  //       measureFn: (LinearSleep sales, _) => sales.sleepHours,
  //       data: data,
  //     )
  //   ];
  // }
}

/// Sample linear data type.
class LinearSleep {
  final int days;
  final int sleepHours;

  LinearSleep(this.days, this.sleepHours);
}

class MyTabs {
  final String title;
  MyTabs({this.title});
}
