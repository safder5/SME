import 'package:ashwani/Screens/newOrders/addItemto%20Order/addOrderItem.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

const List<String> paymentMethods = <String>[
  'Payment Methods',
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
  // final GlobalKey<_NewSalesOrderState> _form = GlobalKey<_NewSalesOrderState>();
  final AutovalidateMode _fAVM = AutovalidateMode.onUserInteraction;
  String? firstName, orderNo, shipmentDate, orderDate, notes;
  DateTime cDate = DateTime.now();
  String dropdownValue = paymentMethods.first;
  TextEditingController dateController = TextEditingController();
  TextEditingController dateShipmentController = TextEditingController();

  var id = DateTime.now().microsecondsSinceEpoch;
  final String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
    
  // }

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
                          // validator: validateName,
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
                                  return AddOrderItem();
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
                          readOnly: true,
                          initialValue: '#$orderId',
                          // textCapitalization: TextCapitalization.words,
                          onChanged: (value) {
                            orderNo = value;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Order No. #2304', errorColor: Colors.red)),
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
                        onSaved: (String? val) {
                          orderDate = val;
                        },
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
                        onSaved: (String? val) {
                          shipmentDate = val;
                        },
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.6, color: b.withOpacity(0.15)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
