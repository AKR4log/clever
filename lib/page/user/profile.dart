// ignore_for_file: avoid_print, prefer_is_empty

import 'dart:html';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clever/page/feed/widgets/list_app.dart';
import 'package:clever/utils/mdls/app/app.dart';
import 'package:clever/utils/mdls/user/user.dart';
import 'package:clever/utils/service/database/database.dart';
import 'package:clever/utils/service/state/feed_state.dart';
import 'package:clever/utils/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  static var routeName = '/user';
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEditName = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerSearch = TextEditingController();
  DropzoneViewController controllerDrop;
  DropzoneViewController controllerEditDrop;

  String photo = '',
      nameFiles = '',
      nameFilesMime = '',
      pathPhoto = '',
      uidData,
      tempUid,
      filter;
  int posts = 0, followers = 0, following = 0;
  bool highlighted = false,
      upload = false,
      uploadEditPhoto = false,
      uploadComplite = false,
      errorUploadMime = false,
      errorName = false,
      errorEnterEditNameLenght = false,
      follow = false,
      listen = false;
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerEditName = TextEditingController();
    controllerSearch = TextEditingController();
    controllerDesc = TextEditingController();
  }

  @override
  void dispose() {
    controllerDesc?.dispose();
    controllerName?.dispose();
    controllerEditName?.dispose();
    controllerSearch?.dispose();
    super.dispose();
  }

  StatefulBuilder mdUpload() {
    return StatefulBuilder(builder: (context, setDialogState) {
      uploadFileFunc(dynamic event) async {
        setDialogState(() {
          uidData = const Uuid().v1();
          upload = true;
        });

        final mime = await controllerDrop.getFileMIME(event);
        final nameFile = await controllerDrop.getFilename(event);
        // final byte = await controllerDrop.getFileSize(event);
        // print('Size : ${byte / (1024 * 1024)}');

        final bytes = await controllerDrop.getFileData(event);
        if (mime == 'image/gif') {
          var snapshot =
              await fs.ref().child('gif').child(uidData).putData(bytes);
          await snapshot.ref.getDownloadURL().then((value) {
            setDialogState(() {
              nameFiles = nameFile;
              nameFilesMime = mime;
              photo = value.toString();
              uploadComplite = true;
              upload = false;
              pathPhoto = 'gif/$uidData';
            });
          });
        } else if (mime == 'image/png') {
          var snapshot =
              await fs.ref().child('png').child(uidData).putData(bytes);
          await snapshot.ref.getDownloadURL().then((value) {
            setDialogState(() {
              nameFiles = nameFile;
              nameFilesMime = mime;
              photo = value.toString();
              uploadComplite = true;
              upload = false;
              pathPhoto = 'png/$uidData';
            });
          });
        } else if (mime == 'image/jpeg') {
          var snapshot =
              await fs.ref().child('jpg').child(uidData).putData(bytes);
          await snapshot.ref.getDownloadURL().then((value) {
            setDialogState(() {
              nameFiles = nameFile;
              nameFilesMime = mime;
              photo = value.toString();
              uploadComplite = true;
              upload = false;
              pathPhoto = 'jpg/$uidData';
            });
          });
        } else if (mime != 'image/gif' &&
            mime == 'image/jpeg' &&
            mime == 'image/png') {
          setDialogState(() {
            errorUploadMime = true;
            upload = false;
          });
        }
      }

      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
        child: Container(
          width: 685,
          padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uploadComplite
                  ? TextButton(
                      child: const Text('Detele',
                          style: TextStyle(
                              color: Color.fromARGB(255, 223, 38, 25),
                              fontSize: 15)),
                      onPressed: () async {
                        if (uidData != null) {
                          if (nameFilesMime == 'image/gif') {
                            await fs
                                .ref()
                                .child('gif')
                                .child(uidData)
                                .delete()
                                .whenComplete(() {
                              setDialogState(() {
                                photo = null;
                                uploadComplite = false;
                              });
                              Navigator.pop(context, true);
                            });
                          } else if (nameFilesMime == 'image/png') {
                            await fs
                                .ref()
                                .child('png')
                                .child(uidData)
                                .delete()
                                .whenComplete(() {
                              setDialogState(() {
                                photo = null;
                                uploadComplite = false;
                              });
                              Navigator.pop(context, true);
                            });
                          } else if (nameFilesMime == 'image/jpeg') {
                            await fs
                                .ref()
                                .child('jpg')
                                .child(uidData)
                                .delete()
                                .whenComplete(() {
                              setDialogState(() {
                                photo = null;
                                uploadComplite = false;
                              });
                              Navigator.pop(context, true);
                            });
                          } else if (nameFilesMime != 'image/gif' &&
                              nameFilesMime == 'image/jpg' &&
                              nameFilesMime == 'image/png') {
                            setDialogState(() {
                              photo = null;
                              uploadComplite = false;
                            });
                            Navigator.pop(context, true);
                          }
                        }
                      },
                    )
                  : upload
                      ? SizedBox(
                          child: Row(
                            children: [
                              const Text(
                                'Loading your file, please wait',
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
              Text(
                uploadComplite ? 'Complete your post' : 'Upload file',
                style: const TextStyle(fontSize: 28, color: Colors.white60),
              ),
              Text(
                uploadComplite
                    ? 'Enter all the information about your post below'
                    : 'Select or drag the file you want to use in your post.',
                style: const TextStyle(fontSize: 16, color: Colors.white38),
              ),
              uploadComplite
                  ? Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          uploadComplite && photo != null && photo != ''
                              ? Container(
                                  margin: const EdgeInsets.only(right: 25),
                                  height: 75,
                                  width: 75,
                                  child: CachedNetworkImage(
                                    imageUrl: photo,
                                    cacheManager: DefaultCacheManager(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    placeholderFadeInDuration:
                                        const Duration(milliseconds: 500),
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : const SizedBox(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 135,
                                child: Text(
                                  nameFiles.toLowerCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                nameFilesMime,
                                style: const TextStyle(
                                  color: Color.fromRGBO(53, 57, 69, 0.85),
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        final events = await controllerDrop.pickFiles(
                            multiple: false,
                            mime: ['image/gif', 'image/png', 'image/jpeg']);
                        if (events.isEmpty) return;
                        uploadFileFunc(events.first);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 45),
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
                                setDialogState(() => highlighted = true);
                              },
                              onLeave: () {
                                setDialogState(() => highlighted = false);
                              },
                              onDrop: (ev) async {
                                final nameFile =
                                    await controllerDrop.getFilename(ev);
                                final nameMime =
                                    await controllerDrop.getFileMIME(ev);
                                setDialogState(() {
                                  uidData = const Uuid().v1();
                                  highlighted = false;
                                  upload = true;
                                });
                                final bytes =
                                    await controllerDrop.getFileData(ev);
                                if (nameMime == 'image/gif') {
                                  var snapshot = await fs
                                      .ref()
                                      .child('gif')
                                      .child(uidData)
                                      .putData(bytes);
                                  await snapshot.ref
                                      .getDownloadURL()
                                      .then((value) {
                                    setDialogState(() {
                                      nameFiles = nameFile;
                                      nameFilesMime = nameMime;
                                      photo = value.toString();
                                      uploadComplite = true;
                                      upload = false;
                                      pathPhoto = 'gif/$uidData';
                                    });
                                  });
                                } else if (nameMime == 'image/png') {
                                  var snapshot = await fs
                                      .ref()
                                      .child('png')
                                      .child(uidData)
                                      .putData(bytes);
                                  await snapshot.ref
                                      .getDownloadURL()
                                      .then((value) {
                                    setDialogState(() {
                                      nameFiles = nameFile;
                                      nameFilesMime = nameMime;
                                      photo = value.toString();
                                      uploadComplite = true;
                                      upload = false;
                                      pathPhoto = 'png/$uidData';
                                    });
                                  });
                                } else if (nameMime == 'image/jpeg') {
                                  var snapshot = await fs
                                      .ref()
                                      .child('jpg')
                                      .child(uidData)
                                      .putData(bytes);
                                  await snapshot.ref
                                      .getDownloadURL()
                                      .then((value) {
                                    setDialogState(() {
                                      nameFiles = nameFile;
                                      nameFilesMime = nameMime;
                                      photo = value.toString();
                                      uploadComplite = true;
                                      upload = false;
                                      pathPhoto = 'jpg/$uidData';
                                    });
                                  });
                                } else if (nameMime != 'image/gif' &&
                                    nameMime == 'image/jpeg' &&
                                    nameMime == 'image/png') {
                                  setDialogState(() {
                                    errorUploadMime = true;
                                    upload = false;
                                  });
                                }
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () async {
                                    final events = await controllerDrop
                                        .pickFiles(multiple: false, mime: [
                                      'image/gif',
                                      'image/png',
                                      'image/jpeg'
                                    ]);
                                    if (events.isEmpty) return;
                                    uploadFileFunc(events.first);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color:
                                              Color.fromRGBO(69, 178, 107, 1),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                    )),
                                  ),
                                  child: const Text('Select a file',
                                      style: TextStyle(color: Colors.white))),
                            )
                          ],
                        ),
                      ),
                    ),
              uploadComplite
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: TextField(
                                    controller: controllerName,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(53, 57, 69, 0.7),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Color.fromRGBO(53, 57, 69, 1),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(53, 57, 69, 0.7),
                                        ),
                                      ),
                                      isCollapsed: true,
                                      hintText: 'Enter the title of your post',
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(119, 126, 144, 1),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 14,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(119, 126, 144, 1)),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        errorName = false;
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('categories')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Text(
                                                'There is no expense');
                                          }

                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: DropdownButton(
                                              value: tempUid,
                                              dropdownColor:
                                                  const Color.fromRGBO(
                                                      20, 20, 22, 1),
                                              hint: const Text(
                                                'Please select a category',
                                                style: TextStyle(
                                                    color: Colors.white60),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
                                              underline: const SizedBox(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              items: snapshot.data.docs.map(
                                                  (DocumentSnapshot document) {
                                                return DropdownMenuItem<String>(
                                                    value: document.get('uid'),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                        document
                                                            .get('name')['en']
                                                            .toString(),
                                                      ),
                                                    ));
                                              }).toList(),
                                              onChanged: (value) {
                                                // tempList.forEach((element) {
                                                //   if (element != value) {
                                                //     tempList.add(value);
                                                //   } else if (element == value) {
                                                //     tempList.remove(value);
                                                //   }
                                                // });
                                                // if (tempList.isEmpty) {
                                                //   tempList.add(value);
                                                // }
                                                // print(tempList);
                                                setDialogState(() {
                                                  tempUid = value;
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: TextField(
                              controller: controllerDesc,
                              maxLines: 4,
                              minLines: 3,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(53, 57, 69, 0.7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(53, 57, 69, 1),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(53, 57, 69, 0.7),
                                  ),
                                ),
                                isCollapsed: true,
                                hintText: 'Enter a description for your post',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(119, 126, 144, 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 14,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  color: Color.fromRGBO(119, 126, 144, 1)),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: controllerName.text.length >= 5
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            var state =
                                                Provider.of<CloudFirestore>(
                                                    context,
                                                    listen: false);
                                            state.createNewPost(
                                                context,
                                                controllerName.text.trim(),
                                                photo,
                                                uidData,
                                                pathPhoto,
                                                tempUid,
                                                description:
                                                    controllerDesc.text.trim());
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromRGBO(
                                                        69, 178, 107, 1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            )),
                                          ),
                                          child: const Text('Upload',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ],
                                  )
                                : const Text(
                                    'Post title must be at least 5 characters',
                                    style: TextStyle(
                                        color: Color.fromRGBO(53, 57, 69, 0.7),
                                        fontSize: 16),
                                  ),
                          )
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        'To continue creating a post, you need to upload your file',
                        style: TextStyle(
                            color: Color.fromRGBO(53, 57, 69, 0.7),
                            fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    CloudFirestore state = Provider.of<CloudFirestore>(context, listen: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(data['uid'])
        .collection('files')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            posts = value.docs.length;
          });
        }
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(data['uid'])
        .collection('following')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            following = value.docs.length;
          });
        }
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(data['uid'])
        .collection('followers')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            followers = value.docs.length;
          });
        }
      }
    });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mainAppBarAU(context, controllerSearch,
                function: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => mdUpload())),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 22),
              width: double.infinity,
              child: StreamBuilder<UserData>(
                  stream: FeedState(uidUser: data['uid']).getUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data;

                      StatefulBuilder mdEdit() {
                        return StatefulBuilder(
                            builder: (context, setDialogState) {
                          uploadFileFunc(dynamic event) async {
                            setDialogState(() {
                              uploadEditPhoto = true;
                            });

                            final bytes =
                                await controllerEditDrop.getFileData(event);
                            final String uid = const Uuid().v1();

                            var snapshot = await fs
                                .ref()
                                .child('files')
                                .child('avatars')
                                .child(uid)
                                .putData(bytes);
                            await snapshot.ref.getDownloadURL().then((value) {
                              setDialogState(() {
                                photo = value.toString();
                                uploadEditPhoto = false;
                              });
                            });
                          }

                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor:
                                const Color.fromRGBO(20, 20, 22, 1),
                            child: Container(
                              width: 685,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 45, horizontal: 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              top: 25, bottom: 35),
                                          child: const Text(
                                            'Profile editing',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            uploadEditPhoto
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              55),
                                                      color: Colors.white38
                                                          .withOpacity(0.7),
                                                    ),
                                                    height: 100,
                                                    width: 100,
                                                    child: const Center(
                                                      child: SizedBox(
                                                        height: 25,
                                                        width: 25,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : photo != null && photo != ''
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: photo,
                                                          cacheManager:
                                                              DefaultCacheManager(),
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 100,
                                                            height: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          placeholderFadeInDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white38
                                                                    .withOpacity(
                                                                        0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          final events =
                                                              await controllerEditDrop
                                                                  .pickFiles(
                                                                      multiple:
                                                                          false,
                                                                      mime: [
                                                                'image/png',
                                                                'image/jpeg'
                                                              ]);
                                                          if (events.isEmpty)
                                                            return;
                                                          uploadFileFunc(
                                                              events.first);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      50),
                                                              color: highlighted
                                                                  ? const Color
                                                                          .fromRGBO(
                                                                      69,
                                                                      178,
                                                                      107,
                                                                      1)
                                                                  : const Color
                                                                          .fromRGBO(
                                                                      119,
                                                                      126,
                                                                      144,
                                                                      1)),
                                                          height: 100,
                                                          width: 100,
                                                          child: Stack(
                                                            children: [
                                                              DropzoneView(
                                                                operation:
                                                                    DragOperation
                                                                        .copy,
                                                                cursor:
                                                                    CursorType
                                                                        .pointer,
                                                                onCreated: (ctrl) =>
                                                                    controllerEditDrop =
                                                                        ctrl,
                                                                onHover: () {
                                                                  setDialogState(() =>
                                                                      highlighted =
                                                                          true);
                                                                },
                                                                onLeave: () {
                                                                  setDialogState(() =>
                                                                      highlighted =
                                                                          false);
                                                                },
                                                                onDrop:
                                                                    (ev) async {
                                                                  final String
                                                                      uid =
                                                                      const Uuid()
                                                                          .v1();
                                                                  setDialogState(
                                                                      () {
                                                                    highlighted =
                                                                        false;
                                                                    uploadEditPhoto =
                                                                        true;
                                                                  });
                                                                  final bytes =
                                                                      await controllerEditDrop
                                                                          .getFileData(
                                                                              ev);
                                                                  var snapshot = await fs
                                                                      .ref()
                                                                      .child(
                                                                          'files')
                                                                      .child(
                                                                          'avatars')
                                                                      .child(
                                                                          uid)
                                                                      .putData(
                                                                          bytes);
                                                                  await snapshot
                                                                      .ref
                                                                      .getDownloadURL()
                                                                      .then(
                                                                          (value) {
                                                                    setDialogState(
                                                                        () {
                                                                      photo = value
                                                                          .toString();
                                                                      uploadEditPhoto =
                                                                          false;
                                                                    });
                                                                  });
                                                                },
                                                                onDropMultiple:
                                                                    (ev) async {
                                                                  print(
                                                                      'Zone 1 drop multiple: $ev');
                                                                },
                                                              ),
                                                              const Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons
                                                                      .file_upload_outlined,
                                                                  size: 28,
                                                                  color: Colors
                                                                      .white60,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                            Flexible(
                                              flex: 10,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  errorEnterEditNameLenght
                                                      ? Text(
                                                          'The new name must be at least six characters',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.red
                                                                  .shade300),
                                                        )
                                                      : const Text(
                                                          'You can change your name as well as your avatar',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .white30),
                                                        ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Flex(
                                                    direction: Axis.horizontal,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        flex: 7,
                                                        child: TextField(
                                                          controller:
                                                              controllerEditName,
                                                          decoration:
                                                              const InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        53,
                                                                        57,
                                                                        69,
                                                                        0.7),
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        53,
                                                                        57,
                                                                        69,
                                                                        1),
                                                              ),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        53,
                                                                        57,
                                                                        69,
                                                                        0.7),
                                                              ),
                                                            ),
                                                            isCollapsed: true,
                                                            hintText:
                                                                'Write your new name',
                                                            hintStyle:
                                                                TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      119,
                                                                      126,
                                                                      144,
                                                                      1),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 15,
                                                              vertical: 14,
                                                            ),
                                                          ),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          style:
                                                              const TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          119,
                                                                          126,
                                                                          144,
                                                                          1)),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              errorEnterEditNameLenght =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Flexible(
                                                          flex: 3,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all(const Color
                                                                              .fromRGBO(
                                                                          69,
                                                                          178,
                                                                          107,
                                                                          1)),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(14),
                                                                      )),
                                                                      padding: MaterialStateProperty.all(const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              25))),
                                                              child: const Text(
                                                                'Continue',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                var state =
                                                                    Provider.of<
                                                                            CloudFirestore>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                if (controllerEditName
                                                                            .text
                                                                            .length >=
                                                                        1 &&
                                                                    controllerEditName
                                                                            .text
                                                                            .length >=
                                                                        5) {
                                                                  if (photo !=
                                                                          null &&
                                                                      photo !=
                                                                          '') {
                                                                    state.upadateDataUser(
                                                                        context,
                                                                        controllerEditName
                                                                            .text
                                                                            .trim(),
                                                                        photo);
                                                                  } else {
                                                                    state.upadateDataUser(
                                                                        context,
                                                                        controllerEditName
                                                                            .text
                                                                            .trim(),
                                                                        null);
                                                                  }
                                                                } else {
                                                                  if (photo !=
                                                                          null &&
                                                                      photo !=
                                                                          '') {
                                                                    state.upadateDataUser(
                                                                        context,
                                                                        null,
                                                                        photo);
                                                                  } else {
                                                                    setDialogState(
                                                                        () {
                                                                      errorEnterEditNameLenght =
                                                                          true;
                                                                    });
                                                                  }
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
                          );
                        });
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 71, vertical: 35),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 71),
                                  child: userData.photo != null &&
                                          userData.photo != ''
                                      ? CachedNetworkImage(
                                          imageUrl: userData.photo,
                                          cacheManager: DefaultCacheManager(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                            ),
                                          ),
                                          placeholderFadeInDuration:
                                              const Duration(milliseconds: 500),
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: Colors.white38
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : ClipRRect(
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    16, 184, 120, 0.45),
                                                borderRadius:
                                                    BorderRadius.circular(150)),
                                            child: Center(
                                              child: Text(
                                                  userData.name[0]
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          userData.name,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 35),
                                          child: userData.uid ==
                                                  FirebaseAuth
                                                      .instance.currentUser.uid
                                              ? TextButton(
                                                  onPressed: () => showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          mdEdit()),
                                                  child: Text('Edit profile'))
                                              : Row(
                                                  children: [
                                                    // Container(
                                                    //   margin: const EdgeInsets
                                                    //       .only(right: 15),
                                                    //   height: 45,
                                                    //   width: 45,
                                                    //   child: TextButton(
                                                    //       onPressed: () {
                                                    //         setState(() {
                                                    //           listen =
                                                    //               !listen;
                                                    //         });
                                                    //       },
                                                    //       style: ButtonStyle(
                                                    //         backgroundColor: MaterialStateProperty.all(listen
                                                    //             ? Colors
                                                    //                 .red[400]
                                                    //                 .withOpacity(
                                                    //                     0.15)
                                                    //             : const Color
                                                    //                     .fromRGBO(
                                                    //                 53,
                                                    //                 57,
                                                    //                 69,
                                                    //                 0.15)),
                                                    //         shape: MaterialStateProperty.all<
                                                    //                 RoundedRectangleBorder>(
                                                    //             RoundedRectangleBorder(
                                                    //           borderRadius:
                                                    //               BorderRadius
                                                    //                   .circular(
                                                    //                       25),
                                                    //         )),
                                                    //       ),
                                                    //       child: Icon(
                                                    //         listen
                                                    //             ? Icons
                                                    //                 .notifications_off_rounded
                                                    //             : Icons
                                                    //                 .notifications,
                                                    //         size: 27,
                                                    //         color: listen
                                                    //             ? Colors
                                                    //                 .red[400]
                                                    //             : const Color
                                                    //                     .fromRGBO(
                                                    //                 53,
                                                    //                 57,
                                                    //                 69,
                                                    //                 1),
                                                    //       )),
                                                    // ),
                                                    SizedBox(
                                                      height: 45,
                                                      width: 45,
                                                      child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              follow = !follow;
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all(follow
                                                                    ? Colors
                                                                        .red[
                                                                            400]
                                                                        .withOpacity(
                                                                            0.15)
                                                                    : const Color
                                                                            .fromRGBO(
                                                                        53,
                                                                        57,
                                                                        69,
                                                                        0.15)),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            )),
                                                          ),
                                                          child: Icon(
                                                            follow
                                                                ? Icons
                                                                    .person_remove_alt_1_rounded
                                                                : Icons
                                                                    .person_add_alt_1_rounded,
                                                            size: 27,
                                                            color: follow
                                                                ? Colors
                                                                    .red[400]
                                                                : const Color
                                                                        .fromRGBO(
                                                                    53,
                                                                    57,
                                                                    69,
                                                                    1),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Text(posts.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22)),
                                              const Text(
                                                ' posts',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white60),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Text(followers.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22)),
                                              const Text(
                                                ' followers',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white60),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Text(following.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22)),
                                              const Text(
                                                ' following',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white60),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Flexible(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('File filter set to:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                Flexible(
                                  flex: 2,
                                  child: Flex(
                                      direction: Axis.vertical,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('categories')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Text(
                                                      'There is no expense');
                                                }

                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: DropdownButton(
                                                    value: filter,
                                                    dropdownColor:
                                                        const Color.fromRGBO(
                                                            20, 20, 22, 1),
                                                    hint: const Text(
                                                      'Choose a filter',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white60),
                                                    ),
                                                    isDense: true,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                    underline: const SizedBox(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    items: snapshot.data.docs
                                                        .map((DocumentSnapshot
                                                            document) {
                                                      return DropdownMenuItem<
                                                              String>(
                                                          value: document
                                                              .get('uid'),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Text(
                                                              document
                                                                  .get('name')[
                                                                      'en']
                                                                  .toString(),
                                                            ),
                                                          ));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        filter = value;
                                                      });
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                        filter != null
                                            ? Flexible(
                                                flex: 3,
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      filter = null;
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Clear search engine',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            119, 126, 144, 1),
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 340,
                            width: MediaQuery.of(context).size.width,
                            child: StreamProvider<List<Application>>.value(
                              value: filter != null
                                  ? FeedState(
                                          uidCat: filter, uidUser: data['uid'])
                                      .getAllAppsUsersFilter
                                  : FeedState(uidUser: data['uid'])
                                      .getAllAppsUsers,
                              initialData: const [],
                              child: const ListApp(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        height: 35,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white38.withOpacity(0.05)),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
