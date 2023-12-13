import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

import '../../Models/bom_model.dart';
import '../../Providers/bom_providers.dart';
import '../../Providers/iq_list_provider.dart';
import '../../Services/helper.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import '../newOrders/bom/add_new_bom_item.dart';

class ConvertItemtoBOM extends StatefulWidget {
  const ConvertItemtoBOM({super.key, required this.productName});
  final String productName;

  @override
  State<ConvertItemtoBOM> createState() => _ConvertItemtoBOMState();
}

class _ConvertItemtoBOMState extends State<ConvertItemtoBOM> {
  Future<void> _executeFutures(BOMmodel bom) async {
    final provider = Provider.of<BOMProvider>(context, listen: false);
    await provider.uploadBOMtoDB(bom);
    provider.addBOMtoProv(bom);
    // add item to database and provider
    await uploadtoInventory();
    provider.clearItems();
  }

  Future<void> uploadtoInventory() async {
    try {
      final itemProviderforAddingItem =
          Provider.of<ItemsProvider>(context, listen: false);
      await itemProviderforAddingItem
          .updateItemAsBOMtoFirebase(widget.productName);
      itemProviderforAddingItem.updateItemAsBOMinProvider(widget.productName);
    } catch (e) {
      // print('error uploading existing item as bom to inv $e');
      //not handling cuz its a provider data it will be corrected on reloading
    }
  }

  void _handleSubmit(BOMmodel bom) async {
    if (mounted) {
      setState(() {
        _isLoading = true; // Show loading overlay
      });
    }
    if (mounted) {
      await _executeFutures(bom).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    if (!context.mounted) return;
    {
      Navigator.pop(context);
    }
  }

  void _showErrordialogforaddbom() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: w,
          surfaceTintColor: w,
          title: const Text('Error'),
          content:
              const Text('There was an error Adding BOM. Check connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isLoading = false;
  // final TextEditingController _productName = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bomProvider = Provider.of<BOMProvider>(context);
    final itemsProvider = Provider.of<ItemsProvider>(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: w,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              bomProvider.clearItems();
                              Navigator.pop(context);
                            },
                            icon: const LineIcon.arrowLeft()),
                        const Text("Create BOM")
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: widget.productName),
                      readOnly: true,
                      decoration: getInputDecoration(
                          hint: 'Product Name', errorColor: r),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        // why are there nested gesture detectors here
                      },
                      child: GestureDetector(
                        onTap: () async {
                          // validateName(_productName.text);
                          // List<String> itemNames = [];
                          // try {
                          //   for (Item element in itemsProvider.allItems) {
                          //     itemNames.add(element.itemName);
                          //   }
                          // } catch (e) {
                          //   print(e);
                          // }
                          // if the list of get items is empty dont show modal display message add items
                          // or show modal and create items on the go not an organised way tho
                          //show BottomModalSheet
                          if (!context.mounted) return;
                          showModalBottomSheet<dynamic>(
                              backgroundColor: t,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AddNewBOMItems(
                                    items: itemsProvider.allItems
                                        .where((element) =>
                                            element.itemName !=
                                            widget.productName)
                                        .map((item) => item.itemName)
                                        .toList());
                              });
                          //  else {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     backgroundColor: blue,
                          //     content: Text(
                          //       'Enter Product Name First',
                          //       style: TextStyle(color: w),
                          //     ),
                          //     duration: const Duration(seconds: 2),
                          //     elevation: 6,
                          //   ));
                          // }
                        },
                        child: AbsorbPointer(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                                border: Border.all(width: 0.6, color: blue)),
                            width: double.infinity,
                            height: 48,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('lib/icons/plus.svg'),
                                Text(
                                  '  Add Items & Quantity',
                                  style: TextStyle(
                                      color: blue, fontWeight: FontWeight.w300),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: bomProvider.items.length * 80,
                      child: ListView.builder(
                          itemCount: bomProvider.items.length,
                          itemBuilder: (context, index) {
                            final item = bomProvider.items[index];
                            return NewBomOrderItemTile(
                              index: index,
                              name: item.itemname,
                              quantity: item.quantity.toString(),
                            );
                          }),
                    ),
                    TextField(
                      controller: _productCode,
                      decoration: getInputDecoration(
                          hint: 'Product Code', errorColor: r),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      controller: _notes,
                      decoration:
                          getInputDecoration(hint: 'Notes', errorColor: r),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (bomProvider.items.isNotEmpty) {
                          BOMmodel bom = BOMmodel(
                              productName: widget.productName,
                              itemswithQuantities: bomProvider.items,
                              notes: _notes.text,
                              productCode: _productCode.text);

                          try {
                            _handleSubmit(bom);
                          } catch (e) {
                            // print('error in submit $e');
                            _showErrordialogforaddbom();
                          }
                        }
                        // check form sate is valid or fields are not empty
                        // upload the bom model to fb
                        // add this bom model in its provider
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: blue,
                        ),
                        width: double.infinity,
                        height: 48,
                        child: Center(
                            child: Text(
                          'Add BOM',
                          style: TextStyle(color: w, fontSize: 14),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        // if (_isLoading) const LoadingOverlay()
      ],
    );
  }
}
