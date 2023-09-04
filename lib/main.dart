import 'package:ashwani/Screens/home.dart';
import 'package:ashwani/authorizeUser/authorise.dart';
import 'package:ashwani/authorizeUser/more_user_details.dart';
import 'package:ashwani/landingbypass.dart';
import 'package:ashwani/services/db_created.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  bool _initialise = false;
  bool _error = false;

  void initialiseFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialise = true;
    print(FirebaseAuth.instance.currentUser);

      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: Center(
              child: Column(children: const [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(height: 16),
                Text(
                  'Failed to initialise firebase!',
                  style: TextStyle(color: Colors.red, fontSize: 25),
                ),
              ]),
            ),
          ),
        ),
      );
    }
    if (!_initialise) {
      return Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(colorPrimary), brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey.shade800,
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(colorPrimary),
              brightness: Brightness.dark)),
      debugShowCheckedModeBanner: false,
      color: const Color(colorPrimary),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/authorizePage': '/landingBypass',
      routes: {
        '/authorizePage': (context) => const AuthorizePage(),
        '/landingBypass': (context) => const LandingBypass(),
        '/moreDetails':(context) =>  const MoreUserDetails(),
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseFlutterFire();
  }
}
