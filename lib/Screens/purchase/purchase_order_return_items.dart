import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';

class PurchaseOrderReturnItems extends StatefulWidget {
  const PurchaseOrderReturnItems({super.key, this.itemsRecieved, this.orderId});
  final List<ItemTrackingPurchaseOrder>? itemsRecieved;
  final int? orderId;

  @override
  State<PurchaseOrderReturnItems> createState() =>
      _PurchaseOrderReturnItemsState();
}

class _PurchaseOrderReturnItemsState extends State<PurchaseOrderReturnItems> {
  bool isLoading = false;
  int quantityReturned = 0;
  int itemLimit = 0;
  ItemTrackingPurchaseOrder selectedItem =
      ItemTrackingPurchaseOrder(itemName: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();

  Future<void> _handleSubmit() async {}

  List<String?> getItemNames() {
    return widget.itemsRecieved!.map((item) => item.itemName).toList();
  }

  getData() async {
    String itemName = _itemnameController.text;
    if (itemName.isNotEmpty && widget.itemsRecieved != null) {
      try {
        for (var i in widget.itemsRecieved!) {
          if (i.itemName == itemName) {
            setState(() {
              selectedItem = i;
              itemLimit = i.quantityRecieved;
            });
            break;
          }
        }
      } catch (e) {
        print('get data error $e');
      }
    }
  }

  String? validatePOIQ(String? value) {
    if (selectedItem.itemName.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return ' Please enter some Quantity';
    }
    int v = int.parse(value);
    if (v > itemLimit) {
      return 'Cannot exceed Purchased Quantity ($itemLimit)';
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
    return Stack(
      children: [
        Positioned(
            bottom: 0, // Adjust the position as needed
            left: 0, // Adjust the position as needed
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                  color: w,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Select Items and Quantities Delivered'),
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
                        decoration: getInputDecoration(
                            hint: 'Search Item', errorColor: r),
                        initialList: getItemNames(),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        // validator: validateOrderNo,
                        controller: _quantityCtrl,
                        validator: validatePOIQ,
                        cursorColor: blue,
                        cursorWidth: 1,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: '1.00', errorColor: Colors.red),
                        onChanged: (value) {


                          //check for value going null in all 4 bottom sheets 


                          quantityReturned = int.parse(value);
                          // String limit = await checkQuantityLimit();
                          // print(limit);
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        // validator: validateSOIQ,
                        controller: _refCtrl,
                        cursorColor: blue,
                        cursorWidth: 1,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'Reference number/ Bill number',
                            errorColor: Colors.red),
                        // onChanged: (value) {
                        //   refNumber = int.parse(value.replaceAll(RegExp(r'[^0-9]'),''));
                        // },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          try {
                            // validateForm();
                            if (validateForm() == true) {
                              print(true);
                              // track = ItemTrackingPurchaseOrder(
                              //     itemName: _itemnameController.text,
                              //     date: DateFormat('dd-MM-yyyy').format(now),
                              //     quantityRecieved: quantityRecieved);

                              isLoading ? null : _handleSubmit();

                              // if (!context.mounted) return;
                            } else {
                              print('error validating form');
                            }
                          } catch (e) {
                            //snackbar to show item not added
                            print('error $e');
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
            )),
        if (isLoading) LoadingOverlay()
      ],
    );
  }
}
