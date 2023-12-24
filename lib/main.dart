import 'package:ashwani/load_inventory.dart';
import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/bs_address_provider.dart';
import 'package:ashwani/src/Providers/customer_provider.dart';
import 'package:ashwani/src/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/src/Providers/production.dart';
import 'package:ashwani/src/Providers/purchase_returns_provider.dart';
import 'package:ashwani/src/Providers/sales_returns_provider.dart';
import 'package:ashwani/src/Providers/user_provider.dart';
import 'package:ashwani/src/Providers/vendor_provider.dart';
import 'package:ashwani/src/Screens/settings/setting_page.dart';
import 'package:ashwani/src/Services/authorizeUser/loginauth.dart';
import 'package:ashwani/src/Services/authorizeUser/more_user_details.dart';
import 'package:ashwani/src/Services/authorizeUser/signupauth.dart';
import 'package:ashwani/landingbypass.dart';
import 'package:ashwani/src/Providers/inventory_summary_provider.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:ashwani/user_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'src/constants.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
  'email,https://www.googleapis.com/auth/contacts.readonly'
]);
// NetworkService _networkService = NetworkService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  bool _initialise = false;
  bool _error = false;
  var auth;
  // bool _dataLoaded = false;

  Future<void> initialiseFlutterFireandLoadData() async {
    try {
      await Firebase.initializeApp();
      // _dataLoaded = await loadInitialData();
      UserData().loadUserEmail();

      setState(() {
        _initialise = true;
        // _dataLoaded = _dataLoaded;
        auth = FirebaseAuth.instance.currentUser;
        print(auth);

        // print('data loaded = $_dataLoaded');
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _networkService.connectionStatusStream.listen((bool isConnected) {
    //   if (!isConnected) {
    //     // Show a modal barrier or display a message indicating no internet connection
    //     // Example: Show a modal dialog with a message
    //    MaterialApp(
    //       home: Scaffold(
    //         body: Container(
    //           color: Colors.white,
    //           child: const Center(
    //             child: Column(children: [
    //               Icon(
    //                 Icons.error_outline,
    //                 color: Colors.red,
    //                 size: 25,
    //               ),
    //               SizedBox(height: 16),
    //               Text(
    //                 'No Internet Connection',
    //                 style: TextStyle(color: Colors.red, fontSize: 25),
    //               ),
    //             ]),
    //           ),
    //         ),
    //       ),
    //     );
    //   }
    // });

    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: const Center(
              child: Column(children: [
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
          child: Lottie.asset('lib/animation/ani6.json', fit: BoxFit.contain));
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context) => NSOrderProvider()),
        ChangeNotifierProvider(create: (context) => NPOrderProvider()),
        ChangeNotifierProvider(create: (context) => InventorySummaryProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => BSAddressProvider()),
        ChangeNotifierProvider(create: (context) => VendorProvider()),
        ChangeNotifierProvider(create: (context) => SalesReturnsProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseReturnsProvider()),
        ChangeNotifierProvider(create: (context) => BOMProvider()),
        ChangeNotifierProvider(create: (context) => ProductionProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          // primarySwatch:  ,
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF1F3F5),
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
          snackBarTheme: const SnackBarThemeData(
            contentTextStyle: TextStyle(color: Colors.white),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(colorPrimary),
              brightness: Brightness.light),
        ),
        themeMode: ThemeMode.light,
        // darkTheme: ThemeData(
        //     brightness: Brightness.dark,
        //     scaffoldBackgroundColor: Colors.black,
        //     appBarTheme: const AppBarTheme(
        //         systemOverlayStyle: SystemUiOverlayStyle.light),
        //     snackBarTheme: const SnackBarThemeData(
        //         contentTextStyle: TextStyle(color: Colors.black)),
        //     colorScheme: ColorScheme.fromSwatch().copyWith(
        //         secondary: const Color(colorPrimary),
        //         brightness: Brightness.dark)),
        debugShowCheckedModeBanner: false,
        color: const Color(bluePrimary),
        initialRoute: '/openingLogo',
        routes: {
          '/myApp': (context) => const MyApp(),
          '/landingBypass': (context) => const LandingBypass(),
          '/loginPage': (context) => const LoginAuthPage(),
          '/signupPage': (context) => const SignUpAuthPage(),
          '/moreDetails': (context) => const MoreUserDetails(),
          '/loadInventory': (context) => const LoadInventory(),
          '/settings': (context) => const SettingsPage(),
          '/openingLogo': (context) => const OpeningScreen(),
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initialiseFlutterFireandLoadData();
  }
}

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      UserData().userEmail == ''
          ? Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignUpAuthPage()))
          : Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoadInventory()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: const Center(
        child: Image(
          image: AssetImage('lib/images/logo_white.png'),
          width: 150,
        ),
      ),
    );
  }
}

class LoadInventory extends StatefulWidget {
  const LoadInventory({super.key});

  @override
  State<LoadInventory> createState() => _LoadInventoryState();
}

class _LoadInventoryState extends State<LoadInventory> {
  bool _isLoading = true;
  bool _err = false;
  Future<void> getAll() async {
    LoadData loader = LoadData();
    bool loaded = await loader.loadData(context);
    if (loaded) {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingBypass()),
      );
    } else {
      // handle error
      setState(() {
        _err = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAll();
    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          color: w,
          child: Lottie.asset('lib/animation/ani6.json', fit: BoxFit.contain));
    }
    if (_err) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: const Center(
            child: Column(children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 25,
              ),
              SizedBox(height: 16),
              Text(
                'Failed To Load Database! Try RE-starting the App ',
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ]),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: w,
      body: const Center(
          // child: Text('Fetching',style: TextStyle(color: b32),),
          ),
    );
  }
}
// animations links
// https://lottiefiles.com/animations/loading-iew43eMiJN.
// https://lottiefiles.com/animations/factory-industry-house-home-building-maison-mocca-animation-97rg4awLxc.
// https://lottiefiles.com/animations/simple-loading-rXNTJsH6UW
