import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'usermanagement.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  GoogleSignIn googleSignIn = new GoogleSignIn();
//Email n password Sign Up
  String message = "";
  String userUsername = '';
  createUser(String _email, String _password, String username, context) {
    print(_email);
    // userUsername = username;
    print("/////////////////" + userUsername);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim())
        .then((signedUser) {
      print(message);
      UserManagement().storeNewUser(signedUser.user, context, username);

      _email = "";
      _password = "";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        title: "Success",
        backgroundColor: Colors.blueGrey,
        message: 'Sign Up Successfull ',
        duration: Duration(seconds: 5),
      )..show(context);
    }).catchError((e) {
      print("the error1:");
      print(e.toString());
      print('signuperoorrrrrrr1');

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        title: "Error",
        backgroundColor: Colors.black26,
        message: e.toString(),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

//Login For Users

  userLogin(
    String email,
    String password,
    context,
    int _state,
  ) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((user) async {
      String name;

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        title: "Success",
        backgroundColor: Colors.black26,
        message: "Loged In Successfully",
        icon: Icon(
          Icons.supervised_user_circle,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      Firestore.instance
          .collection("users")
          .where('email', isEqualTo: email.trim())
          .getDocuments()
          .then((querySnapshot) async {
        querySnapshot.documents.forEach((result) async {
          name = (result.data['username'].toString());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('loginStatus', email);
          prefs.setString('username', name);
          new Duration(milliseconds: 2000);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new HomeView(
                      email,
                      name,
                    )),
          );
        });
      });
    }).catchError((e) {
      print(e.toString());

      Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        title: "Error",
        backgroundColor: Colors.black26,
        message: e.toString().trim().substring(24),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
      )..show(context);
    });

    return _state = 2;
  }

//Google SignIn
  Future<FirebaseUser> googleLogin(context) async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: "Success",
      backgroundColor: Colors.black26,
      message: "Loged In Successfully",
      icon: Icon(
        Icons.supervised_user_circle,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 10),
    )..show(context);
    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser users = authResult.user;
    print("signed in " + users.displayName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginStatus', users.email);
    prefs.setString('username', users.displayName);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new HomeView(
                users.email,
                users.displayName,
              )),
    );

    return users;
  }

  forgotPassword(String email, context) async {
    print("clicked");

    firebaseAuth.sendPasswordResetEmail(email: email);
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: "Success",
      backgroundColor: Colors.black26,
      message: "Password link sent to your mail",
      icon: Icon(
        Icons.supervised_user_circle,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 10),
    )..show(context);
  }
}
