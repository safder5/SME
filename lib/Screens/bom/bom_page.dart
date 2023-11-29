import 'package:ashwani/Models/bom_model.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class BOMPage extends StatefulWidget {
  const BOMPage({super.key, required this.bom});
  final BOMmodel bom;

  @override
  State<BOMPage> createState() => _BOMPageState();
}

class _BOMPageState extends State<BOMPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      body: Column(
        children: [
          Container(
            color: blue,
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            LineIcons.angleLeft,
                            color: w,
                          )),
                      const SizedBox(width: 10),
                      Text(
                        'BOM',
                        style: TextStyle(color: w),
                        textScaleFactor: 1.2,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 11,
                                  width: 11,
                                  color: w,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.bom.productCode ?? 'Error',
                                  style: TextStyle(
                                      color: w, fontWeight: FontWeight.w500),
                                  textScaleFactor: 1.4,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Product Name: ${widget.bom.productName}',
                              style: TextStyle(
                                  color: w, fontWeight: FontWeight.w300),
                              textScaleFactor: 1,
                            ),
                            //  const SizedBox(
                            //   height: 5,
                            // ),
                            // Text(
                            //   'Creation Date: ${widget.bom.date}',
                            //   style: TextStyle(
                            //       color: w, fontWeight: FontWeight.w300),
                            //   textScaleFactor: 1,
                            // ),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset('lib/icons/attatchment.svg')
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Spacer(),
                ],
              ),
            )),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'BOM Items with Quantities',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: w,
            ),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: widget.bom.itemswithQuantities.length,
                        itemBuilder: ((context, index) {
                          final item = widget.bom.itemswithQuantities[index];
                          final ip = Provider.of<ItemsProvider>(context,
                              listen: false);
                          final p = ip.allItems.firstWhere(
                              (element) => element.itemName == item.itemname);
                          Color c = item.quantity < p.itemQuantity! ? gn : r;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                                          // border:
                                          //     Border.all(width: 1, color: b32)),
                                      ),
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
                                          item.itemname,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'PPU: ${item.quantity}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: b.withOpacity(0.5)),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'SIH: ${p.itemQuantity}',
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
                        }))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
