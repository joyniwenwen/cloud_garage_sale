import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'dart:io';

class Storage {
  Future<String> uploadFile(File file) async {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('joyniwenwen/hyper_garage_sale/${Path.basename(file.path)}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
    return uploadTask.then((res) => res.ref.getDownloadURL());
  }
}