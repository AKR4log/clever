// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:path/path.dart' as Path;
// import 'package:mime_type/mime_type.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  static var routeName = '/home';
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String imgUrl;
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  upload() async {
    InputElement inputElement = FileUploadInputElement()..accept = 'image/*';
    inputElement.click();
    inputElement.onChange.listen((event) {
      final file = inputElement.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot =
            await fs.ref().child('gifs').child(const Uuid().v1()).putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imgUrl = downloadUrl;
        });
        String uid = const Uuid().v1();
        CollectionReference ref =
            FirebaseFirestore.instance.collection("files");
        ref.doc(uid).set({
          "anumated": true,
          "category": ['abstract', 'fun'],
          "enabled": true,
          "url": 'gifs/uid.gif'
        });
      });
    });
    // var mediaData = await ImagePickerWeb.getImageInfo;
    // String mimeType = mime(Path.basename(mediaData.fileName));
    // html.File mediaFile =
    //     html.File(mediaData.data, mediaData.fileName, {'type': mimeType});
    // if (mediaFile != null) {
    //   String randomName;
    //   randomName = const Uuid().v1();
    //   firebase_storage.Reference firebaseStorageRef = firebase_storage
    //       .FirebaseStorage.instance
    //       .ref()
    //       .child('application/$randomName.png');

    //   firebase_storage.UploadTask slideshowRefTask =
    //       firebaseStorageRef.putData(mediaData.data);

    //   slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
    //     if (snapshot.state == firebase_storage.TaskState.success) {
    //       firebaseStorageRef.getDownloadURL().then((snapshot) {
    //         setState(() {
    //           imgUrl = snapshot.toString();
    //         });
    //       });
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () => upload(), child: const Text('Upload'))
            ],
          ),
        ),
      ),
    );
  }
}
