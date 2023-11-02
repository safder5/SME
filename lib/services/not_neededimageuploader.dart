import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



  uploadImage(String itemname) async {
  final fauth = FirebaseAuth.instance.currentUser;
  String? uid = fauth!.email;
  final firebaseStorage = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  //Check Permissions

  var permissionStatus = await Permission.storage.status;
  if (permissionStatus.isDenied) {
    await Permission.storage.request();
  }

  if (permissionStatus.isGranted) {
    //Select Image
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    if (image.path.isNotEmpty) {
      //Upload to Firebase
      var snapshot = await firebaseStorage
          .ref()
          .child('$uid/$itemname')
          .putFile(file)
          .whenComplete(() => null);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      final imageUrl = downloadUrl;
      return imageUrl;
      //  print('Uploaded $imageUrl');
      // return imageUrl;
    } else {
      print('No Image Path Received');
    }
  } else {
    print('Permission not granted. Try Again with permission access');
  }
}
