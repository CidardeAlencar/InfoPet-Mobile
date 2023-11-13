import 'package:flutter/material.dart';
import 'package:infopet/UI/screens/gps_screen.dart';
import 'package:infopet/UI/screens/login_screen.dart';
import 'package:infopet/UI/screens/main_screen.dart';
import 'package:infopet/UI/screens/qr_screen.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InfOPet',
      theme: ThemeData(
        colorScheme:
            //ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 183, 123, 58)),
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => GPSScreen(userID: 'IW8PL5tEhnP4FwwYtJ6uPfmbyPG2'),
        '/': (context) => MyHomePage(),
        '/home': (context) => ManualQRScreen(),
        '/qr': (context) => QRViewExample(),
        '/login': (context) => LoginScreen(),
        //'/gps': (context) => GPSScreen(userID: ''),
      },
      //home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 330,
              height: 105,
            ),
          ],
        ),
      ),
    );
  }
}
