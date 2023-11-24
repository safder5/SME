import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Services/helper.dart';
import '../../../constants.dart';

class IncreaseDetailsItemQtyPO extends StatefulWidget {
  const IncreaseDetailsItemQtyPO({super.key, required this.itemName, required this.orderId});
  final String itemName;
  final int orderId;
  @override
  State<IncreaseDetailsItemQtyPO> createState() => _IncreaseDetailsItemQtyPOState();
}

class _IncreaseDetailsItemQtyPOState extends State<IncreaseDetailsItemQtyPO> {
   TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  hint: 'Increase quantity by ', errorColor: r),
            ),
            TextButton(
                onPressed: () async {
                  int q = int.parse(quantityController.text);
                  final prov =
                      Provider.of<NPOrderProvider>(context, listen: false);

                  await prov.updateitemDetailsquantityinFireBase(
                      widget.orderId, widget.itemName, q);
                  prov.updateitemDetailsquantityinProvider(
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