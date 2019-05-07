import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print("signed in " + user.displayName);
  }

  Stream<FirebaseUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged;
  Future<FirebaseUser> get firebaseUser => _firebaseAuth.onAuthStateChanged.first;
}