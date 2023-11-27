import 'dart:io';
import 'dart:typed_data';
import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;
  final FirebaseStorage firebase_storage = FirebaseStorage.instance;
  final int qfs = 0; //quantity for sale orders
  final int qfp = 0; // quantity from purchase orders
  TextEditingController itemQuantityCtrl = TextEditingController();
  TextEditingController inCtrl = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  Item currentItem = Item(itemName: 'Example Item');

  final List<String> unitTypes = [
    'None',
    'Box',
    'cm',
    'dz',
    'ft',
    'in',
    'g',
    'kg',
    'm',
    'km',
    'lb',
    'mg',
    'ml',
    'pcs',
    'litre',
    '12',
    'b',
  ]; // Your list of options
  late String selectedOption = 'None';

  // Uint8List? _image;

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

  Future<void> _compressImage(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    Uint8List uint8List =
        Uint8List.fromList(imageBytes); // Convert List<int> to Uint8List
    Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
      uint8List,
      minHeight: 1920, // adjust as needed
      minWidth: 1080, // adjust as needed
      quality: 90, // adjust quality level (0 - 100)
    );
    await imageFile?.writeAsBytes(compressedBytes);

    // Now upload 'compressedBytes' to your storage (e.g., Firebase Storage)
    // Example:
    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images/compressed.jpg');
    // firebase_storage.UploadTask uploadTask = ref.putData(compressedBytes);
  }

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

  // Future<void> _handleSubmit() async {
  //   if (imageFile != null) {

  //     // Rename the file to avoid conflicts in Firebase Storage
  //     String fileName =
  //         '${inCtrl.text.trim().toString()}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child('${_auth!.email}/$fileName');

  //     Future uploadTask = ref.putFile(imageFile,
  //         firebase_storage.SettableMetadata(contentType: 'image/jpeg'));

  //     uploadTask.whenComplete(() async {
  //       String downloadURL = await ref.getDownloadURL();
  //       setState(() {
  //         currentItem.imageURL = downloadURL;
  //       });

  //       await FirebaseFirestore.instance
  //           .collection('items')
  //           .doc(currentItem.itemName)
  //           .set({
  //         'itemName': currentItem.itemName,
  //         'imageURL': downloadURL,
  //       });
  //     });
  //   }
  // }

  //put on pause because of server response error which isnt resolved yet

  Future<void> uploadImageAndUrl() async {
    if (imageFile != null) {
      String url = (imageFile!.path);

      try {
        final Reference ref = firebase_storage.ref().child('images/$url.png');

        final UploadTask uploadTask = ref.putFile(imageFile!);

        final TaskSnapshot snapshot = await uploadTask
            .whenComplete(() async => {imgUrl = await ref.getDownloadURL()});

        url = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image : $e');
      }
    }
  }

  String itemName = '';
  String imgUrl = '';
  String? mu;
  Image? image;
  bool isLoading = false;

  // Future<PermissionStatus> requestPhotosPermission() async {
  //   return await Permission.photos.request();
  // }
  void showOptions() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: w,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  _checkPermission(ImageSource.camera);
                },
                child: const Text('Camera')),
            TextButton(
                onPressed: () {
                  _checkPermission(ImageSource.gallery);
                },
                child: const Text('Gallery'))
          ],
        )));
  }

  @override
  void initState() {
    super.initState();
    // requestPhotosPermission();
  }

  @override
  Widget build(BuildContext context) {
    final itemProviderforAddingItem = Provider.of<ItemsProvider>(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: w,
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await uploadImageAndUrl();
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
                    orderID: _auth?.email, quantity: 0, reason: 'By User');
                Item item = Item(
                    imageURL: imgUrl,
                    unitType: selectedOption,
                    itemName: inCtrl.text.trim().toString(),
                    quantityPurchase: 0,
                    quantitySales: 0,
                    itemQuantity: 0,
                    itemTracks: [itm]);

                await itemProviderforAddingItem.addItemtoFB(item, collRef);
                itemProviderforAddingItem.addInvItemtoProvider(item, itm);
                setState(() {
                  isLoading = false;
                });
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
                            showOptions();
                            // selectedImage();
                            // UploadImage(itemName);
                            // setState(() {
                            //   // imgUrl = imageUrl as String?;
                            // });
                            //upload image
                          },
                          child: imageFile != null
                              ? Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: blue,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: t,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: blue)),
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      const SizedBox(
                        width: 10,
                      ),
                      imageFile != null
                          ? const Text('Tap image to change')
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: inCtrl,
                    onChanged: (value) => itemName = value,
                    decoration:
                        getInputDecoration(hint: 'Item Name', errorColor: r),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      const Text('Select Unit Type:'),
                      const SizedBox(
                        width: 12,
                      ),
                      // DropdownButton<String>(
                      //   value: selectedOption,
                      //   focusColor: blue,
                      //   dropdownColor: w,
                      //   onChanged: (String? newValue) {
                      //     if (newValue != null) {
                      //       // Update selected option when the value changes
                      //       setState(() {
                      //         selectedOption = newValue;
                      //       });
                      //     }
                      //   },
                      //   items: unitTypes
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value,style: TextStyle(

                      //             fontSize: 12,
                      //             color: b32),),
                      //     );
                      //   }).toList(),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      // _showOptionsModal(context);
                      //   },
                      //   child: Text(selectedOption),
                      // ),
                      TextButton(
                          onPressed: () {
                            _showOptionsModal(context);
                          },
                          child: Text(selectedOption,style: TextStyle(color: b),))
                    ],
                  ),
                  // TextFormField(
                  //   controller: itemQuantityCtrl,
                  //   onChanged: (value) => sIh = value,
                  //   decoration: getInputDecoration(
                  //       hint: 'Stock  In Hand (SIH)', errorColor: r),
                  // ),
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
        ),
        if (isLoading) const LoadingOverlay()
      ],
    );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Text('Select a Unit Type '),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildOptionTile('None', context),
                  _buildOptionTile('Box', context),
                  _buildOptionTile('cm', context),
                  _buildOptionTile('dz', context),
                  _buildOptionTile('ft', context),
                  _buildOptionTile('in', context),
                  _buildOptionTile('g', context),
                  _buildOptionTile('kg', context),
                  _buildOptionTile('m', context),
                  _buildOptionTile('km', context),
                  _buildOptionTile('lb', context),
                  _buildOptionTile('mg', context),
                  _buildOptionTile('ml', context),
                  _buildOptionTile('pcs', context),
                  _buildOptionTile('litre', context),
                  _buildOptionTile('12', context),
                  _buildOptionTile('b', context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectOption(String option) {
    // Update selected option
    setState(() {
      selectedOption = option;
    });

    // Perform any other actions based on the selected option
    print('Selected Option: $selectedOption');
  }

  Widget _buildOptionTile(String option, BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          selectedOption == option
              ? Stack(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          color: b10,
                          border: Border.all(width: 0.3, color: blue),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: blue, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(color: b10, shape: BoxShape.circle),
                ),
          const SizedBox(
            width: 10,
          ),
          Text(option),
        ],
      ),
      onTap: () {
        _selectOption(option);
        Navigator.pop(context);
      },
    );
  }
}

// _showAlertDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return ;
//       });
// }
