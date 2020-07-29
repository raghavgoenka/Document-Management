import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var scaffold = new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(children: <Widget>[
              Container(
                width: 400.0,
                height: 200,
                margin: EdgeInsets.only(top: 2.0),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                padding: EdgeInsets.fromLTRB(25.0, 60.0, 0.0, 0.0),
                child: Text('Signup',
                    style: TextStyle(
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(205.0, 60.0, 0.0, 0.0),
                child: Text('.',
                    style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ]),
          ),
          Form(
              child: Padding(
            padding: EdgeInsets.only(top: 55.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'USERNAME',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[300]))),
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[300]))),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[300]))),
                ),
                SizedBox(height: 30.0),
                Container(
                  height: 40.0,
                  child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.green,
                      color: Colors.green,
                      child: GestureDetector(
                        onTap: () {
                          Service().createUser(
                              _email, _password, nameController.text, context);
                          // FirebaseAuth.instance
                          //     .createUserWithEmailAndPassword(
                          //         email: _email.trim(),
                          //         password: _password.trim())
                          //     .then((signedUser) {
                          //   print('///////////');

                          //   UserManagement().storeNewUser(
                          //       signedUser.user, context, nameController.text);

                          //   _email = "";
                          //   _password = "";
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MainScreen()),
                          //   );
                          //   Flushbar(
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     forwardAnimationCurve: Curves.decelerate,
                          //     reverseAnimationCurve: Curves.easeOut,
                          //     title: "Success",
                          //     backgroundColor: Colors.blueGrey,
                          //     message: 'Sign Up Successfull ',
                          //     duration: Duration(seconds: 5),
                          //   )..show(context);
                          // }).catchError((e) {
                          //   print("the error1:");
                          //   print(e.toString());
                          //   print('signuperoorrrrrrr1');

                          //   Flushbar(
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     forwardAnimationCurve: Curves.decelerate,
                          //     reverseAnimationCurve: Curves.easeOut,
                          //     title: "Error",
                          //     backgroundColor: Colors.black26,
                          //     message: e.toString(),
                          //     icon: Icon(
                          //       Icons.info_outline,
                          //       size: 28.0,
                          //       color: Colors.blue[300],
                          //     ),
                          //     duration: Duration(seconds: 3),
                          //   )..show(context);
                          // });
                        },
                        child: Center(
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 25.0),
                Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          )),
        ],
      ),
    );

    return scaffold;
  }
}
