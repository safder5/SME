import 'dart:io';
import 'package:ashwani/constants.dart';
import 'package:ashwani/landingbypass.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/Utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      final Reference ref = _storage.ref().child('images/${url}.png');

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
    // TODO: implement initState
    super.initState();
    // requestPhotosPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            //submit everything after validation is processed
            //         imageFile!.writeAsBytesSync(_image);
            //         Reference ref =
            //     _storage.ref().child('images/${_auth!.email}/items/$itemName');
            //     UploadTask uploadTask = ref.putFile(imageFile!);
            // await uploadTask.whenComplete(() async {
            //   imgUrl = await ref.getDownloadURL();
            // });

            // imgUrl = await uploadImageAndUrl();
            await _fs
                .collection('UserData')
                .doc('${_auth!.email}')
                .collection('Items')
                .doc(itemName)
                .set({'item_name': itemName, 'sIh': sIh, 'imageUrl': imgUrl});

            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LandingBypass()));
            });
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
                      child: imageFile != null
                          ? Flexible(
                              child: CircleAvatar(
                                maxRadius: 40,
                                backgroundColor: t,
                                child: Expanded(
                                    child: Image(fit: BoxFit.contain,image: FileImage(imageFile!))),
                              ),
                            )
                          : Flexible(
                            child: Container(height: 90,width: 90,decoration: BoxDecoration(color: t,borderRadius: BorderRadius.circular(5),border: Border.all(color: blue)),child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Icon(LineIcons.plus,size: 12,),
                              Text('Upload Image',style: TextStyle(fontSize: 8),)
                            ],),),)
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
