import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Utils/items/addItems.dart';
import 'package:ashwani/Utils/items/item_screen.dart';
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

  @override
  void initState() {
    super.initState();
    fetchItems(context);
  }

  Future<void> fetchItems(BuildContext context) async {
    final itemProvider = Provider.of<ItemsProvider>(context, listen: false);

    try {
      await itemProvider.getItems();
      setState(() {
        items = itemProvider.allItems;
      });
    } catch (e) {
      print('error getting fetchitems item screen $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddItems()));
        },
        child: const Icon(LineIcons.plus),
      ),
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
                const SizedBox(width: 10),
                const Text('Items'),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child:(
                   
                    (items.isEmpty) ?
                       const Text('No Items, Add below'):
                    
                     ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
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
                                itemName: items[index].itemName!,
                                sku: items[index].itemQuantity
                                    .toString()),
                          );
                        })
                  ),
            )
          ],
        ),
      )),
    );
  }
}
