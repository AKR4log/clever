import 'package:clever/utils/enum/enum.dart';
import 'package:clever/utils/state/app_state.dart';
import 'package:clever/page/home.dart';
import 'package:clever/page/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CloudFirestore extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ConfirmationResult confirmationResult;
  User user;

  signInWithPhoneNumberWeb(phoneNumber) async {
    confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(
      phoneNumber,
    );
  }

  signInWithPhoneNumberWebConfirm(code, context) async {
    UserCredential userCredential = await confirmationResult.confirm(code);
    user = userCredential.user;
    authStatus = AuthStatus.LOGGED_IN;
    Navigator.of(context).pushReplacementNamed(Home.routeName);
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
            authStatus = AuthStatus.LOGGED_IN;
            Navigator.of(context).pushReplacementNamed(Home.routeName);
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
      debugPrint(user.toString());
      debugPrint("ERROR");
      debugPrint(error.toString());
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> createNewUser(
    BuildContext context,
    String name,
    String surname, {
    String downloadURI,
  }) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    var phone = FirebaseAuth.instance.currentUser.phoneNumber;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).set({
      "name": name,
      "surname": surname,
      "uriImage": downloadURI,
      "phoneNumber": phone,
      "uidUser": uid,
    }).whenComplete(
        () => Navigator.of(context).pushReplacementNamed(Home.routeName));
    return;
  }
}
