import 'package:clever/utils/service/database/database.dart';
import 'package:clever/utils/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static var routeName = '/login';
  final VoidCallback loginCallback;
  const Login({Key key, this.loginCallback}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller;
  bool load = false, errorEnterPhone = false;

  String tokenRE = '';
  bool badgeVisible = true;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  StatefulBuilder mdComfirm({String phone}) {
    return StatefulBuilder(builder: (context, setDialogState) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: const Color.fromRGBO(20, 20, 22, 1),
        child: Container(
          width: 685,
          padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              load
                  ? SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Please wait while checking your code',
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
              const Text(
                'Phone confirmation',
                style: TextStyle(fontSize: 28, color: Colors.white60),
              ),
              Row(
                children: [
                  const Text(
                    'Wait for SMS with a code to your phone ',
                    style: TextStyle(fontSize: 16, color: Colors.white38),
                  ),
                  Text(
                    phone,
                    style: TextStyle(color: Colors.blue[300], fontSize: 16),
                  )
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 75, horizontal: 25),
                child: PinView(
                    count: 6,
                    autoFocusFirstField: true,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    obscureText: false,
                    inputDecoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1.5)),
                        borderSide: BorderSide(
                          width: 4,
                          color: Colors.white38.withOpacity(0.7),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1.5)),
                        borderSide: BorderSide(
                          width: 4,
                          color: Colors.white38,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1.5)),
                        borderSide: BorderSide(
                          width: 4,
                          color: Colors.white38.withOpacity(0.7),
                        ),
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white60),
                    submit: (String pin) {
                      setDialogState(() {
                        load = true;
                      });
                      var state =
                          Provider.of<CloudFirestore>(context, listen: false);
                      state.signInWithPhoneNumberWebConfirm(pin, context);
                    }),
              )
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            loginAppBar(context),
            Container(
              margin: const EdgeInsets.only(top: 160),
              width: 500,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 38, color: Colors.white70),
                  ),
                  errorEnterPhone
                      ? Text(
                          'Please enter your phone number',
                          style: TextStyle(
                              fontSize: 12, color: Colors.red.shade300),
                        )
                      : const Text(
                          'Sign in to continue uploading',
                          style: TextStyle(fontSize: 12, color: Colors.white30),
                        ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 7,
                          child: TextField(
                            controller: controller,
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
                              hintText: 'Enter phone number',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(119, 126, 144, 1),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 14,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              PhoneInputFormatter(
                                onCountrySelected:
                                    (PhoneCountryData countryData) {},
                                allowEndlessPhone: false,
                              )
                            ],
                            style: const TextStyle(
                                color: Color.fromRGBO(119, 126, 144, 1)),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              setState(() {
                                errorEnterPhone = false;
                              });
                            },
                          ),
                        ),
                        Flexible(
                            flex: 3,
                            child: SizedBox(
                              height: 40,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(69, 178, 107, 1)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    )),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 25))),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (controller.text.length >= 11) {
                                    authPressed(controller.text.trim());
                                  } else {
                                    setState(() {
                                      errorEnterPhone = true;
                                    });
                                  }
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void authPressed(String phoneNumber) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    state.signInWithPhoneNumberWeb(phoneNumber);
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => mdComfirm(phone: phoneNumber));
  }
}
