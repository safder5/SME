import 'package:ashwani/constants.dart';
import 'package:ashwani/items/addItems.dart';
import 'package:ashwani/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

const List<String> paymentMethods = <String>[
  'Payment Methods',
  'methods',
  'one',
  'two'
];

const List<String> deliveryMethods = <String>[
  'delivery',
  'methods',
  'one',
  'two'
];

class NewSalesOrder extends StatefulWidget {
  const NewSalesOrder({super.key});

  @override
  State<NewSalesOrder> createState() => _NewSalesOrderState();
}

class _NewSalesOrderState extends State<NewSalesOrder> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final GlobalKey<_NewSalesOrderState> _form = GlobalKey<_NewSalesOrderState>();
  final AutovalidateMode _fAVM = AutovalidateMode.onUserInteraction;
  String? firstName, orderNo, shipmentDate, orderDate, notes;
  DateTime cDate = DateTime.now();
  // String cD = cDate.toString().substring(0, 10);
  String dropdownValue = paymentMethods.first;
  String ddVDelivery = deliveryMethods.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () {
            //submit everything after validation is processed
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
              'Submit',
              style: TextStyle(
                color: w,
              ),
              textScaleFactor: 1.2,
            )),
          ),
        ),
      ),
      backgroundColor: w,
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
                          textScaleFactor: 1,
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
                  child: Column(
                    children: [
                      TextFormField(
                          cursorColor: blue,
                          cursorWidth: 1,
                          textCapitalization: TextCapitalization.words,
                          validator: validateName,
                          onSaved: (String? val) {
                            firstName = val;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Customer Name', errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          //submit everything after validation is processed
                        },
                        child: GestureDetector(
                          onTap: () {
                            //show BottomModalSheet
                            showModalBottomSheet<dynamic>(
                                backgroundColor: t,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.85,
                                    decoration: BoxDecoration(
                                        color: w,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Add items & quantity'),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                                              image: AssetImage(
                                                  'lib/images/itemimage.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          TextFormField(
                                            validator: validateName,
                                            cursorColor: blue,
                                            cursorWidth: 1,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: getInputDecoration(
                                                    hint: 'Item Name',
                                                    errorColor: Colors.red)
                                                .copyWith(
                                              suffix: GestureDetector(
                                                onTap: () {
                                                  // add a unique item to items list
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddItems()));
                                                },
                                                child: Icon(
                                                  LineIcons.plus,
                                                  size: 18,
                                                  color: blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          TextFormField(
                                            validator: validateOrderNo,
                                            cursorColor: blue,
                                            cursorWidth: 1,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: getInputDecoration(
                                                    hint: '1.00',
                                                    errorColor: Colors.red)
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
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(18),
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: f7,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Item Stock Details',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal:0.0),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('200',style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,color: blue),),
                                                          const SizedBox(height: 8,),
                                                          const Text('Total stock',style: TextStyle(fontWeight: FontWeight.w300),textScaleFactor: 0.8)
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('55.0',style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,color: blue),),
                                                          const SizedBox(height: 8,),
                                                          const Text('Already Sold',style: TextStyle(fontWeight: FontWeight.w300),textScaleFactor: 0.8,)
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                        Text('145.0',style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,color: blue),),
                                                          const SizedBox(height: 8,),
                                                          const Text('Available for sale',style: TextStyle(fontWeight: FontWeight.w300),textScaleFactor: 0.8,)
                                                      ],),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                                  Icon(
                                    LineIcons.plusCircle,
                                    color: blue,
                                  ),
                                  Text(
                                    '  Add Items & Quantity',
                                    style: TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.w300),
                                    textScaleFactor: 1,
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
                          // textCapitalization: TextCapitalization.words,
                          validator: validateOrderNo,
                          onSaved: (String? val) {
                            orderNo = val;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Order No. #2304', errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        cursorColor: blue,
                        cursorWidth: 1,
                        textCapitalization: TextCapitalization.words,
                        validator: validateDate,
                        onSaved: (String? val) {
                          orderDate = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                                //order date nikal li
                                hint: cDate.toString().substring(0, 10),
                                errorColor: Colors.red)
                            .copyWith(),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                          cursorColor: blue,
                          cursorWidth: 1,
                          textCapitalization: TextCapitalization.words,
                          validator: validateDate,
                          onSaved: (String? val) {
                            shipmentDate = val;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Expected Shipment date',
                              errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.6, color: b32),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      // GestureDetector(
                      //   onTap: () {
                      //     //submit everything after validation is processed
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(5),
                      //         color: Colors.transparent,
                      //         border: Border.all(width: 0.6, color: blue)),
                      //     width: double.infinity,
                      //     height: 48,
                      //     child: Center(
                      //         child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Icon(
                      //           LineIcons.plusCircle,
                      //           color: blue,
                      //         ),
                      //         Text(
                      //           '  Add Sales Person',
                      //           style: TextStyle(
                      //               color: blue, fontWeight: FontWeight.w300),
                      //           textScaleFactor: 1,
                      //         ),
                      //       ],
                      //     )),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 24,
                      // ),

                      // convert this next container into a separate widget
                      //also the below one
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.6, color: b32),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                value: ddVDelivery,
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
                                    ddVDelivery = value!;
                                  });
                                },
                                items: deliveryMethods
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
                        cursorColor: blue,
                        cursorWidth: 1,
                        // textCapitalization: TextCapitalization.words,
                        // validator: validateName,
                        onSaved: (String? val) {
                          notes = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'Notes From Customer',
                            errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                          cursorColor: blue,
                          cursorWidth: 1,
                          // textCapitalization: TextCapitalization.words,
                          // validator: validateName,
                          onSaved: (String? val) {
                            notes = val;
                          },
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
                Container(
                        height: 40,
                        width: 40,
                        color: b,
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.single,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
