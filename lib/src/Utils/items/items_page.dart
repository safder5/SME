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
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    child: const Icon(LineIcons.angleLeft),
                  ),
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
              const SizedBox(height: 32),
              // Add the search bar here
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  suffixIcon: Icon(LineIcons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              Consumer<ItemsProvider>(
                builder: (_, ip, __) {
                  // Filter items based on the search query
                  final items = ip.allItems
                      .where((item) =>
                          item.itemName.toLowerCase().contains(_searchQuery))
                      .toList()
                      .reversed
                      .toList();

                  return Expanded(
                    child: (items.isEmpty)
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
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
