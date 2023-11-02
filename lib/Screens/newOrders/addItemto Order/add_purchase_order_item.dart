import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/Utils/items/add_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../Models/iq_list.dart';
import '../../../constants.dart';

class AddPurchaseOrderItem extends StatefulWidget {
  const AddPurchaseOrderItem({super.key,required this.items});
  final List<Item> items;

  @override
  State<AddPurchaseOrderItem> createState() => _AddPurchaseOrderItemState();
}

class _AddPurchaseOrderItemState extends State<AddPurchaseOrderItem> {
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _qtyCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final auth = FirebaseAuth.instance.currentUser;
  int itemQuantity = 0;
  Item selectedItem = Item(itemName: '', itemQuantity: 0, quantityPurchase: 0);
  String itemLimit = '';

  getData() async {
    String item = _itemnameController.text;
    if (item != '') {
      try {
        for (var i in widget.items) {
          if (i.itemName! == item) {
            setState(() {
              selectedItem = i;
              itemLimit = (i.itemQuantity! - i.quantitySales!).toString();
              print('item limit $itemLimit');
            });
            break;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _itemnameController.addListener(getData);
  }

  @override
  Widget build(BuildContext context) {
    final poItemsProvider = Provider.of<ItemsProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: w,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
              minStringLength: 1,
              label: 'Search Item',
              controller: _itemnameController,
              decoration: getInputDecoration(hint: 'Search Item', errorColor: r)
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
              initialList: poItemsProvider.getItemNames(),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              cursorColor: blue,
              cursorWidth: 1,
              onSaved: (value) {
                selectedItem.quantityPurchase = (int.tryParse(value ?? ''));
              },
              textInputAction: TextInputAction.next,
              decoration: getInputDecoration(hint: '12', errorColor: Colors.red)
                  .copyWith(
                // suffix: GestureDetector(
                //   onTap: () {
                //     // change type of unit
                //     // Navigator.of(context,
                //     //         rootNavigator: true)
                //     //     .push(MaterialPageRoute(
                //     //         builder: (context) =>
                //     //             AddItems()));
                //   },
                //   child: Icon(
                //     LineIcons.box,
                //     size: 18,
                //     color: blue,
                //   ),
                // ),
              ),
              onChanged: (value) {
                try {
                  itemQuantity = int.parse(value);
                } catch (e) {
                  itemQuantity = int.parse('0');
                }
                // String limit = await checkQuantityLimit();
                // print(limit);
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
                              selectedItem.quantityPurchase.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, color: blue),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Already Purchased',
                              style: TextStyle(fontWeight: FontWeight.w300),
                              textScaleFactor: 0.8,
                            )
                          ],
                        ),
                        const Spacer(),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       (selectedItem.itemQuantity! + int.parse(selectedItem.quantityPurchase!)).toString(),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w300, color: blue),
                        //     ),
                        //     const SizedBox(
                        //       height: 8,
                        //     ),
                        //     const Text(
                        //       'Available for sale',
                        //       style: TextStyle(fontWeight: FontWeight.w300),
                        //       textScaleFactor: 0.8,
                        //     )
                        //   ],
                        // ),
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
                  poItemsProvider.addpoitem(Item(
                    itemName: _itemnameController.text,
                    quantityPurchase: itemQuantity,
                    originalQuantity: itemQuantity,
                  ));
                } catch (e) {
                  //snackbar to show item not added
                  print(e);
                }
                // add items and pass the item and quantity to the list in sales order
                Navigator.pop(context);
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
    );
  }
}
