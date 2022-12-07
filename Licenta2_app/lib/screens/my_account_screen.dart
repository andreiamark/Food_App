import 'dart:io';
import 'package:flutter/material.dart';
import 'package:licenta2_app/services/avatar_services.dart';
import 'package:licenta2_app/services/user_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  FirebaseStorage storageRef = FirebaseStorage.instance;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'users';
  XFile? imagePath;
  String imageName = '';
  final ImagePicker _picker = ImagePicker();
  var email = '';
  var username = '';
  var avatarUrl = '';

  bool _isLoaded = false;


   uploadFile() async {
     final user = FirebaseAuth.instance.currentUser;
     String uploadFileName =
         '${DateTime.now().millisecondsSinceEpoch}.jpg';
     Reference reference =
        storageRef.ref().child(collectionName).child(uploadFileName);
     UploadTask uploadTask = reference.putFile(
         File(imagePath!.path));

     uploadTask.snapshotEvents.listen((event) {
       print(event.totalBytes.toString());
     });

     await uploadTask.whenComplete(() async {
       var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

       if (uploadPath.isNotEmpty) {
         firestoreRef.collection(collectionName).doc(user!.uid).update({
           "avatarUrl": uploadPath
         }).then((value) { AvatarServices.instance.getAvatarUrl().whenComplete(() {
           _showMessage('image uploaded');
           setState(() {
             avatarUrl = AvatarServices.instance.avatarUrl;
           });
         });} );
       } else {
         _showMessage('something while upload image');
       }
       // setState(() {
       //   _isLoaded = true;
       // });
     });
  }

  imagePicker() async {
     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            imagePath = image;
            imageName = image.name.toString();
            uploadFile();
          });
        }
  }
  
  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),));
  }


  @override
  void initState() {
     AvatarServices.instance.getAvatarUrl().whenComplete(() {
       setState(() {
         avatarUrl = AvatarServices.instance.avatarUrl;
          _isLoaded = true;
       });
     });
    UserServices.instance.getUserEmail().whenComplete(() {
         setState(() {
           email = UserServices.instance.email;
           username = UserServices.instance.username;
         });
    });
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 30, bottom: 170, top: 110, left: 110),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: _isLoaded & AvatarServices.instance.avatarUrl.isNotEmpty
                    ? NetworkImage(AvatarServices.instance.avatarUrl) as ImageProvider
                    : NetworkImage("https://firebasestorage.googleapis.com/v0/b/licenta2-34bf6.appspot.com/o/users%2Fno-user-image.gif?alt=media&token=0511e34c-ed80-4802-a880-bfebe8c457a5"),
                child:  Stack(
                    children: [
                      Positioned(
                        right: 10,
                        bottom: 120,
                        child: SizedBox(
                          height: 52,
                          width: 52,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(color: Colors.white),
                                ),),),
                            onPressed: () {
                             imagePicker();
                            },
                            child: const Center(
                                child: Icon(Icons.camera_alt_outlined)
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            Container(
              child:  Text(
                  'Email: $email \nUsername: $username ',
                  style: const TextStyle(fontSize: 15,)),
            )
          ]),);
  }
}
