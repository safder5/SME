import 'package:ashwani/Providers/bom_providers.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import '../newOrders/bom/new_bom.dart';
import 'convert_item_to_bom.dart';

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
          shape: const CircleBorder(),
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
            Row(
              children: [
                TextButton(
                  // style: TextButton.styleFrom(),
                  onPressed: () {
                    // Navigate to the second page when the second option is selected
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: r),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to the first page when the first option is selected
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigator.of(context, rootNavigator: true).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const NewBOM(),
                    //   ),
                    // );
                    //add another dialog to select the item
                    _showListSelection(context);
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
                    'New',
                    style: TextStyle(color: blue),
                  ),
                ),
              ],
            ),
          ],
        );
      });
}

Future<void> _showListSelection(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: w,
          surfaceTintColor: w,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close))
          ],
          title: const Text('Select Item'),
          content: Consumer<ItemsProvider>(builder: (_, p, __) {
            final items = p.getItemNames();
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      final name = items[index];
                      // Handle item tap
                      Navigator.of(context).pop();
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ConvertItemtoBOM(
                            productName: name,
                          ),
                        ),
                      ); // Close the dialog
                      // You can perform any action based on the tapped item
                      print('Tapped on: ${items[index]}');
                    },
                  );
                },
              ),
            );
          }),
        );
      });
}


// void _showPlatformSpecificAlert(BuildContext context) {
//   if (Platform.isIOS) {
//     _showCupertinoAlert(context);
//   } else if (Platform.isAndroid) {
//     _showMaterialAlert(context);
//   }
// }

// void _showCupertinoAlert(BuildContext context) {
//   showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: const Text('Choose Option'),
//           content: const Text('Does this Product already exist in Inventory?'),
//           // backgroundColor: w,
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Navigate to the first page when the first option is selected
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context, rootNavigator: true).push(
//                   MaterialPageRoute(
//                     builder: (context) => const NewBOM(),
//                   ),
//                 );
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to the second page when the second option is selected
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context, rootNavigator: true).push(
//                   MaterialPageRoute(
//                     builder: (context) => const NewBOM(),
//                   ),
//                 );
//               },
//               child: const Text('No'),
//             ),
//           ],
//         );
//       });
// }
