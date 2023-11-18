import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:actnlog_lite/pages/home_page.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late List<StreamSubscription> authStateSubs = [];

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _isSignedIn = account != null;
      });
      // Redirect based on sign-in status
      _redirectBasedOnSignInStatus();
    });

    // Check if already signed in
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    authStateSubs.forEach((sub) => sub.cancel());
    super.dispose();
  }

  /// Function to generate a random 16 character string.
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  void _redirectBasedOnSignInStatus() {
    if (_isSignedIn) {
      navigateToHome();
    } else {
      // Implement logic for cases when the user is not signed in
      // For example, you could show a login screen or another welcome screen
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      navigateToHome();
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(onPressed:  (){
        _handleSignIn();
      },
      child: Text('Login'),),),
    );
  }
}
