
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../Models/iq_list.dart';
import '../../Models/sales_order.dart';
import '../../Providers/customer_provider.dart';
import '../../Providers/iq_list_provider.dart';
import '../../Providers/new_sales_order_provider.dart';
import '../../Services/helper.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';
import 'addItemto Order/add_sales_order_item.dart';

const List<String> paymentMethods = <String>[
  'Payment Methods',
  'methods',
  'one',
  'two'
];

class NewSalesOrder extends StatefulWidget {
  const NewSalesOrder({
    super.key,
  });
  @override
  State<NewSalesOrder> createState() => _NewSalesOrderState();
}

class _NewSalesOrderState extends State<NewSalesOrder> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final AutovalidateMode _fAVM = AutovalidateMode.onUserInteraction;

  final String status = 'open';
  String dropdownValue = paymentMethods.first;

  TextEditingController dateController = TextEditingController();
  TextEditingController dateShipmentController = TextEditingController();
  TextEditingController nameSearchController = TextEditingController();
  TextEditingController notesCtrl = TextEditingController();
  TextEditingController tandcCtrl = TextEditingController();

  DateTime cDate = DateTime.now();
  var id = DateTime.now().microsecondsSinceEpoch;
  final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  List<String> customerNames = [];
  List<String> suggestions = [];

  Future<void> fetchCustomerNames(BuildContext context) async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    try {
      await customerProvider.fetchAllCustomers();
      setState(() {
        customerNames = customerProvider.getAllCustomerNames();
      });
    } catch (e) {
      print('error fetching customer naams $e');
    }
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        suggestions.clear();
      });
    }
    setState(() {
      suggestions = customerNames
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  _showMyDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text('Dialog Title'), content: Text('hehe'));
      },
    );
  }

  static _showSnackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Required Fields are missing check for Items and Customer Name')));
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerNames(context);
    suggestions = customerNames;
  }

  @override
  Widget build(BuildContext context) {
    final soItemsProvider = Provider.of<ItemsProvider>(context);
    final salesProvider = Provider.of<NSOrderProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);

    // final customerProvider = Provider.of<CustomerProvider>(context);
    // final List<String> customers = customerProvider.getAllCustomerNames();
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            if (soItemsProvider.soItems.isNotEmpty &&
                nameSearchController.text.isNotEmpty) {
              try {
                final newSalesOrder = SalesOrderModel(
                    orderID: int.parse(orderId),
                    customerName: nameSearchController.text,
                    orderDate: dateController.text,
                    shipmentDate: dateShipmentController.text,
                    paymentMethods: dropdownValue,
                    notes: notesCtrl.text,
                    tandC: tandcCtrl.text,
                    status: status,
                    items: soItemsProvider.soItems);
                print(newSalesOrder.items?.length);
                salesProvider.addSalesOrderInProvider(newSalesOrder);
                await salesProvider.addSalesOrder(newSalesOrder);
                await soItemsProvider.updateItemsSOandTrack(orderId);
                await customerProvider.uploadOrderInCustomersProfile(
                    newSalesOrder, nameSearchController.text);

                // salesProvider.addSalesOrderInProvider(
                //     newSalesOrder, soItemsProvider.soItems);
              } catch (e) {
                print('add sales order mein error $e');
              }
            } else {
              // _showSnackBar(context);
            }

            // update it to firebase
            // soItemsProvider.clearsoItems();
            // await Future.delayed(Duration(seconds: 1));

            //submit everything after validation is processed
            if (!context.mounted) return;
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const MyApp()));
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
              'Add Sales Order',
              style: TextStyle(color: w, fontSize: 14),
            )),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // itemProvider.clearItems();
                        },
                        child: const Icon(LineIcons.angleLeft)),
                    const SizedBox(width: 10),
                    const Text('New Sales Order'),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        //submit everything after validation is processed
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            border: Border.all(width: 0.6, color: blue)),
                        // width: double.infinity,
                        // height: 48,
                        child: Center(
                            child: Text(
                          'Save Draft',
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.w300),
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Form(
                  key: form,
                  autovalidateMode: _fAVM,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                            controller: nameSearchController,
                            cursorColor: blue,
                            onChanged: _updateSuggestions,
                            cursorWidth: 1,
                            textCapitalization: TextCapitalization.words,
                            // validator: validateName,
                            // onChanged: (String query) {
                            //   customerProvider.filterCustomers(query);
                            // },
                            textInputAction: TextInputAction.next,
                            decoration: getInputDecoration(
                                hint: 'Type Customer Name or Search',
                                errorColor: Colors.red)),
                        // const SizedBox(
                        //   height: 24,
                        // ),
                        if (suggestions.isEmpty)
                          Container()
                        else
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.03),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            height: 120,
                            child: SizedBox(
                              child: ListView.builder(
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        nameSearchController.text =
                                            suggestions[index];
                                        suggestions.clear();
                                      });
                                    },
                                    child: ListTile(
                                      title: Text(suggestions[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: soItemsProvider.soItems.length * 80,
                          child: ListView.builder(
                              itemCount: soItemsProvider.soItems.length,
                              itemBuilder: (context, index) {
                                final item = soItemsProvider.soItems[index];
                                return NewSalesOrderItemsTile(
                                  index: index,
                                  name: item.itemName,
                                  quantity: item.quantitySales.toString(),
                                );
                              }),
                        ),
                        GestureDetector(
                          onTap: () {
                            // why are there nested gesture detectors here
                          },
                          child: GestureDetector(
                            onTap: () async {
                              // await soItemsProvider.getItems();
                              List<String> itemNames = [];
                              try {
                                for (Item element in soItemsProvider.allItems) {
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
                                    return AddSalesOrderItem(
                                      items: soItemsProvider.allItems,
                                    );
                                  });
                            },
                            child: AbsorbPointer(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent,
                                    border:
                                        Border.all(width: 0.6, color: blue)),
                                width: double.infinity,
                                height: 48,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LineIcons.plusCircle,
                                      color: blue,
                                    ),
                                    Text(
                                      '  Add Items & Quantity',
                                      style: TextStyle(
                                          color: blue,
                                          fontWeight: FontWeight.w300),
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
                        TextFormField(
                            cursorColor: blue,
                            cursorWidth: 1,
                            readOnly: true,
                            initialValue: '#$orderId',
                            textInputAction: TextInputAction.next,
                            decoration: getInputDecoration(
                                hint: 'Order No. #2304',
                                errorColor: Colors.red)),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          cursorColor: blue,
                          cursorWidth: 1,
                          textCapitalization: TextCapitalization.words,
                          // validator: validateDate,
                          // onSaved: (String? val) {
                          //   orderDate = val;
                          // },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                                  hint: 'Order Date', errorColor: Colors.red)
                              .copyWith(
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                initialDate: cDate,
                                                firstDate:
                                                    DateTime.utc(1965, 1, 1),
                                                lastDate:
                                                    DateTime(cDate.year + 1));
                                        if (pickedDate != null) {
                                          //get the picked date in the format => 2022-07-04 00:00:00.000
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy').format(
                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                          //formatted date output using intl package =>  2022-07-04
                                          setState(() {
                                            dateController.text =
                                                formattedDate; //set foratted date to TextField value.
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        LineIcons.calendarWithDayFocus,
                                        color: b25,
                                      ))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: dateShipmentController,
                          readOnly: true,
                          cursorColor: blue,
                          cursorWidth: 1,
                          textCapitalization: TextCapitalization.words,
                          // validator: validateDate,
                          // onSaved: (String? val) {
                          //   shipmentDate = val;
                          // },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                                  hint: 'Expected Shipment date',
                                  errorColor: Colors.red)
                              .copyWith(
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialEntryMode:
                                                    DatePickerEntryMode
                                                        .calendarOnly,
                                                initialDate: cDate,
                                                firstDate:
                                                    DateTime.utc(1965, 1, 1),
                                                lastDate:
                                                    DateTime(cDate.year + 2));
                                        if (pickedDate != null) {
                                          //get the picked date in the format => 2022-07-04 00:00:00.000
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy').format(
                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                          //formatted date output using intl package =>  2022-07-04
                                          setState(() {
                                            dateShipmentController.text =
                                                formattedDate;
                                            //set foratted date to TextField value.
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        LineIcons.calendarWithDayFocus,
                                        color: b25,
                                      ))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.6, color: b.withOpacity(0.15)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(5),
                                  value: dropdownValue,
                                  // icon:  Icon(lineicons.),
                                  iconDisabledColor: Colors.transparent,
                                  iconEnabledColor: Colors.transparent,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: b32,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                  underline: Container(
                                    height: 66,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: paymentMethods
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Center(child: Text(value)),
                                    );
                                  }).toList(),
                                ),
                                const Spacer(),
                                // Icon(LineIcons.angleDown,color: b32,)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: notesCtrl,
                          cursorColor: blue,
                          cursorWidth: 1,
                          // textCapitalization: TextCapitalization.words,
                          // validator: validateName,
                          // onChanged: (String? val) {
                          //   notes = val;
                          // },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Notes From Customer',
                              errorColor: Colors.red),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                            controller: tandcCtrl,
                            cursorColor: blue,
                            cursorWidth: 1,
                            // onChanged: (String? val) {
                            //   tandc = val;
                            // },
                            textInputAction: TextInputAction.next,
                            decoration: getInputDecoration(
                                hint: 'Terms and Conditions',
                                errorColor: Colors.red)),
                        const SizedBox(
                          height: 24,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
