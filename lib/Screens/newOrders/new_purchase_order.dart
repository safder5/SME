import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../Services/helper.dart';
import 'addItemto Order/addOrderItem.dart';

class NewPurchaseOrder extends StatefulWidget {
  const NewPurchaseOrder({super.key});

  @override
  State<NewPurchaseOrder> createState() => _NewPurchaseOrderState();
}

class _NewPurchaseOrderState extends State<NewPurchaseOrder> {
  final GlobalKey<FormState> npoForm = GlobalKey<FormState>();
  final AutovalidateMode _npoAVM = AutovalidateMode.onUserInteraction;
  DateTime cdate = DateTime.now();

  final TextEditingController _vendorName = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  final TextEditingController _npodateController = TextEditingController();
  final TextEditingController _npoDelDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () {
            // submit final purchase order
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
              'Create Purchase Order',
              style: TextStyle(
                color: w,
              ),
              textScaleFactor: 1.2,
            )),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      style:
                          TextStyle(color: blue, fontWeight: FontWeight.w300),
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
                key: npoForm,
                autovalidateMode: _npoAVM,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: _vendorName,
                          cursorColor: blue,
                          cursorWidth: 1,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: getInputDecoration(
                              hint: 'Vendor Name', errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
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
                                      '  Add Items ',
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
                          const SizedBox(
                        height: 24,
                      ),
                      //add items
                      //
                      //
                      TextFormField(
                        controller: _npodateController,
                        readOnly: true,
                        // validator: validateDate,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                                hint: 'Purchase Order Date',
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
                                              initialDate: cdate,
                                              firstDate:
                                                  DateTime.utc(1965, 1, 1),
                                              lastDate:
                                                  DateTime(cdate.year + 1));
                                      if (pickedDate != null) {
                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy').format(
                                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                        //formatted date output using intl package =>  2022-07-04
                                        setState(() {
                                          _npodateController.text =
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
                        controller: _npoDelDateController,
                        readOnly: true,
                        // validator: validateDate,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                                hint: 'Purchase Order Date',
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
                                              initialDate: cdate,
                                              firstDate:
                                                  DateTime.utc(1965, 1, 1),
                                              lastDate:
                                                  DateTime(cdate.year + 1));
                                      if (pickedDate != null) {
                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy').format(
                                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                        //formatted date output using intl package =>  2022-07-04
                                        setState(() {
                                          _npoDelDateController.text =
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
                          controller: _notesController,
                          cursorColor: blue,
                          cursorWidth: 1,
                          decoration: getInputDecoration(
                              hint: 'Notes', errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                          controller: _termsController,
                          cursorColor: blue,
                          cursorWidth: 1,
                          decoration: getInputDecoration(
                              hint: 'Terms and Conditions',
                              errorColor: Colors.red)),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      )),
    );
  }
}
