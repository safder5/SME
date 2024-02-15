import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:ashwani/src/constants.dart';
import 'package:ashwani/src/Utils/items/add_items.dart';
import 'package:ashwani/src/Utils/items/item_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  // final _auth = FirebaseAuth.instance.currentUser;
  List<Item> items = [];

  // Future<void> fetchItems(BuildContext context) async {
  //   final itemProvider = Provider.of<ItemsProvider>(context, listen: false);

  //   try {
  //     await itemProvider.getItems();
  //     setState(() {
  //       items = itemProvider.allItems;
  //     });
  //   } catch (e) {
  //     print('error getting fetchitems item screen $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const AddItems()));
      //   },
      //   child: const Icon(LineIcons.plus),
      // ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(LineIcons.angleLeft)),
                const Spacer(),
                const Text('Items'),
                const Spacer(),
                GestureDetector(
                  child: Icon(
                    LineIcons.plus,
                    color: blue,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddItems()));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Consumer<ItemsProvider>(
              builder: (_, ip, __) {
                final items = ip.allItems.reversed.toList();
                // if (items.length == 0) {
                //   ip.getItems();
                // }

                return Expanded(
                  child: ((items.isEmpty)
                      ? const Text('No Items, Add below')
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            bool del = true;
                            try {
                              if (items[index].itemTracks!.length > 1) {
                                del = false;
                              }
                            } catch (e) {
                              del = true;
                            }
                            final item = items[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemScreen(
                                              item: item,
                                            )));
                              },
                              child: ItemsPageContainer(
                                deletable: del,
                                itemName: items[index].itemName,
                                sku: items[index].itemQuantity.toString(),
                                unitType: items[index].unitType ?? 'None',
                              ),
                            );
                          })),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
