// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:clever/page/connect/connect.dart';
import 'package:clever/page/feed/feed.dart';
import 'package:clever/utils/enum/enum.dart';
import 'package:clever/utils/state/app_state.dart';
import 'package:clever/page/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CloudFirestore extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ConfirmationResult confirmationResult;
  User user;
  CollectionReference refU = FirebaseFirestore.instance.collection("users");
  CollectionReference refF = FirebaseFirestore.instance.collection("files");

  signInWithPhoneNumberWeb(phoneNumber) async {
    confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(
      phoneNumber,
    );
  }

  signInWithPhoneNumberWebConfirm(code, context) async {
    await Firebase.initializeApp();
    UserCredential firebaseResult = await confirmationResult.confirm(code);
    user = firebaseResult.user;
    if (firebaseResult.additionalUserInfo.isNewUser) {
      authStatus = AuthStatus.REGISTER_NOW_USER;
      Navigator.of(context).pushReplacementNamed(Connect.routeName);
    } else {
      String uid = FirebaseAuth.instance.currentUser.uid;
      refU.doc(uid).get().then((value) {
        if (value.data() == null) {
          authStatus = AuthStatus.REGISTER_NOW_USER;
          Navigator.of(context).pushReplacementNamed(Connect.routeName);
        } else {
          String time = DateTime.now().toUtc().toString();

          refU
              .doc(uid)
              .collection('info')
              .doc('info_login')
              .update({'last_entrance': time}).whenComplete(() {
            authStatus = AuthStatus.LOGGED_IN;
            Navigator.of(context).pushReplacementNamed(Feed.routeName);
          });
        }
      });
    }
  }

  Future<User> getCurrentUser({context}) async {
    try {
      await Firebase.initializeApp();
      loading = true;
      user = _firebaseAuth.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get()
            .then((value) {
          if (value.data() != null) {
            if (value.data()['name'] != '') {
              authStatus = AuthStatus.LOGGED_IN;
              Navigator.of(context).pushReplacementNamed(Home.routeName);
            } else {
              authStatus = AuthStatus.REGISTER_NOW_USER;
              Navigator.of(context).pushReplacementNamed(Connect.routeName);
            }
          } else {
            authStatus = AuthStatus.REGISTER_NOW_USER;
            Navigator.of(context).pushReplacementNamed(Connect.routeName);
          }
        });
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch (error) {
      loading = false;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> createNewUser(BuildContext context, String name,
      {String photo}) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    String phone = FirebaseAuth.instance.currentUser.phoneNumber;
    String time = DateTime.now().toUtc().toString();

    refU.doc(uid).set({
      'name': name ?? null,
      'username': uid,
      'photo': photo ?? null,
      'phone': phone,
      'uid': uid,
    }).whenComplete(() =>
        refU.doc(uid).collection('data').doc('data_login').set({
          'last_entrance': time,
          'last_ip': null,
          'registered': time,
        }).whenComplete(
            () => Navigator.of(context).pushReplacementNamed(Feed.routeName)));
    return;
  }

  Future<void> createNewPost(BuildContext context, String title, String photo,
      String uidFile, String path, String uidCategory,
      {String description}) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    String createdDate = DateTime.now().toUtc().toString();

    refF.doc(uidFile).set({
      'title': title,
      'uidFile': uidFile,
      'description': description ?? null,
      'createdDate': createdDate,
      'author': uid,
      'public': false,
      'state': 'review',
      'animated': true,
      'url': {'absolute': photo, 'relative': path},
    }).whenComplete(() => refU.doc(uid).collection('files').doc(uidFile).set({
          'latest_edit_date': null,
          'uidFile': uidFile,
        }).whenComplete(
            () => Navigator.of(context).pushReplacementNamed(Feed.routeName)));
    ;
    return;
  }
}
