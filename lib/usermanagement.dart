import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement {
  storeNewUser(user, context, username) {
    
    Firestore.instance
        .collection('/users')
        .add({'email': user.email, 'uid': user.uid, 'username': username})
        .then((value) {})
        .catchError((e) {
          print(e);
          print("usermanagement");
        });
  }
}
