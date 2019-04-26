import 'package:faxina/services/auth.service.dart';
import "package:rxdart/rxdart.dart";

class AuthBloc {
  BehaviorSubject<FirebaseUser> _currentUser = BehaviorSubject<FirebaseUser>();
  Stream<FirebaseUser> get currentUser => _currentUser.stream;

  final AuthService _service = AuthService();

  signIn() {
    _service.signInWithGoogle().then((loggedUser) async {
      _currentUser.add(await _service.onAuthStateChanged.first);
    });

  }

  void dispose() {
    _currentUser.close();
  }
}