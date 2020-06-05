import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbsocialmediaapp/widgets/header.dart';
import 'package:fbsocialmediaapp/widgets/progress.dart';
import 'package:flutter/material.dart';

final _userRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _deleteUser();
  }

  _createUser() async {
    //_userRef = Firestore.instance.collection('users');
    await _userRef
        .document('asdasdasdasd')
        .setData({'username': 'Bob', 'postsCount': 0, 'isAdmin': false});
  }

  _updateUser() async {
    //_userRef = Firestore.instance.collection('users');
    final DocumentSnapshot doc = await _userRef.document('7ixezXNaQamNVfb9LuTm').get();
    if(doc.exists){
      doc.reference.updateData({
        'username': 'John',
        'postsCount': 0,
        'isAdmin': false
      });
    }
  }
  
  _deleteUser() async {
    //_userRef = Firestore.instance.collection('users');
    final DocumentSnapshot doc = await _userRef.document('asdasdasdasd').get();
    if(doc.exists)
      doc.reference.delete();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _userRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return circularProgress();
            final List<Text> children =
                snapshot.data.documents.map((doc) => Text(doc['username'])).toList();
            return Container(
              child: ListView(
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
