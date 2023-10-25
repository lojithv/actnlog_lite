import 'package:actnlog_lite/pages/home_page.dart';
import 'package:actnlog_lite/pages/login.dart';
import 'package:actnlog_lite/pages/settings.dart';
import 'package:actnlog_lite/pages/loading_screen.dart';
import 'package:actnlog_lite/pages/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  var supabaseURL = dotenv.env['SUPABASE_URL'];
  var supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseURL != null && supabaseAnonKey != null) {
    await Supabase.initialize(
      url: supabaseURL,
      anonKey: supabaseAnonKey,
    );
  }
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

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
        '/home': (context) => const HomePage(title: 'Activlog'),
        '/settings': (context) => const Settings(),
        '/timer': (context) => const TimerView()
      },
    );
  }
}
