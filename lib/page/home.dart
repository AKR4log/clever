// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/enum/enum.dart';
import 'package:clever/utils/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  static var routeName = '/home';
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller;
  DropzoneViewController controllerDrop;
  List listCategory = [];
  List selecteList = [];
  bool upload = false, highlighted = false;
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  StatefulBuilder mdUpload() {
    return StatefulBuilder(builder: (context, setDialogState) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
        child: Container(
          width: 685,
          padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upload
                  ? SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Please wait while checking your code',
                            style: TextStyle(
                                color: Color.fromRGBO(16, 164, 120, 0.45),
                                fontSize: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(16, 164, 120, 0.45)),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const Text(
                'Upload file',
                style: TextStyle(fontSize: 28, color: Colors.white60),
              ),
              const Text(
                'Select or drag the file you want to use in your post.',
                style: TextStyle(fontSize: 16, color: Colors.white38),
              ),
              GestureDetector(
                // onTap: () => upload(),
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: highlighted
                          ? const Color.fromRGBO(69, 178, 107, 1)
                          : const Color.fromRGBO(119, 126, 144, 1)),
                  height: 300,
                  width: 600,
                  child: Stack(
                    children: [
                      DropzoneView(
                        operation: DragOperation.copy,
                        cursor: CursorType.pointer,
                        onCreated: (ctrl) => controllerDrop = ctrl,
                        onHover: () {
                          setState(() => highlighted = true);
                        },
                        onLeave: () {
                          setState(() => highlighted = false);
                        },
                        onDrop: (ev) async {
                          setState(() {
                            highlighted = false;
                          });
                          final bytes = await controllerDrop.getFileData(ev);
                          print(bytes);
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.file_upload_outlined,
                          size: 28,
                          color: Colors.white60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // upload() async {
  //   String uidUser = FirebaseAuth.instance.currentUser.uid;
  //   String time = DateTime.now().toUtc().toString();
  //   final String uid = const Uuid().v1();
  //   InputElement inputElement = FileUploadInputElement()..accept = 'image/*';
  //   inputElement.click();
  //   inputElement.onChange.listen((event) async {
  //     final file = inputElement.files.first;
  //     final reader = FileReader();
  //     reader.readAsDataUrl(file);
  //   FilePickerResult result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     Uint8List file = result.files.first.bytes;
  //     var snapshot = await fs.ref().child('gifs').child(uid).putData(file);
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     CollectionReference ref = FirebaseFirestore.instance.collection('doc');
  //     ref.doc(uid).set({
  //       'animated': true,
  //       'author': uidUser,
  //       'development': time,
  //       'state': 'active',
  //       'img': downloadUrl
  //     }).whenComplete(() => ref
  //         .doc(uid)
  //         .collection('models')
  //         .doc('info_model')
  //         .set({'category': selecteList}).whenComplete(() =>
  //             Navigator.of(context).pushReplacementNamed(Feed.routeName)));
  //   }

  //   // if (file.type == 'image/gif') {
  //   //   reader.onLoadEnd.listen((event) async {
  //   // var snapshot =
  //   //     await fs.ref().child('gifs').child(uid).putData();
  //   // String downloadUrl = await snapshot.ref.getDownloadURL();
  //   // setState(() {
  //   //   imgUrl = downloadUrl;
  //   // });
  //   // CollectionReference ref =
  //   //     FirebaseFirestore.instance.collection('doc');
  //   // ref.doc(uid).set({
  //   //   'animated': true,
  //   //   'author': uidUser,
  //   //   'development': time,
  //   //   'state': 'active',
  //   //   'img': imgUrl
  //   // }).whenComplete(() => ref
  //   //     .doc(uid)
  //   //     .collection('models')
  //   //     .doc('info_model')
  //   //     .set({'category': selecteList}).whenComplete(() =>
  //   //         Navigator.of(context).pushReplacementNamed(Feed.routeName)));
  //   //   });
  //   // }
  //   // else if (file.type == 'image/png') {
  //   //   reader.onLoadEnd.listen((event) async {
  //   //     var snapshot = await fs.ref().child('img').child(uid).putBlob(file);
  //   //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //   //     setState(() {
  //   //       imgUrl = downloadUrl;
  //   //     });
  //   //     CollectionReference ref =
  //   //         FirebaseFirestore.instance.collection('files');
  //   //     ref.doc(uid).set({
  //   //       'animated': false,
  //   //       'category': selecteList,
  //   //       'enabled': true,
  //   //       'url': 'img/$uid'
  //   //     });
  //   //   });
  //   // } else if (file.type == 'image/jpg') {
  //   //   reader.onLoadEnd.listen((event) async {
  //   //     var snapshot = await fs.ref().child('img').child(uid).putBlob(file);
  //   //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //   //     setState(() {
  //   //       imgUrl = downloadUrl;
  //   //     });
  //   //     CollectionReference ref =
  //   //         FirebaseFirestore.instance.collection('files');
  //   //     ref.doc(uid).set({
  //   //       'animated': false,
  //   //       'category': selecteList,
  //   //       'enabled': true,
  //   //       'url': 'img/$uid'
  //   //     });
  //   //   });
  //   // }
  //   // });
  // }

  lItem(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => Container(
              width: 50,
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InputChip(
                onSelected: (val) {
                  selecteList.remove(doc['name']['en']);
                  selecteList.add(doc['name']['en'].toString().toLowerCase());
                },
                label: Text(doc['name']['en']),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
      body: SingleChildScrollView(
        // child: SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Center(
        //         child: SizedBox(
        //           height: 200,
        // child: StreamBuilder<QuerySnapshot>(
        //     stream: FirebaseFirestore.instance
        //         .collection('categories')
        //         .snapshots(),
        //     builder: (BuildContext context,
        //         AsyncSnapshot<QuerySnapshot> snapshot) {
        //       if (!snapshot.hasData) {
        //         return const Text('There is no expense');
        //       }
        //       return GridView(
        //           physics: const NeverScrollableScrollPhysics(),
        //           gridDelegate:
        //               SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: snapshot.data.docs.length,
        //             crossAxisSpacing: 1.0,
        //             mainAxisSpacing: 1.0,
        //           ),
        //           children: lItem(snapshot));
        //     }),
        //         ),
        //       ),
        //       TextButton(
        //           onPressed: () {
        //             if (selecteList.isNotEmpty) {
        //               print(selecteList);
        //               upload();
        //             } else {
        //               showDialog<void>(
        //                   context: context, builder: (context) => dialog);
        //             }
        //           },
        //           child: const Text('Upload')),
        //     ],
        //   ),
        // ),
        child: Column(
          children: [
            mainAppBar(context, controller),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 180),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create, explore, & collect digital art.',
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(205, 212, 228, 1)),
                  ),
                  const Text(
                    'The new creative economy.',
                    style: TextStyle(
                        fontSize: 40, color: Color.fromRGBO(252, 252, 253, 1)),
                  ),
                  TextButton(
                    // onPressed: () => showDialog<void>(
                    //     context: context, builder: (context) => upload),
                    onPressed: () {},
                    child: const Text(
                      'Start your search',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(252, 252, 253, 1)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
