import 'package:clever/utils/database/database.dart';
import 'package:clever/utils/enum/enum.dart';
import 'package:clever/page/home.dart';
import 'package:clever/page/login.dart';
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
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Case Clever',
              style: TextStyle(
                  color: Color.fromRGBO(103, 25, 168, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 45),
            ),
            Text(
              'admin panel',
              style: TextStyle(
                  color: Color.fromRGBO(103, 25, 168, 0.55), fontSize: 25),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 238, 252, 1),
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : state.authStatus == AuthStatus.LOGGED_IN
              ? const Home()
              : state.authStatus == AuthStatus.NOT_LOGGED_IN ||
                      state.authStatus != AuthStatus.LOGGED_IN
                  ? const Connect()
                  : const Home(),
    );
  }
}
