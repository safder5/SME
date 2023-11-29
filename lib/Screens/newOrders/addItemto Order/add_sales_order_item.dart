import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/Services/helper.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../constants.dart';
import '../../../Utils/items/add_items.dart';

class AddSalesOrderItem extends StatefulWidget {
  const AddSalesOrderItem({super.key, this.items});
  final List<Item>? items;

  @override
  State<AddSalesOrderItem> createState() => _AddSalesOrderItemState();
}

class _AddSalesOrderItemState extends State<AddSalesOrderItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final auth = FirebaseAuth.instance.currentUser;

  Item selectedItem =
      Item(itemName: 'itemName', itemQuantity: 0, quantitySales: 0);

  int quantitySales = 0;
  String itemName = '';
  String itemUrl = '';
  String itemLimit = '';

  getData() async {
    String item = _itemnameController.text;
    if (item != '') {
      try {
        for (var i in widget.items!) {
          if (i.itemName == item) {
            setState(() {
              selectedItem = i;
              itemLimit = (i.itemQuantity! ).toString();
              print(itemLimit);
            });
            break;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  String? validateSOIQ(String? value) {
    if (selectedItem.itemName.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter some quantity';
    }

    int v = int.parse(value);
    if (v > int.parse(itemLimit)) {
      return 'Quantity cannot exceed inventory quantity (${int.parse(itemLimit)}).';
    }
    return null;
  }

  bool? validateForm() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _itemnameController.addListener(getData);
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemsProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Add items & quantity'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              CircleAvatar(
                backgroundColor: t,
                maxRadius: 22,
                child: const Image(
                  width: 44,
                  height: 44,
                  image: AssetImage('lib/images/itemimage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldSearch(
                // scrollbarDecoration: ScrollbarDecoration(controller: controller, theme: theme),

                minStringLength: 1,
                label: 'Search Item',
                controller: _itemnameController,
                decoration:
                    getInputDecoration(hint: 'Search Item', errorColor: r)
                        .copyWith(
                  suffix: GestureDetector(
                    onTap: () {
                      // add a unique item to items list
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const AddItems()));
                    },
                    child: Icon(
                      LineIcons.plus,
                      size: 18,
                      color: blue,
                    ),
                  ),
                ),
                initialList: itemProvider.getItemNames(),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _quantityCtrl,
                validator: validateSOIQ,
                cursorColor: blue,
                cursorWidth: 1,
                textInputAction: TextInputAction.next,
                decoration:
                    getInputDecoration(hint: '1.00', errorColor: Colors.red)
                        .copyWith(),
                onChanged: (value) {
                  try {
                    quantitySales = int.parse(value);
                  } catch (e) {
                    quantitySales = int.parse('0');
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.all(18),
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: f7,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Item Stock Details',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedItem.itemQuantity.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, color: blue),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text('Total stock',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                  textScaleFactor: 0.8)
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedItem.quantitySales.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, color: blue),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                'Already Sold',
                                style: TextStyle(fontWeight: FontWeight.w300),
                                textScaleFactor: 0.8,
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (selectedItem.itemQuantity! 
                                        )
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, color: blue),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                'Available for sale',
                                style: TextStyle(fontWeight: FontWeight.w300),
                                textScaleFactor: 0.8,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              // const SizedBox(height: 24,),
              GestureDetector(
                onTap: () async {
                  try {
                    if (validateForm() == true) {
                      itemProvider.addsoItem(Item(
                          itemName: _itemnameController.text,
                          quantitySales: quantitySales,
                          originalQuantity: quantitySales));
                      Navigator.pop(context);
                    } else {
                      print('error');
                    }
                  } catch (e) {
                    //snackbar to show item not added
                    print(e);
                  }
                  // add items and pass the item and quantity to the list in sales order
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
                    'Add Item',
                    style: TextStyle(
                      color: w,
                    ),
                    textScaleFactor: 1.2,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
