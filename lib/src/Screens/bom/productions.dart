import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/production.dart';
import 'package:ashwani/src/Screens/bom/add_production.dart';
import 'package:ashwani/src/Screens/bom/production_page.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:ashwani/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Production extends StatefulWidget {
  const Production({super.key});

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  bool isButtonVisible = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionProvider>(builder: (_, pp, __) {
      final prods = pp.prod;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBOMSelection(context);
            // Navigator.of(context, rootNavigator: true).push(
            //     MaterialPageRoute(builder: (context) => const AddProduction()));
          },
          heroTag: 'add-production',
          shape: const CircleBorder(),
          tooltip: 'New Bill Of Material',
          backgroundColor: blue,
          child: const Center(
            child: Icon(
              LineIcons.plus,
              size: 30,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: prods.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => ProductionPage(prod: prods[index])));
                            },
                            child: ProductionContainer(
                              prod: prods[index],
                            ),
                          );
                        }))
              ],
            )),
      );
    });
  }
}

Future<void> _showBOMSelection(BuildContext context) {
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
          content: Consumer<BOMProvider>(builder: (_, p, __) {
            final items = p.boms.map((e) => e.productName).toList();

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final bom = p.boms[index];
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      // final name = items[index];
                      // Handle item tap
                      Navigator.of(context).pop();
                      // await Future.delayed(Duration(seconds: 1));
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => AddProduction(
                            bomName: items[index],
                            bom: bom,
                          ),
                        ),
                      ); // Close the dialog
                      // You can perform any action based on the tapped item
                      // print('Tapped on: ${items[index]}');
                    },
                  );
                },
              ),
            );
          }),
        );
      });
}
