import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Providers/bom_providers.dart';
import '../../Providers/customer_provider.dart';
import '../../Providers/inventory_summary_provider.dart';
import '../../Providers/iq_list_provider.dart';
import '../../Providers/new_purchase_order_provider.dart';
import '../../Providers/new_sales_order_provider.dart';
import '../../Providers/production.dart';
import '../../Providers/providers_reset_manager.dart';
import '../../Providers/purchase_returns_provider.dart';
import '../../Providers/sales_returns_provider.dart';
import '../../Providers/user_provider.dart';
import '../../Providers/vendor_provider.dart';
import '../../Services/authorizeUser/signupauth.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import 'setting_screens/about.dart';
import 'setting_screens/customer_support.dart';
import 'setting_screens/feedback.dart';
import 'setting_screens/org_profile.dart';
import 'setting_screens/privacy_security.dart';
import 'setting_screens/rate_app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> resetProvs() async {
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
    customerP.reset();
    vendorP.reset();
    itemsP.reset();
    invSummP.reset();
    salesOP.reset();
    salesRP.reset();
    purchaseOP.reset();
    purchaseRP.reset();
    bomP.reset();
    prodP.reset();
    userP.reset();
    print('RESET kra to hai');
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 26,
                            color: b.withOpacity(01),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Column(
                    children: [
                      ContainerSettings(
                        title: 'Organization Profile',
                        widget: OrganisationProfile(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // ContainerSettings(
                      //   title: 'Users',
                      //   widget: UserScreen(),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      ContainerSettings(
                        title: 'Privacy & security',
                        widget: PrivacySecurity(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContainerSettings(
                        title: 'About',
                        widget: AboutScreen(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContainerSettings(
                        title: 'Feedback',
                        widget: FeedbackScreen(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContainerSettings(
                        title: 'Rate App',
                        widget: RateApp(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContainerSettings(
                        title: 'Costumer Support',
                        widget: CustomerSupport(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      // Navigator.of(context, rootNavigator: true)
                      //     .pushReplacement(MaterialPageRoute(
                      //         builder: (context) => ResetProviders()));
                      setState(() {
                        _isLoading = true;
                      });
                      ProviderManager().resetAll();
                      // await resetProvs();
                      try {
                        await Future.delayed(const Duration(seconds: 1));
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        // Navigator.of(context)
                        //     .popUntil((route) => route.isFirst);
                        // await Future.delayed(const Duration(
                        //     milliseconds:
                        //         500)); // Optional delay for visual effect
                        // exit(0); // Close the app

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUpAuthPage()));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/signupPage', (route) => false);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Couldn\'t Sign Out, Try Again ')));
                        Navigator.of(context).pop();
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Container(
                      height: 71.0,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: w, borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   // maxRadius: 32,
                            //   radius: 16,
                            //   backgroundColor: b.withOpacity(0.06),
                            //   child: SvgPicture.asset(
                            //     'lib/icons/person.svg',
                            //     width: 14,
                            //     height: 14,
                            //   ),
                            // ),
                            //
                            const Spacer(),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                  fontSize: 14, color: b.withOpacity(0.6)),
                            ),
                            const Spacer(),
                            // Center(
                            //   child: Icon(
                            //     LineIcons.angleRight,
                            //     color: b32,
                            //     size: 14,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  )
                ],
              ),
            ),
          )),
        ),
        if (_isLoading)
          ModalBarrier(
            semanticsOnTapHint: 'Processing',
            dismissible: false,
            color: b.withOpacity(0.12),
          ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(
              color: blue,
              strokeWidth: 2,
            ),
          )
      ],
    );
  }
}
