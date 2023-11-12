// import 'dart:io';

import 'package:ashwani/Providers/bom_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import '../newOrders/bom/new_bom.dart';

class BomScreen extends StatefulWidget {
  const BomScreen({super.key});

  @override
  State<BomScreen> createState() => _BomScreenState();
}

class _BomScreenState extends State<BomScreen> {
  @override
  Widget build(BuildContext context) {
    // create list to load boms for this screen
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
          heroTag: '/newBOM',
          // elevation: 0,
          tooltip: 'New Bill Of Material',
          backgroundColor: blue,
          child: const Center(
            child: Icon(
              LineIcons.plus,
              size: 30,
            ),
          ),
          onPressed: () {
            // show options dialog
            _showMaterialAlert(context);
            // Navigator.of(context, rootNavigator: true)
            //     .push(MaterialPageRoute(builder: (context) => const NewBOM()));
          }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<BOMProvider>(builder: (_, prov, __) {
              final items = prov.boms.reversed.toList();
              return Expanded(
                child: ((items.isEmpty)
                    ? const Center(child: Text('No BOMS, Add below'))
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ItemScreen(
                                //               item: item,
                                //             )));
                              },
                              child: ItemsPageContainer(
                                itemName: item.productName,
                                sku: '0',
                              ));
                        })),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// void _showPlatformSpecificAlert(BuildContext context) {
//   if (Platform.isIOS) {
//     _showCupertinoAlert(context);
//   } else if (Platform.isAndroid) {
//     _showMaterialAlert(context);
//   }
// }

void _showMaterialAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Does this Product already exist in Inventory?',
            style: TextStyle(fontSize: 16),
          ),
          // content: const Text('Does this Product already exist in Inventory?'),
          backgroundColor: w,
          surfaceTintColor: t,
          shadowColor: blue,
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the first page when the first option is selected
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const NewBOM(),
                  ),
                );
              },
              child: Text(
                'Yes',
                style: TextStyle(color: blue),
              ),
            ),
            TextButton(
              // style: TextButton.styleFrom(),
              onPressed: () {
                // Navigate to the second page when the second option is selected
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const NewBOM(),
                  ),
                );
              },
              child: Text(
                'No',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      });
}

void _showCupertinoAlert(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Choose Option'),
          content: const Text('Does this Product already exist in Inventory?'),
          // backgroundColor: w,
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the first page when the first option is selected
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const NewBOM(),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the second page when the second option is selected
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const NewBOM(),
                  ),
                );
              },
              child: const Text('No'),
            ),
          ],
        );
      });
}
