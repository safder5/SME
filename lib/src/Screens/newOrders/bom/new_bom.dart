import 'package:ashwani/src/Models/bom_model.dart';
import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Screens/newOrders/bom/add_new_bom_item.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

import '../../../Models/iq_list.dart';
import '../../../Models/item_tracking_model.dart';
import '../../../constantWidgets/boxes.dart';

class NewBOM extends StatefulWidget {
  const NewBOM({super.key});

  @override
  State<NewBOM> createState() => _NewBOMState();
}

class _NewBOMState extends State<NewBOM> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;
  bool itemExists(String name) {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    if (itemsProvider.getItemNames().contains(name)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _executeFutures(BOMmodel bom) async {
    final provider = Provider.of<BOMProvider>(context, listen: false);
    await provider.uploadBOMtoDB(bom);
    provider.addBOMtoProv(bom);
    // add item to database and provider
    uploadtoInventory();
    provider.clearItems();
  }

  String? validProductName(String? value) {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    if (itemsProvider.getItemNames().contains(value)) {
      return "Item already exists in Inventory";
    } else if (value == null) {
      return " Enter Product Name";
    }
    return null;
  }

  void uploadtoInventory() async {
    try {
      CollectionReference collRef =
          _fs.collection('UserData').doc('${_auth!.email}').collection('Items');

      ItemTrackingModel itm = ItemTrackingModel(
          orderID: _auth?.email, quantity: 0, reason: 'Created BOM');
      Item item = Item(
          imageURL: "",
          itemName: _productName.text,
          quantityPurchase: 0,
          quantitySales: 0,
          itemQuantity: 0,
          bom: true,
          itemTracks: [itm]);

      final itemProviderforAddingItem =
          Provider.of<ItemsProvider>(context, listen: false);
      await itemProviderforAddingItem.addBOMProducttoFBasItem(item, collRef);
      itemProviderforAddingItem.addInvItemtoProvider(item, itm);
    } catch (e) {
      print('error uploading bom to inv #e');
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

  bool _isLoading = false;
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bomProvider = Provider.of<BOMProvider>(context);
    final itemsProvider = Provider.of<ItemsProvider>(context);
    print(itemsProvider.getItemNames().length);
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
                      validator: validProductName,
                      // onChanged: (value) {
                      //   validateName(value);
                      // },
                      controller: _productName,
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
                          if (_productName.text.isNotEmpty) {
                            // validateName(_productName.text);
                            List<String> itemNames = [];
                            try {
                              for (Item element in itemsProvider.allItems) {
                                itemNames.add(element.itemName);
                              }
                            } catch (e) {
                              print(e);
                            }
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
                                              _productName.text.trim())
                                          .map((item) => item.itemName)
                                          .toList());
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: blue,
                              content: Text(
                                'Enter Product Name First',
                                style: TextStyle(color: w),
                              ),
                              duration: const Duration(seconds: 2),
                              elevation: 6,
                            ));
                          }
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
                        if (bomProvider.items.isNotEmpty &&
                            _productName.text.trim().isNotEmpty &&
                            !itemExists(_productName.text)) {
                          BOMmodel bom = BOMmodel(
                              productName: _productName.text.toString(),
                              itemswithQuantities: bomProvider.items,
                              notes: _notes.text,
                              productCode: _productCode.text);
                          try {
                            _handleSubmit(bom);
                          } catch (e) {
                            print('error in submit $e');
                          }
                        } else if (_productName.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: blue,
                            content: Text(
                              'Itemname is empty',
                              style: TextStyle(color: w),
                            ),
                            duration: const Duration(seconds: 2),
                            elevation: 6,
                          ));
                        } else if (itemExists(_productName.text)) {
                          // show snackbar that product already exists
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: blue,
                            content: Text(
                              'Product Name already Exists!',
                              style: TextStyle(color: w),
                            ),
                            duration: const Duration(seconds: 2),
                            elevation: 6,
                          ));
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
                          style: TextStyle(
                            color: w, fontSize: 14
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay()
      ],
    );
  }
}
