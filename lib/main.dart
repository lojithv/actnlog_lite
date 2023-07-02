import 'package:actnlog_lite/pages/home_page.dart';
import 'package:actnlog_lite/pages/settings.dart';
import 'package:actnlog_lite/pages/loading_screen.dart';
import 'package:actnlog_lite/pages/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actnlog Lite',
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
        '/home': (context) => const HomePage(title: 'Activlog'),
        '/settings': (context) => const Settings(),
        '/timer': (context) => const TimerView()
      },
    );
  }
}
