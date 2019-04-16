import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.grey[200],
        child: new StreamBuilder(
            stream: Firestore.instance
                .collection('helplines')
                .orderBy('order')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              );
            }));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    _launchURL(String link) async {
      String url = link;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    _launchcaller(String phone) async {
      String url = "tel:" + phone;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return new Container(
      child: new Container(
        child: new Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
//                 // leading: Container(
//                 //     height: 36.0,
//                 //     width: 36.0,
//                 //     padding: EdgeInsets.only(right: 12.0),
//                 //     decoration: new BoxDecoration(
//                 //         border: new Border(
//                 //             right: new BorderSide(
//                 //                 width: 1.0, color: Colors.black))),
//                 //     child:
//                 //         new Image(image: NetworkImage(document['iconURL']))),
                title: new Text(document['name']),
                subtitle: new Text(document['description']),
              ),
              ButtonTheme.bar(
                // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('WEBSITE'),
                      onPressed: () {
                        _launchURL(document['link']);
                      },
                    ),
                    FlatButton(
                      child: const Text('CALL'),
                      onPressed: () {
                         _launchcaller(document['phone']);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
