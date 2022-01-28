import 'package:clever/utils/mdls/app/app.dart';
import 'package:clever/utils/mdls/app/cat.dart';
import 'package:clever/utils/mdls/user/user.dart';
import 'package:clever/utils/state/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedState extends AppState {
  final String uidUser;
  final String uidApp;
  final String uidCat;
  FeedState({
    this.uidUser,
    this.uidApp,
    this.uidCat,
  });

  final CollectionReference filesCall =
      FirebaseFirestore.instance.collection('files');
  final CollectionReference usersCall =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference categoriesCall =
      FirebaseFirestore.instance.collection('categories');
  String uidAU = FirebaseAuth.instance.currentUser.uid;

  // Loading an authorized user
  UserData getAU(DocumentSnapshot snapshot) {
    return UserData(
        username: snapshot.get('username'),
        uid: snapshot.get('uid'),
        name: snapshot.get('name'),
        photo: snapshot.get('photo'),
        phone: snapshot.get('phone'));
  }

  Stream<UserData> get authUser {
    return usersCall.doc(uidAU).snapshots().map(getAU);
  }

  Stream<UserData> get getUser {
    return usersCall.doc(uidUser).snapshots().map(getAU);
  }

  // Loading all users
  List<UserData> loadUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          username: doc.get('username'),
          uid: doc.get('uid'),
          name: doc.get('name'),
          photo: doc.get('photo'),
          phone: doc.get('phone'));
    }).toList();
  }

  Stream<List<UserData>> get getAllUsers {
    return usersCall.snapshots().map(loadUsers);
  }

  // Loading all categories
  List<Cat> loadCategories(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Cat(
          enabled: doc.get('enabled'),
          name: doc.get('name'),
          uid: doc.get('uid'));
    }).toList();
  }

  Stream<List<Cat>> get getAllCat {
    return categoriesCall.snapshots().map(loadCategories);
  }

  // Loading all documents from the database
  List<Application> loadApps(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Application(
        animated: doc.get('animated'),
        createdDate: doc.get('createdDate'),
        title: doc.get('title'),
        description: doc.get('description'),
        uidFile: doc.get('uidFile'),
        public: doc.get('public'),
        state: doc.get('state'),
        author: doc.get('author'),
        url: doc.get('url'),
      );
    }).toList();
  }

  Stream<List<Application>> get getAllApps {
    return filesCall
        .where('public', isEqualTo: false)
        .where('state', isEqualTo: 'review')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map(loadApps);
  }

  // Loading one document from the database
  Application loadApp(DocumentSnapshot snapshot) {
    return Application(
      animated: snapshot.get('animated') ?? false,
      createdDate: snapshot.get('created_date'),
      title: snapshot.get('title'),
      uidFile: snapshot.get('uidFile'),
      description: snapshot.get('description'),
      public: snapshot.get('public'),
      state: snapshot.get('state') ?? 'archived',
      author: snapshot.get('author'),
      url: snapshot.get('url'),
    );
  }

  Stream<Application> get getApp {
    return filesCall.doc(uidApp).snapshots().map(loadApp);
  }
}
