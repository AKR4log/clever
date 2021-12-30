import 'package:clever/utils/database/database.dart';
import 'package:clever/page/comfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:provider/provider.dart';

class Connect extends StatefulWidget {
  static var routeName = '/connect';
  final VoidCallback loginCallback;
  const Connect({Key key, this.loginCallback}) : super(key: key);

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  TextEditingController controller;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[50],
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          'connect',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 25),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 75, left: 35, right: 35),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isCollapsed: true,
                            hintText: 'Введите номер телефона',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            filled: true,
                            fillColor: const Color.fromRGBO(245, 245, 245, 1),
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
                              color: Color.fromRGBO(13, 2, 33, 1)),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                          onPressed: () => authPressed(controller.text.trim()),
                          child: const Text('Авторизоваться'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void authPressed(String phoneNumber) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    state.signInWithPhoneNumberWeb(phoneNumber);
    Navigator.of(context).pushNamed(Comfrim.routeName);
  }
}
