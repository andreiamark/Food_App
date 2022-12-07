import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:licenta2_app/screens/reset_pass.dart';


class AuthCard extends StatefulWidget {
  const AuthCard(
      this.submitFn,
      this.isLoading,
      );

  final bool isLoading;
  final void Function(
      String email,
      String password,
      String userName,
      bool isLogin,
      BuildContext ctx,
      ) submitFn;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  final user = FirebaseAuth.instance.currentUser;


  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _isLogin,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color.fromRGBO(112, 128, 144, 1).withOpacity(0.6),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    style:  const TextStyle(color: Colors.white),
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      style:  const TextStyle(color: Colors.white),
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelStyle: TextStyle(
                              color: Colors.white
                          ),
                          labelText: 'Username'
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    style:  const TextStyle(color: Colors.white),
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.white
                        ),
                        labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ResetPass()));
                      },
                      child: const Text('Forgot password?',
                      style: TextStyle(color: Colors.white),)
                  ),),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading)
                    const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                        style: const TextStyle(color: Colors.white),),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
