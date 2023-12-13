import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in process
        print('User canceled Google Sign-In.');
        return null; // Return null to indicate cancellation
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }
  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("Google user signed out");
  }
}
