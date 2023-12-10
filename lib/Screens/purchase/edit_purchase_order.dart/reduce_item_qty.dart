import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/new_purchase_order_provider.dart';

class ReduceItemQty extends StatefulWidget {
  const ReduceItemQty(
      {super.key,
      required this.itemName,
      required this.orderId,
      required this.limit});
  final String itemName;
  final int orderId;
  final int limit;
  @override
  State<ReduceItemQty> createState() => _ReduceItemQtyState();
}

class _ReduceItemQtyState extends State<ReduceItemQty> {
  var _errorText ='';
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 500));
                      // dispose();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
              ],
            ),
            Text('Increase Quantity of ${widget.itemName} by value?'),
            TextField(
              keyboardType: TextInputType.number,
              controller: quantityController,
              decoration: getInputDecoration(
                      hint: 'Increase quantity by ', errorColor: r)
                  .copyWith(errorText: _errorText),
              onChanged: (value) {
                final intInput = int.tryParse(value);
                if (intInput == null || intInput > widget.limit) {
                  setState(() {
                    _errorText = 'Cannot exceed ${widget.limit}';
                  });
                } else {
                  setState(() {
                    _errorText = '';
                  });
                }
              },
            ),
            TextButton(
                onPressed: () async {
                  if (_errorText != '') return;
                  int q = int.parse(quantityController.text);
                  final prov =
                      Provider.of<NPOrderProvider>(context, listen: false);

                  await prov.reduceItemsDetailsQtyFB(
                      widget.orderId, widget.itemName, q);
                  prov.reduceItemsDetailsQTY(
                      widget.orderId, widget.itemName, q);
                  //update itemdetails in salesorder in providers
                  // update the same in firebase
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: blue),
                )),
          ],
        ),
      ),
    );
  }
}
