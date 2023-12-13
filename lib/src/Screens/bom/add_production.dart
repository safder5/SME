import 'package:ashwani/src/Models/bom_model.dart';
import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Models/production_model.dart';
import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/production.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AddProduction extends StatefulWidget {
  const AddProduction({super.key, required this.bomName, required this.bom});
  final String bomName;
  final BOMmodel bom;
  @override
  State<AddProduction> createState() => _AddProductionState();
}

class _AddProductionState extends State<AddProduction> {
  bool _isProcessing = false;
  final TextEditingController quantityCtrl = TextEditingController();
  late List<Item> items;
  late List<BOMItem> bomItems;
  late List<CombinedItem> combinedData;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final prov = Provider.of<ItemsProvider>(context, listen: false);
    items = prov.allItems;
    bomItems = widget.bom.itemswithQuantities;
    combinedData = combineData(items, bomItems);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: w,
          surfaceTintColor: w,
          title: const Text('Success'),
          content: const Text('Data submitted successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _invalidSnackbar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: w,
            surfaceTintColor: w,
            content: const Text('Enter Valid Quantity'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: blue),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: w,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextButton(
                onPressed: () async {
                  if (_isProcessing) {
                    return;
                  }

                  if (quantityCtrl.text == '' ||
                      int.parse(quantityCtrl.text) <= 0) {
                    return _invalidSnackbar();
                  }
                  if (!checkAvailability(
                      combinedData, int.parse(quantityCtrl.text))) {
                    return _invalidSnackbar();
                  }

                  setState(() {
                    _isProcessing = true;
                  });
                  try {
                    // Your async database operations here
                    if (checkAvailability(
                        combinedData, int.parse(quantityCtrl.text))) {
                      final itemsprov =
                          Provider.of<ItemsProvider>(context, listen: false);
                      final bomprov =
                          Provider.of<BOMProvider>(context, listen: false);
                      final prodprov = Provider.of<ProductionProvider>(context,
                          listen: false);
                      //this is for the item produced
                      final items = itemsprov.allItems;
                      final finalQuantityI = items.indexWhere(
                          (element) => element.itemName == widget.bomName);
                      final finalItemProduced = items[finalQuantityI];
                      final finalItemQuantity = finalItemProduced.itemQuantity;
                      final finalq =
                          finalItemQuantity! + int.parse(quantityCtrl.text);
                      //uptil here only to get final quantity of item produced
                      await itemsprov.makeProductionReductions(
                          combinedData,
                          int.parse(quantityCtrl.text),
                          DateTime.now().millisecondsSinceEpoch.toString());
                      itemsprov.makeProductionReductionsProvider(
                          combinedData,
                          int.parse(quantityCtrl.text),
                          DateTime.now().millisecondsSinceEpoch.toString());
                      await bomprov.addProductoinIDtoBOM(
                          DateTime.now().millisecondsSinceEpoch.toString(),
                          widget.bomName);
                      bomprov.addProductoinIDtoBOMProvider(
                          DateTime.now().millisecondsSinceEpoch.toString(),
                          widget.bomName);
                      ProductionModel prod = ProductionModel(
                          productionID:
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          dateTime: Timestamp.now(),
                          quantityofBOMProduced: int.parse(quantityCtrl.text),
                          nameofBOM: widget.bomName);
                      await prodprov.addProductiontoDB(prod);
                      prodprov.addProduction(prod);
                      await itemsprov.updateItemProduced(
                          widget.bomName, finalq);
                      itemsprov.updateItemProducedinProv(
                          widget.bomName, finalq);
                    }
                    // Set _isProcessing to false when done
                    setState(() {
                      _isProcessing = false;
                    });
                    // Show success message or navigate to another screen
                    _showSuccessDialog();
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        _isProcessing = false;
                      });
                    }
                    // Handle error
                    print('Error: $e');
                  }

                  // show an animation
                  // create production if possible
                  //
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: blue,
                    surfaceTintColor: blue,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  'Produce BOM',
                  style: TextStyle(color: w),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Add Production',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset('lib/icons/close.svg'))
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextField(
                        decoration: getInputDecoration(
                            hint: 'Product Name', errorColor: r),
                        controller: TextEditingController(text: widget.bomName),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        decoration: getInputDecoration(
                                hint: 'Total unit to be Produce', errorColor: r)
                            .copyWith(
                                suffix: GestureDetector(
                          child: Text(
                            'Done',
                            style: TextStyle(
                                color: blue, fontWeight: FontWeight.w400),
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                        )),
                        controller: quantityCtrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      StockDetails(
                        cd: combinedData,
                        quantityofProduction: quantityCtrl.text.isEmpty
                            ? 0
                            : int.parse(quantityCtrl.text),
                        possibility: checkAvailability(
                            combinedData,
                            quantityCtrl.text.isEmpty
                                ? 0
                                : int.parse(quantityCtrl.text)),
                      )
                    ],
                  ),
                ),
              ),
            )),
        if (_isProcessing)
          ModalBarrier(
            semanticsOnTapHint: 'Processing',
            dismissible: false,
            color: b.withOpacity(0.12),
          ),
        if (_isProcessing)
          Center(
            child: CircularProgressIndicator(
              color: blue,
              strokeWidth: 2,
            ),
          )
      ],
    );
  }
}

class StockDetails extends StatelessWidget {
  const StockDetails(
      {super.key,
      required this.cd,
      required this.quantityofProduction,
      required this.possibility});
  final List<CombinedItem> cd;
  final int quantityofProduction;
  final bool possibility;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: w,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'lib/icons/info.svg',
                      height: 12,
                      width: 12,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    quantityofProduction == 0
                        ? const Text('Enter Quantity to check')
                        : Text(possibility
                            ? 'Stock quantities are sufficient.'
                            : 'Stock quantities are insufficient!'),
                    const Spacer(),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: quantityofProduction == 0
                          ? blue
                          : possibility
                              ? gn
                              : r,
                      child: quantityofProduction == 0
                          ? const Icon(
                              LineIcons.questionCircle,
                            )
                          : possibility
                              ? const Icon(LineIcons.checkCircle)
                              : const Icon(LineIcons.exclamationCircle),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: cd.length,
                          itemBuilder: (context, index) {
                            final bq = cd[index].bomQuantity;
                            final iq = cd[index].itemQuantity ?? 0;
                            final Color c =
                                bq * quantityofProduction > iq ? r : gn;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: w,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: w,
                                            border: Border.all(
                                                width: 1, color: b32)),
                                                child: const Icon(LineIcons.box),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cd[index].itemName,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'PPU: $bq',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: b.withOpacity(0.5)),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'SIH: $iq',
                                                style: TextStyle(
                                                    fontSize: 10, color: c),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool checkAvailability(List<CombinedItem> cd, int qop) {
  bool ret = true;
  for (final i in cd) {
    if (qop == 0) {
      ret = false;
      break;
    } else if (i.bomQuantity * qop > i.itemQuantity!) {
      ret = false;
      break;
    }
  }
  return ret;
}
