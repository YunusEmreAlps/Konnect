// Dart imports:
import 'dart:io';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart' as random;

Future<String> uploadAudio(String _mPath) async {
  File file = File(_mPath);
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Reference reference =
      firebaseStorage.ref().child("rec/" + randomString(10) + '.aac');

  UploadTask uploadTask = reference.putFile(file);

  var dowurl;

  await uploadTask
      .whenComplete(() async => dowurl = await reference.getDownloadURL());
  var url = dowurl.toString();

  return url;
}

String randomString(int length) {
  return random.randomNumeric(length);
}
