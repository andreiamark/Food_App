import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPass extends StatefulWidget{



  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final email = TextEditingController();
  final auth = FirebaseAuth.instance;


  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Pass'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: passwordReset,
                  child: const Text('Send Request'),
              ),
            ],
          )
        ],
      ),

    );
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(content: Text('Password reset link sent! '),
            );
          }
      );
    }
    on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }
}