import 'package:flutter/material.dart';
import 'package:elderest/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        body: new BookList(), 
    );
  }

  
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('test').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
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

class AlertCard extends StatelessWidget{

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
              subtitle: Text('System has detected a fall. Respond immediately!'),
            ),
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CALL'),
                    onPressed: () { /* ... */ },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () { /* ... */ },
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

class NormalCard extends StatelessWidget{

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
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('CALL'),
                    onPressed: () { /* ... */ },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () { /* ... */ },
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