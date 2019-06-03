import 'package:faxina/services/auth.service.dart';
import "package:rxdart/rxdart.dart";

class AuthBloc {
  BehaviorSubject<FirebaseUser> _currentUser = BehaviorSubject<FirebaseUser>();
  Stream<FirebaseUser> get currentUser => _currentUser.stream;

  final AuthService _service = AuthService();

  Future signIn() async {
    await _service.signInWithGoogle();
    var user = await _service.firebaseUser;
    _currentUser.add(user);
  }

  void dispose() {
    _currentUser.close();
  }
}