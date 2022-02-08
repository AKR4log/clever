import 'package:clever/page/connect/connect.dart';
import 'package:clever/page/feed/feed.dart';
import 'package:clever/page/connect/login/login.dart';
import 'package:clever/page/product/product.dart';
import 'package:clever/page/splash.dart';
import 'package:clever/page/store/store.dart';
import 'package:clever/page/user/profile.dart';
import 'package:clever/page/works/works.dart';
import 'package:clever/utils/service/database/database.dart';
import 'package:clever/utils/service/state/app_state.dart';
import 'package:clever/utils/service/state/feed_state.dart';
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
            fontFamily: 'DMSans',
          ),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashPage(),
            '/feed': (context) => const Feed(),
            '/login': (context) => const Login(),
            '/connect': (context) => const Connect(),
            '/product': (context) => const Product(),
            '/user': (context) => const Profile(),
            '/store': (context) => const Store(),
            '/how_it_works': (context) => const Works(),
          },
          // onGenerateRoute: (settings) {
          // final path = Uri.parse(settings.name);
          // final postID = path.queryParameters['id'];
          // print(postID);
          // switch (path.queryParameters['id']) {
          //   case '4545':
          // return Navigator.pushReplacementNamed(context, '/home',
          //     arguments: {'id': 1234});
          //   default:
          //     return null;
          // }
          // },
          debugShowCheckedModeBanner: false,
          title: 'Case Clever',
        ));
  }
}
