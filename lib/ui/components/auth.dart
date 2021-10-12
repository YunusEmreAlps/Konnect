// Package imports:
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;
String uid;
auth.User newUser;
auth.User userMain;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final auth.UserCredential authResult =
      await _auth.signInWithCredential(credential);

  final auth.User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final auth.User currentUser = _auth.currentUser;

    assert(currentUser.uid == user.uid);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    print('signInWithGoogle succeeded: $user');

    name = user.displayName;
    email = user.email;
    uid = user.uid;

    imageUrl = user.photoURL;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    newUser = user;

    return '$user';
  }
  return null;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  _auth.signOut();
}

Future<void> getCurrentUser() async {
  //For already logged in users
  userMain = _auth.currentUser;
  if (userMain != null) {
    newUser = userMain;
    name = userMain.displayName;
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    email = userMain.email;
    uid = userMain.uid;
    imageUrl = userMain.photoURL;
  }
}
