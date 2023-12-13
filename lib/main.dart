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
  // bool _dataLoaded = false;

  Future<void> initialiseFlutterFireandLoadData() async {
    try {
      await Firebase.initializeApp();
      // _dataLoaded = await loadInitialData();

      setState(() {
        _initialise = true;
        // _dataLoaded = _dataLoaded;

        print(FirebaseAuth.instance.currentUser);
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
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? '/signupPage'
            : '/loadInventory',
        routes: {
          '/myApp': (context) => const MyApp(),
          '/landingBypass': (context) => const LandingBypass(),
          '/loginPage': (context) => const LoginAuthPage(),
          '/signupPage': (context) => const SignUpAuthPage(),
          '/moreDetails': (context) => const MoreUserDetails(),
          '/loadInventory': (context) => const LoadInventory(),
          '/settings': (context) => const SettingsPage()
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

class LoadInventory extends StatefulWidget {
  const LoadInventory({super.key});

  @override
  State<LoadInventory> createState() => _LoadInventoryState();
}

class _LoadInventoryState extends State<LoadInventory> {
  bool _loadData = false;
  bool _err = false;
  Future<void> loadData() async {
    final customerP = Provider.of<CustomerProvider>(context, listen: false);
    final vendorP = Provider.of<VendorProvider>(context, listen: false);
    final itemsP = Provider.of<ItemsProvider>(context, listen: false);
    final invSummP =
        Provider.of<InventorySummaryProvider>(context, listen: false);
    final salesOP = Provider.of<NSOrderProvider>(context, listen: false);
    final salesRP = Provider.of<SalesReturnsProvider>(context, listen: false);
    final purchaseOP = Provider.of<NPOrderProvider>(context, listen: false);
    final purchaseRP =
        Provider.of<PurchaseReturnsProvider>(context, listen: false);
    final bomP = Provider.of<BOMProvider>(context, listen: false);
    final prodP = Provider.of<ProductionProvider>(context, listen: false);
    final userP = Provider.of<UserProvider>(context, listen: false);
    try {
      await userP.getUserDetails();
      await customerP.fetchAllCustomers();
      await vendorP.fetchAllVendors();
      await itemsP.getItems();
      await invSummP.totalInHand();

      await salesOP.fetchSalesOrders();
      await salesOP.fetchActivity();
      await salesRP.fetchSalesReturns();
      await purchaseOP.fetchPurchaseOrders();
      await purchaseOP.fetchPurchaseActivity();
      await purchaseRP.fetchPurchaseReturns();
      await bomP.fetchBOMS();
      await prodP.fetchProductions();
      // await invSummP.totalTobeRecieved();
      setState(() {
        _loadData = true;
      });
    } catch (e) {
      setState(() {
        _err = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadData) {
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
    return const LandingBypass();
  }
}

// Future<bool> loadInitialData() async {
//   // Load your data into providers
//   // Example: orderProvider.loadDataFromFirebase()
//   final customerP = CustomerProvider();
//   final vendorP = VendorProvider();
//   final itemsP = ItemsProvider();
//   final invSummP = InventorySummaryProvider();
//   final salesOP = NSOrderProvider();
//   final salesRP = SalesReturnsProvider();
//   final purchaseOP = NPOrderProvider();
//   final purchaseRP = PurchaseReturnsProvider();

//   try {
//     await customerP.fetchAllCustomers();
//     await vendorP.fetchAllVendors();
//     await itemsP.getItems();
//     await invSummP.totalInHand();
//     await invSummP.totalTobeRecieved();
//     await salesOP.fetchSalesOrders();
//     await salesOP.fetchActivity();
//     await salesRP.fetchSalesReturns();
//     await purchaseOP.fetchPurchaseOrders();
//     await purchaseOP.fetchPurchaseActivity();
//     await purchaseRP.fetchPurchaseReturns();
//     print(customerP.customers.length);
//     print(salesOP.som.length);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }

// animations links
// https://lottiefiles.com/animations/loading-iew43eMiJN.
// https://lottiefiles.com/animations/factory-industry-house-home-building-maison-mocca-animation-97rg4awLxc.
// https://lottiefiles.com/animations/simple-loading-rXNTJsH6UW
