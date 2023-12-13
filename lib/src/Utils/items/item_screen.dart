import 'dart:io';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Models/iq_list.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.item});
  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  List<bool> isSelected = [true, false];
  List<String> toggleButtons = [
    ('Details'),
    ('Transactions'),
  ];
  late String imgUrl;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  //  late ImageProvider imageProvider;
  Future<void> _checkPermission(ImageSource source) async {
    PermissionStatus status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        // Handle denied permissions
        print('Permission denied');
        return;
      }
    }
    await _getImage(source);
  }

  void showOptions() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: w,
        content: Column(
          children: [
             Text('Change Image ',style: TextStyle(color: b,),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      _checkPermission(ImageSource.camera);
                    },
                    child: const Text('Camera')),
                OutlinedButton(
                    onPressed: () {
                      _checkPermission(ImageSource.gallery);
                    },
                    child: const Text('Gallery'))
              ],
            ),
          ],
        )));
  }

  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        setState(() {
          imageFile = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImageAndUrl() async {
    if (imageFile != null) {
      String url = (imageFile!.path);

      try {
        final Reference ref = firebaseStorage.ref().child('images/$url.png');

        final UploadTask uploadTask = ref.putFile(imageFile!);

        final TaskSnapshot snapshot = await uploadTask
            .whenComplete(() async => {imgUrl = await ref.getDownloadURL()});

        url = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image : $e');
      }
    }
  }
  // Future<void> updateUrl(){

  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (_, prov, __) {
      final items = prov.allItems;
      final item = items
          .firstWhere((element) => element.itemName == widget.item.itemName);
      return Scaffold(
        backgroundColor: w,
        // not in scroll view dumbass
        body: Column(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height / 3,
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
                            'Item Details',
                            style: TextStyle(color: w, fontSize: 14),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: TextStyle(
                                      color: w, fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'SIH: ${item.itemQuantity} ${item.unitType}',
                                  style: TextStyle(
                                      color: w, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onLongPress: () {
                                // add image
                                showOptions();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: w,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                width: 100,
                                child: widget.item.imageURL == ''
                                    ? const Image(
                                        image: AssetImage(
                                            'lib/images/logoashapp.png'))
                                    : Image.network(
                                        widget.item.imageURL!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  )),
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                _showDialog(context, item.itemName);
                              },
                              child: Text(
                                'Stock Adjust',
                                style: TextStyle(color: w),
                              )),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.66,
              color: w,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var i = 0; i < isSelected.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              for (var buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == i) {
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                                color:
                                    isSelected[i] ? blue : b.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              toggleButtons[i],
                              style: TextStyle(
                                  color: isSelected[i] ? w : b,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            )),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected[0])
              ItemDetails(
                item: item,
              ),
            if (isSelected[1])
              ItemTransactionHistory(
                item: item,
              ),
          ],
        ),
      );
    });
  }
}

Future<void> _showDialog(BuildContext context, String itemName) async {
  final prov = Provider.of<ItemsProvider>(context, listen: false);
  final item =
      prov.allItems.firstWhere((element) => element.itemName == itemName);
  final sih = item.itemQuantity;
  showDialog(
      context: context,
      builder: ((context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          surfaceTintColor: w,
          backgroundColor: w,
          title: Text('Adjust In Hand Stock Quantity of $itemName by value?'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController,
            decoration: getInputDecoration(
                hint: 'Increase sIh quantity by ', errorColor: r),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      //save quantity and update
                      final int q =
                          int.parse(quantityController.text) + (sih ?? 0);
                      int tQ = int.parse(quantityController.text);
                      await prov.stockAdjustinFB(q, itemName, now, tQ);
                      prov.stockAdjustinProvider(q, itemName, now, tQ);
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: blue),
                    )),
              ],
            )
          ],
        );
      }));
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                            item.itemQuantity.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text('Total stock',
                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),)
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.quantitySales.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Already Sold',
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (item.itemQuantity! - item.quantitySales!)
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Available for sale',
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTransactionHistory extends StatelessWidget {
  const ItemTransactionHistory({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    String text = '';
    Color c = Colors.white;
    return Expanded(
      child: ListView.builder(
          // reverse: true,
          // physics: controllScroll,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: item.itemTracks!.length,
          itemBuilder: (context, index) {
            final itemTrack = item.itemTracks![index];
            if (itemTrack.reason == 'so') {
              text = 'Sales Order';
              c = gn;
            } else if (itemTrack.reason == 'po') {
              text = 'Purchase Order';
              c = blue;
            } else if (itemTrack.reason == 'u') {
              text = 'By User';
              c = b;
            } else if (itemTrack.reason == 'Sales Return') {
              text = 'Sales Return';
              c = const Color(colorPrimary);
            } else if (itemTrack.reason == 'Stock Adjustment') {
              text = "Stock Adjustment";
              c = blue;
            } else {
              text = 'Waste';
              c = r;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: f7, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemTrack.orderID.toString(),style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            text,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        itemTrack.quantity.toString(),
                        style: TextStyle(color: c, fontWeight: FontWeight.w300,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
