import 'package:clever/page/comfirm.dart';
import 'package:clever/page/home.dart';
import 'package:clever/page/login.dart';
import 'package:clever/page/splash.dart';
import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/state/app_state.dart';
import 'package:clever/utils/state/feed_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),
          ChangeNotifierProvider<CloudFirestore>(
              create: (_) => CloudFirestore()),
          ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'ReadexPro',
          ),
          initialRoute: SplashPage.routeName,
          routes: {
            SplashPage.routeName: (context) => const SplashPage(),
            Home.routeName: (context) => const Home(),
            Connect.routeName: (context) => const Connect(),
            Comfrim.routeName: (context) => const Comfrim(),
          },
          title: 'Case Clever',
        ));
  }
}
