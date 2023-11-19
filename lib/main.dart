import 'dart:io';

import 'package:actnlog_lite/pages/home_page.dart';
import 'package:actnlog_lite/pages/login.dart';
import 'package:actnlog_lite/pages/settings.dart';
import 'package:actnlog_lite/pages/loading_screen.dart';
import 'package:actnlog_lite/pages/timer_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    // other settings...
  );

  runApp(const MyApp());
}

FirebaseFirestore db = FirebaseFirestore.instance;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actnlog Lite',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          textTheme: TextTheme(
            displayLarge: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.displayLarge),
            titleLarge: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleLarge),
            bodyMedium: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyMedium),
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: Color.fromRGBO(43, 111, 243, 1.0),
              selectionHandleColor: Color.fromRGBO(43, 111, 243, 1.0)),
          useMaterial3: true),
      routes: {
        '/': (context) => const LoadingScreen(),
        '/login':(context)=>const LoginPage(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/timer': (context) => const TimerView()
      },
    );
  }
}
