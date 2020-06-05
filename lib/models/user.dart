import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayName;
  final String bio;
  final DateTime timeStamp;

  User({
    this.id,
    this.username,
    this.photoUrl,
    this.email,
    this.displayName,
    this.bio,
    this.timeStamp
  });
  
  factory User.fromDocument(DocumentSnapshot doc){
   return User(
    id: doc['id'],
    email: doc['email'],
    username: doc['username'],
    photoUrl: doc['photoUrl'],
    displayName: doc['displayName'],
    bio: doc['bio']
   );
  }
}
