import 'dart:io';
import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/Utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final int qfs = 0; //quantity for sale orders
  final int qfp = 0; // quantity from purchase orders
  TextEditingController itemQuantityCtrl = TextEditingController();

  // Uint8List? _image;

  File? imageFile;

  void selectedImage() async {
    try {
      File imageF = await pickImage(
        ImageSource.gallery,
      );
      // print(imageF);
      // setState(() {
      //   _image = img;
      //   // imageFile!.writeAsBytesSync(img);
      // });
      setState(() {
        imageFile = imageF;
      });
    } catch (e) {
      print(e);
    }
  }

  //put on pause because of server response error which isnt resolved yet

  uploadImageAndUrl() async {
    print(_auth!.email);
    String url = (imageFile!.path);

    try {
      final Reference ref = _storage.ref().child('images/$url.png');

      final UploadTask uploadTask = ref.putFile(imageFile!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      url = await snapshot.ref.getDownloadURL();
      print(url);
    } catch (e) {
      print('Error uploading image : $e');
    }
    return url;
  }

  String itemName = '';
  String sIh = '';
  String imgUrl = '';
  bool ra = false;
  List<String>? measuringUnit = [
    'ml',
    'kg',
    'tonnes',
    'litres',
  ];
  String? mu;
  Image? image;

  // Future<PermissionStatus> requestPhotosPermission() async {
  //   return await Permission.photos.request();
  // }

  @override
  void initState() {
    super.initState();
    // requestPhotosPermission();
  }

  @override
  Widget build(BuildContext context) {
    final itemProviderforAddingItem = Provider.of<ItemsProvider>(context);
    return Scaffold(
      backgroundColor: w,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            CollectionReference collRef = _fs
                .collection('UserData')
                .doc('${_auth!.email}')
                .collection('Items');

            //submit everything after validation is processed
            //         imageFile!.writeAsBytesSync(_image);
            //         Reference ref =
            //     _storage.ref().child('images/${_auth!.email}/items/$itemName');
            //     UploadTask uploadTask = ref.putFile(imageFile!);
            // await uploadTask.whenComplete(() async {
            //   imgUrl = await ref.getDownloadURL();
            // });

            // imgUrl = await uploadImageAndUrl();
            ItemTrackingModel itm = ItemTrackingModel(
                orderID: _auth?.email,
                quantity: int.parse(itemQuantityCtrl.text),
                reason: 'By User');
            Item item = Item(
                imageURL: imgUrl,
                itemName: itemName,
                quantityPurchase: qfp,
                quantitySales: qfs,
                itemQuantity: int.parse(itemQuantityCtrl.text),
                itemTracks: [itm]);

            await itemProviderforAddingItem.addItemtoFB(item, collRef);
            itemProviderforAddingItem.addInvItemtoProvider(item, itm);
            if (!context.mounted) return;
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
              'Add Item',
              style: TextStyle(
                color: w,
              ),
              textScaleFactor: 1.2,
            )),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(LineIcons.angleLeft)),
                  const SizedBox(width: 10),
                  const Text('Add Item'),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        selectedImage();
                        // UploadImage(itemName);
                        // setState(() {
                        //   // imgUrl = imageUrl as String?;
                        // });
                        //upload image
                      },
                      child:  Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: t,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: blue)),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.plus,
                              size: 12,
                            ),
                            Text(
                              'Upload Image',
                              style: TextStyle(fontSize: 8),
                            )
                          ],
                        ),
                      ),
                            )),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) => itemName = value,
                decoration:
                    getInputDecoration(hint: 'Item Name', errorColor: r),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: itemQuantityCtrl,
                onChanged: (value) => sIh = value,
                decoration: getInputDecoration(
                    hint: 'Stock  In Hand (SIH)', errorColor: r),
              ),
              const SizedBox(
                height: 24,
              ),
              //returnable toggle
              const SizedBox(
                height: 24,
              ),
              //measuring unit selector
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
