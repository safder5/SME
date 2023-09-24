import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../constants.dart';
import '../../../Utils/items/addItems.dart';

class AddSalesOrderItem extends StatefulWidget {
  const AddSalesOrderItem({super.key});

  @override
  State<AddSalesOrderItem> createState() => _AddSalesOrderItemState();
}

class _AddSalesOrderItemState extends State<AddSalesOrderItem> {
  final TextEditingController itemnameController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<String> itemNames = [];

  final auth = FirebaseAuth.instance.currentUser;

  String itemQuantity = '';
  String itemName = '';
  String itemUrl = '';

  getItemNames() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .get();
      for (var element in result.docs) {
        itemNames.add(element.id);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> checkQuantityLimit() async {
    String itemkanaam = itemnameController.text;
    String itemLimit = '0';
    if (itemkanaam.isNotEmpty) {
      try {
        var itemSS = await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(itemkanaam)
            .get();
        itemLimit = itemSS.data()?['sIh'];
      } catch (e) {
        return 'no';
      }
    }
    return itemLimit;
  }

  getData() async {
    String item = itemnameController.text;
    if (item != '') {
      try {
        var itemSS = await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(item)
            .get();

        itemQuantity = itemSS.data()?['sIh'];
        itemName = itemSS.data()?['item_name'];
        itemUrl = itemSS.data()?['imageUrl'];
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemNames();
    itemnameController.addListener(getData);
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemsProvider>(context);
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
              controller: itemnameController,
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
              initialList: itemNames,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              // validator: validateOrderNo,
              cursorColor: blue,
              cursorWidth: 1,
              textInputAction: TextInputAction.next,
              decoration:
                  getInputDecoration(hint: '1.00', errorColor: Colors.red)
                      .copyWith(
                suffix: GestureDetector(
                  onTap: () {
                    // change type of unit
                    // Navigator.of(context,
                    //         rootNavigator: true)
                    //     .push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             AddItems()));
                  },
                  child: Icon(
                    LineIcons.box,
                    size: 18,
                    color: blue,
                  ),
                ),
              ),
              onChanged: (value) {
                itemQuantity = value;
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
                              '200',
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
                              '55.0',
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
                              '145.0',
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
                  itemProvider.addItem(Item(
                      itemName: itemnameController.text,
                      itemQuantity: int.parse(itemQuantity)));
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
