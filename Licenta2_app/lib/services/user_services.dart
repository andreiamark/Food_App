import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  UserServices._instantiate();
  static final UserServices instance = UserServices._instantiate();
  String username = '';
  String email = '';
  String avatarUrl = '';
    getUserEmail() async {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
      .then((value) {
      username = value.data()!['username'];
      email = value.data()!['email'];
      avatarUrl = value.data()!['avatarUrl'];
   });
     UserServices.instance.username = username;
     UserServices.instance.email = email;
      UserServices.instance.avatarUrl = avatarUrl;
     }
  }

