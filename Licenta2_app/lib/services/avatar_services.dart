import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarServices {

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  AvatarServices._instantiate();
  static final AvatarServices instance = AvatarServices._instantiate();
  var avatarUrl = '';
  getAvatarUrl() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
          if(value.data()!.containsKey("avatarUrl")){
            avatarUrl = value.data()!['avatarUrl'];
          }

    });
    AvatarServices.instance.avatarUrl = avatarUrl;
  }
}

