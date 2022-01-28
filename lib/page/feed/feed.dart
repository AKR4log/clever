// ignore_for_file: non_constant_identifier_names, missing_return

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clever/page/feed/widgets/list_app.dart';
import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/mdls/app/app.dart';
import 'package:clever/utils/state/feed_state.dart';
import 'package:clever/utils/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Feed extends StatefulWidget {
  static var routeName = '/feed';
  const Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerSearch = TextEditingController();
  DropzoneViewController controllerDrop;
  String photo = '',
      nameFiles = '',
      nameFilesMime = '',
      pathPhoto = '',
      uidData,
      category_status = '1c90fee1-d804-4baf-9ce2-1398a35c4256';
  bool highlighted = false,
      upload = false,
      uploadComplite = false,
      errorUploadMime = false,
      errorName = false;
  firebase_storage.FirebaseStorage fs =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerSearch = TextEditingController();
    controllerDesc = TextEditingController();
  }

  @override
  void dispose() {
    controllerDesc?.dispose();
    controllerName?.dispose();
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
                              Text(
                                nameFiles.toLowerCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
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
                                              value: category_status,
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
                                                setDialogState(() {
                                                  category_status = value;
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
                                                category_status,
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
      body: Column(
        children: [
          mainAppBarAU(context, controllerSearch,
              function: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => mdUpload())),
          Expanded(
            child: StreamProvider<List<Application>>.value(
              value: FeedState().getAllApps,
              initialData: [],
              child: const ListApp(),
            ),
          )
        ],
      ),
    );
  }
}
