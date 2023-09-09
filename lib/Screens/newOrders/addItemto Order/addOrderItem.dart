import 'package:ashwani/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants.dart';
import '../../../items/addItems.dart';

class AddOrderItem extends StatefulWidget {
  const AddOrderItem({super.key});

  @override
  State<AddOrderItem> createState() => _AddOrderItemState();
}

class _AddOrderItemState extends State<AddOrderItem> {
  @override
  Widget build(BuildContext context) {
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
            TextFormField(
              validator: validateName,
              cursorColor: blue,
              cursorWidth: 1,
              textInputAction: TextInputAction.next,
              decoration:
                  getInputDecoration(hint: 'Item Name', errorColor: Colors.red)
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
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              validator: validateOrderNo,
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
            )
          ],
        ),
      ),
    );
  }
}
