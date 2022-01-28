import 'package:clever/page/feed/feed.dart';
import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/enum/enum.dart';
import 'package:clever/page/home.dart';
import 'package:clever/page/connect/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  static var routeName = '/splash';

  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.getCurrentUser(context: context);
    });
  }

  Widget _body() {
    return const Center(
      child: Text(
        'Case Clever',
        style: TextStyle(
            color: Color.fromRGBO(16, 164, 120, 1),
            fontWeight: FontWeight.bold,
            fontSize: 55),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : const Home(),
    );
  }
}
