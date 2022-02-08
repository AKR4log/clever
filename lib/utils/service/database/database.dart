// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:clever/page/connect/connect.dart';
import 'package:clever/page/feed/feed.dart';
import 'package:clever/utils/enum/enum.dart';
import 'package:clever/utils/service/state/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      final String uid = FirebaseAuth.instance.currentUser.uid;
      refU.doc(uid).get().then((value) {
        if (value.data() == null) {
          authStatus = AuthStatus.REGISTER_NOW_USER;
          Navigator.of(context).pushReplacementNamed(Connect.routeName);
        } else {
          final String time = DateTime.now().toUtc().toString();

          refU
              .doc(uid)
              .collection('data')
              .doc('data_login')
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
              Navigator.pushNamed(context, '/feed');
            } else {
              authStatus = AuthStatus.REGISTER_NOW_USER;
              Navigator.pushNamed(context, '/connect');
            }
          } else {
            authStatus = AuthStatus.REGISTER_NOW_USER;
            Navigator.pushNamed(context, '/connect');
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
    final String uid = FirebaseAuth.instance.currentUser.uid;
    final String phone = FirebaseAuth.instance.currentUser.phoneNumber;
    final String time = DateTime.now().toUtc().toString();

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
            () => refU.doc(uid).collection('data').doc('data_tracking').set({
                  'last_like': null,
                  'last_like_uid': null,
                  'last_post': null,
                  'last_post_uid': null,
                }).whenComplete(() => Navigator.pushNamed(context, '/feed'))));
    return;
  }

  Future<void> upadateDataUser(
      BuildContext context, String name, String photo) async {
    await Firebase.initializeApp();
    final String uid = FirebaseAuth.instance.currentUser.uid;

    if (name != null) {
      if (photo != null) {
        refU.doc(uid).update({
          'name': name,
          'photo': photo,
        }).whenComplete(() => Navigator.pushNamed(context, '/feed'));
      } else {
        refU.doc(uid).update({
          'name': name,
        }).whenComplete(() => Navigator.pushNamed(context, '/feed'));
      }
    } else {
      if (photo != null) {
        refU.doc(uid).update({
          'photo': photo,
        }).whenComplete(() => Navigator.pushNamed(context, '/feed'));
      }
    }

    return;
  }

  Future<void> createNewPost(BuildContext context, String title, String photo,
      String uidFile, String path, String uidsCategory,
      {String description}) async {
    await Firebase.initializeApp();
    final String uid = FirebaseAuth.instance.currentUser.uid;
    final String createdDate = DateTime.now().toUtc().toString();

    refF.doc(uidFile).set({
      'title': title,
      'uidFile': uidFile,
      'description': description ?? null,
      'createdDate': createdDate,
      'author': uid,
      'public': false,
      'state': 'review',
      'categories': uidsCategory,
      'animated': true,
      'url': {'absolute': photo, 'relative': path},
    }).whenComplete(() => refU.doc(uid).collection('files').doc(uidFile).set({
          'latest_edit_date': null,
          'uidFile': uidFile,
        }).whenComplete(() => refU
                .doc(uid)
                .collection('data')
                .doc('data_tracking')
                .update({
              'last_post': createdDate,
              'last_post_uid': uidFile,
            }).whenComplete(() => Navigator.pushNamed(context, '/product',
                    arguments: {'uid': uidFile}))));

    return;
  }

  Future<void> createLikePost(BuildContext context, String uidPost) async {
    await Firebase.initializeApp();
    final String uidUser = FirebaseAuth.instance.currentUser.uid;
    final String createdDate = DateTime.now().toUtc().toString();

    refF.doc(uidPost).collection('liked').doc(uidUser).set({
      'uidUser': uidUser,
      'uidPost': uidPost,
      'createdDate': createdDate,
    }).whenComplete(
        () => refU.doc(uidUser).collection('data').doc('data_tracking').update({
              'last_like': createdDate,
              'last_like_uid': uidPost,
            }));
    return true;
  }

  Future<void> removeLikePost(BuildContext context, String uidPost) async {
    await Firebase.initializeApp();
    final String uidUser = FirebaseAuth.instance.currentUser.uid;

    refF.doc(uidPost).collection('liked').doc(uidUser).delete();
    return true;
  }

  Future<void> follow(BuildContext context, String uidUser) async {
    await Firebase.initializeApp();
    final String uid = FirebaseAuth.instance.currentUser.uid;
    final String createdDate = DateTime.now().toUtc().toString();

    refU.doc(uid).collection('following').doc(uidUser).set({
      'uidUserFollowing': uidUser,
      'uidUserFrom': uid,
      'createdDate': createdDate,
    }).whenComplete(
        () => refU.doc(uidUser).collection('followers').doc(uid).set({
              'uidUserFollowers': uid,
              'uidUserFor': uidUser,
              'createdDate': createdDate,
            }));
    return true;
  }

  Future<void> unFollow(BuildContext context, String uidUser) async {
    await Firebase.initializeApp();
    final String uid = FirebaseAuth.instance.currentUser.uid;

    refF.doc(uid).collection('following').doc(uidUser).delete().whenComplete(
        () => refU.doc(uidUser).collection('followers').doc(uid).delete());
    return true;
  }
}
