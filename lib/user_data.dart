import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static final UserData _singleton = UserData._internal();
  late String userEmail;

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  Future<void> loadUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email!;
    } else {
      userEmail = '';
    }
  }
}
