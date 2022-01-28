// ignore_for_file: unused_local_variable, avoid_print

import 'dart:html';
import 'dart:typed_data';

import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../feed/feed.dart';

class Connect extends StatefulWidget {
  static var routeName = '/connect';

  const Connect({Key key}) : super(key: key);

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  DropzoneViewController controller;
  TextEditingController controllerName = TextEditingController();
  bool highlighted = false,
      errorEnterName = false,
      errorEnterNameLenght = false;
  String photo;
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    if (FirebaseAuth.instance.currentUser.uid != null) {
      CollectionReference refU = FirebaseFirestore.instance.collection("users");
      refU.doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
        if (value.data() != null) {
          Navigator.of(context).pushReplacementNamed(Feed.routeName);
        }
      });
    }
  }

  @override
  void dispose() {
    controllerName?.dispose();
    super.dispose();
  }

  upload() async {
    String uidUser = FirebaseAuth.instance.currentUser.uid;
    String time = DateTime.now().toUtc().toString();
    final String uid = const Uuid().v1();
    InputElement inputElement = FileUploadInputElement()..accept = 'image/*';
    inputElement.click();
    inputElement.onChange.listen((event) async {
      final file = inputElement.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      var state = Provider.of<CloudFirestore>(context, listen: false);
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        Uint8List file = result.files.first.bytes;
        var snapshot = await fs
            .ref()
            .child('files')
            .child('avatars')
            .child(uid)
            .putData(file);
        await snapshot.ref.getDownloadURL().then((value) {
          setState(() {
            photo = value.toString();
          });
        });
      } else {
        print('No Path Received');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            loginAppBar(context),
            Container(
              margin: const EdgeInsets.only(top: 120),
              width: 500,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 38, color: Colors.white70),
                    ),
                  ),
                  const Text(
                    'Finish registering your account. To do this, you need to upload your photo, and enter your name and username.',
                    style: TextStyle(fontSize: 12, color: Colors.white30),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => upload(),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: highlighted
                                        ? const Color.fromRGBO(69, 178, 107, 1)
                                        : const Color.fromRGBO(
                                            119, 126, 144, 1)),
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    DropzoneView(
                                      operation: DragOperation.copy,
                                      cursor: CursorType.pointer,
                                      onCreated: (ctrl) => controller = ctrl,
                                      onHover: () {
                                        setState(() => highlighted = true);
                                      },
                                      onLeave: () {
                                        setState(() => highlighted = false);
                                      },
                                      onDrop: (ev) async {
                                        var state = Provider.of<CloudFirestore>(
                                            context,
                                            listen: false);
                                        final String uid = const Uuid().v1();
                                        setState(() {
                                          highlighted = false;
                                        });
                                        final bytes =
                                            await controller.getFileData(ev);
                                        var snapshot = await fs
                                            .ref()
                                            .child('files')
                                            .child('avatars')
                                            .child(uid)
                                            .putData(bytes);
                                        await snapshot.ref
                                            .getDownloadURL()
                                            .then((value) {
                                          setState(() {
                                            photo = value.toString();
                                          });
                                        });
                                      },
                                      onDropMultiple: (ev) async {
                                        print('Zone 1 drop multiple: $ev');
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
                            Flexible(
                              flex: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  errorEnterNameLenght
                                      ? Text(
                                          'Name must be six letters',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.red.shade300),
                                        )
                                      : errorEnterName
                                          ? Text(
                                              'Please enter your name',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red.shade300),
                                            )
                                          : const Text(
                                              'By registering with us, you automatically agree to our User Terms, as well as the rules of the site',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white30),
                                            ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: TextField(
                                          controller: controllerName,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14)),
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    53, 57, 69, 0.7),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14)),
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    53, 57, 69, 1),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14)),
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    53, 57, 69, 0.7),
                                              ),
                                            ),
                                            isCollapsed: true,
                                            hintText: 'Enter your name',
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  119, 126, 144, 1),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 14,
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  119, 126, 144, 1)),
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) {
                                            setState(() {
                                              errorEnterName = false;
                                              errorEnterNameLenght = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 40,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromRGBO(
                                                              69, 178, 107, 1)),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  )),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 25))),
                                              child: const Text(
                                                'Continue',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                print(
                                                    controllerName.text.length);
                                                var state =
                                                    Provider.of<CloudFirestore>(
                                                        context,
                                                        listen: false);
                                                // ignore: prefer_is_empty
                                                if (controllerName
                                                        .text.length >=
                                                    1) {
                                                  if (controllerName
                                                          .text.length >=
                                                      5) {
                                                    if (photo != null &&
                                                        photo != '') {
                                                      state.createNewUser(
                                                          context,
                                                          controllerName.text
                                                              .trim(),
                                                          photo: photo);
                                                    } else {
                                                      state.createNewUser(
                                                          context,
                                                          controllerName.text
                                                              .trim(),
                                                          photo: null);
                                                    }
                                                  } else {
                                                    setState(() {
                                                      errorEnterNameLenght =
                                                          true;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    errorEnterName = true;
                                                  });
                                                }
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
