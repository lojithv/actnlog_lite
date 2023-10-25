import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:actnlog_lite/pages/home_page.dart';
import 'package:crypto/crypto.dart';
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

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    authStateSubs.add(supabase.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        if (data != null) {
          final event = data.event;
          if (event == AuthChangeEvent.signedIn) {
            authStateSubs.forEach((sub) => sub.cancel());
            print('Sign in.............................123');
            navigatorKey.currentState?.pushNamed('/home');
          }
        }
      }
    }));
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

  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the iOS and Web client ID with your own.
    ///
    /// Client ID that you registered with Google Cloud.
    /// Note that in order to perform Google sign in on Android, you need to
    /// provide the web client ID, not the Android client ID.
    final clientId = Platform.isIOS ? 'IOS_CLIENT_ID' : '752150405587-j79no6unflam4fmsku5vnpeccm6hc03c.apps.googleusercontent.com';

    late final String? idToken;
    late final String? accessToken;
    String? rawNonce;

    // Use AppAuth to perform Google sign in on iOS
    // and use GoogleSignIn package for Google sign in on Android
    if (Platform.isIOS) {
      const appAuth = FlutterAppAuth();

      // Just a random string
      rawNonce = _generateRandomString();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      /// Set as reversed DNS form of Google Client ID + `:/` for Google login
      final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

      /// Fixed value for google login
      const discoveryUrl =
          'https://accounts.google.com/.well-known/openid-configuration';

      // authorize the user by opening the concent page
      final result = await appAuth.authorize(
        AuthorizationRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          nonce: hashedNonce,
          scopes: [
            'openid',
            'email',
            'profile',
          ],
        ),
      );

      if (result == null) {
        throw 'No result';
      }

      // Request the access and id token to google
      final tokenResult = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          authorizationCode: result.authorizationCode,
          discoveryUrl: discoveryUrl,
          codeVerifier: result.codeVerifier,
          nonce: result.nonce,
          scopes: [
            'openid',
            'email',
          ],
        ),
      );

      accessToken = tokenResult?.accessToken;
      idToken = tokenResult?.idToken;
    } else {
      print('Android sign in.......................................');
      print(clientId);
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: clientId,
        scopes: [
          'openid',
          'email',
        ],
      );
      final googleUser = await googleSignIn.signIn();
      print(googleUser);
      final googleAuth = await googleUser!.authentication;
      print(googleAuth);
      accessToken = googleAuth.accessToken;
      idToken = googleAuth.idToken;
    }

    if (idToken == null) {
      throw 'No ID Token';
    }
    if (accessToken == null) {
      throw 'No Access Token';
    }

    print("tokens................................");
    print(idToken);
    print(accessToken);

    return supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      accessToken: accessToken,
      nonce: rawNonce,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(onPressed:  _googleSignIn,
      child: Text('Login'),),),
    );
  }
}
