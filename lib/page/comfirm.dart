import 'package:clever/utils/database/database.dart';
import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';

class Comfrim extends StatefulWidget {
  static var routeName = '/confirm_code';
  final String verificationID;
  const Comfrim({Key key, this.verificationID}) : super(key: key);

  @override
  _ComfrimState createState() => _ComfrimState();
}

class _ComfrimState extends State<Comfrim> {
  TextEditingController _controllerCodes;
  bool enableButtonAuth = false, wait = false;
  String pinCode;

  @override
  void initState() {
    _controllerCodes = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromRGBO(247, 247, 249, 1),
      appBar: AppBar(
        leading: const BackButton(color: Color.fromRGBO(143, 161, 180, 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'connect',
          style: TextStyle(
            color: Color.fromRGBO(143, 161, 180, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.25),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.3),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Провека телефона',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Дождитесь смс на ваш телефон',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(143, 161, 180, 1)
                                  .withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        child: PinView(
                            count: 6,
                            autoFocusFirstField: true,
                            margin: const EdgeInsets.all(2),
                            obscureText: false,
                            style: const TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w600),
                            submit: (String pin) {
                              setState(() {
                                wait = true;
                                enableButtonAuth = true;
                                pinCode = pin;
                              });
                              var state = Provider.of<CloudFirestore>(context,
                                  listen: false);
                              state.signInWithPhoneNumberWebConfirm(
                                  pin, context);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmPressed(String pin) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    state.signInWithPhoneNumberWebConfirm(pin, context);
  }
}
