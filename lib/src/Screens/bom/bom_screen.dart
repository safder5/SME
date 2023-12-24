import 'package:SMEflow/src/Providers/bom_providers.dart';
import 'package:SMEflow/src/Providers/iq_list_provider.dart';
import 'package:SMEflow/src/Screens/bom/bom_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import 'convert_item_to_bom.dart';

class BomScreen extends StatefulWidget {
  const BomScreen({super.key});

  @override
  State<BomScreen> createState() => _BomScreenState();
}

class _BomScreenState extends State<BomScreen> {
  @override
  void initState() {
    super.initState();
  }
//    final GlobalKey<_BomScreenState> _keyToReload =
//       GlobalKey<_BomScreenState>();

// void reload() {
//     // Perform any actions needed to reload the widget state
//     setState(() {
//       // Update state variables or reset data
//     });
//   }

  @override
  Widget build(BuildContext context) {
    //    if (_keyToReload.currentState != null) {
    //   _keyToReload.currentState!
    //       .reload(); // Call a function that triggers the reload
    // }
    // final pvdr = Provider.of<ItemsProvider>(context, listen: false);

    // create list to load boms for this screen
    return Consumer<BOMProvider>(builder: (_, bom, __) {
      final boms = bom.boms;
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
              // _showMaterialAlert(context);

              // _showListSelection(context, items);
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => const ItemSelection()));
            }),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ((boms.isEmpty)
                    ? const Center(child: Text('No BOMS, Add below'))
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: boms.length,
                        itemBuilder: (context, index) {
                          final bom = boms[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) => BOMPage(
                                              bom: bom,
                                            )));
                              },
                              child: BOMContainer(bom: bom));
                        })),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// void _showMaterialAlert(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Does this Product already exist in Inventory?',
//             style: TextStyle(fontSize: 16),
//           ),
//           // content: const Text('Does this Product already exist in Inventory?'),
//           backgroundColor: w,
//           surfaceTintColor: t,
//           shadowColor: blue,
//           actions: [
//             Row(
//               children: [
//                 TextButton(
//                   // style: TextButton.styleFrom(),
//                   onPressed: () {
//                     // Navigate to the second page when the second option is selected
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: r),
//                   ),
//                 ),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: () {
//                     // Navigate to the first page when the first option is selected
//                     Navigator.of(context).pop(); // Close the dialog
//                     // Navigator.of(context, rootNavigator: true).push(
//                     //   MaterialPageRoute(
//                     //     builder: (context) => const NewBOM(),
//                     //   ),
//                     // );
//                     //add another dialog to select the item
//                     _showListSelection(context);
//                   },
//                   child: Text(
//                     'Yes',
//                     style: TextStyle(color: blue),
//                   ),
//                 ),
//                 TextButton(
//                   // style: TextButton.styleFrom(),
//                   onPressed: () {
//                     // Navigate to the second page when the second option is selected
//                     Navigator.of(context).pop(); // Close the dialog
//                     Navigator.of(context, rootNavigator: true).push(
//                       MaterialPageRoute(
//                         builder: (context) => const NewBOM(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'New',
//                     style: TextStyle(color: blue),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       });
// }

// Future<void> _showListSelection(BuildContext context, List<String> items) {
//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: w,
//           surfaceTintColor: w,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(Icons.close))
//           ],
//           title: const Text('Select Item'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(items[index]),
//                   onTap: () {
//                     final name = items[index];
//                     // Handle item tap
//                     Navigator.of(context).pop();
//                     Navigator.of(context, rootNavigator: true).push(
//                       MaterialPageRoute(
//                         builder: (context) => ConvertItemtoBOM(
//                           productName: name,
//                         ),
//                       ),
//                     ); // Close the dialog
//                     // You can perform any action based on the tapped item
//                     print('Tapped on: ${items[index]}');
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       });
// }

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

class ItemSelection extends StatefulWidget {
  const ItemSelection({super.key});

  @override
  State<ItemSelection> createState() => _ItemSelectionState();
}

class _ItemSelectionState extends State<ItemSelection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (_, itemspvdrr, __) {
      final items = itemspvdrr.getitemNamesofNOTBOMSYET();
      return Scaffold(
        backgroundColor: w,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(LineIcons.angleLeft)),
                  const SizedBox(width: 10),
                  const Text('Add Item'),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.75,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]),
                      onTap: () {
                        final name = items[index];
                        // Handle item tap
                        // Navigator.of(context).pop();
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ConvertItemtoBOM(
                              productName: name,
                            ),
                          ),
                        ); // Close the dialog
                      },
                    );
                  },
                ),
              )
            ]),
          ),
        )),
      );
    });
  }
}
