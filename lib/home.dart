import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'subjectdata.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeView extends StatefulWidget {
  final String userEmail;
  final String userName;
  HomeView(this.userEmail, this.userName);

  @override
  _HomeViewState createState() => _HomeViewState(userEmail, userName);
}

class _HomeViewState extends State<HomeView> {
  File sampleImage;
  String userEmail;
  String userName;
  String listData = "";
  TextEditingController addController = TextEditingController();

  _HomeViewState(this.userEmail, this.userName);

  Future getData() async {
    listData = addController.text;
    if (listData.length > 0) {
      Firestore.instance
          .collection(userEmail)
          .document('subjects')
          .collection("NewSubjects")
          .add({'Subject': listData})
          .then((value) {})
          .catchError((e) {
            print(e);
          });
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        title: "Filed can't be empty",
        backgroundColor: Colors.blueGrey,
        message: 'Please add your subject ',
        duration: Duration(seconds: 3),
      )..show(context);
    }

    addController.text = "";
  }

  Future getSubject() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection(userEmail)
        .document('subjects')
        .collection('NewSubjects')
        .getDocuments();

    return qn.documents;
  }

  File _image;
  final picker = ImagePicker();
  String a;

  Future getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
    print(_image);
    prefs.setString('_image', _image.path);
    prefs.setString('checkEmail', userEmail);
    print(".................................");
    // if (prefs.getString('checkEmail') == userEmail) {
    a = prefs.getString('_image');
  }

  deleteSubject(mySubject) {
    print(mySubject);

    Firestore.instance
        .collection(userEmail)
        .document("subjects")
        .collection("NewSubject")
        .document(mySubject.documentId)
        .delete();
  }

  picked(File image) async {
    String da = "";
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer readText = FirebaseVision.instance.textRecognizer();
    VisionText text = await readText.processImage(ourImage);
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          da = da + " " + word.text;
        }
      }
    }
    modalBottomSheet(da);
    // GoogleTranslator translator = GoogleTranslator();

    // translator.translate(da, to: "en").then((output) {
    //   modalBottomSheet(output);
    // });
  }

  void modalBottomSheet(data) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height * 50,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.blueGrey,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Text("Recognised Text",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white)),
                        SizedBox(width: 50.0),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 0,
                          child: Text('Copy'),
                          textColor: Colors.white,
                          color: Colors.blueGrey[200],
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: data));
                            Navigator.pop(context);
                            Flushbar(
                              forwardAnimationCurve: Curves.decelerate,
                              reverseAnimationCurve: Curves.easeOut,
                              title: "success",
                              backgroundColor: Colors.black26,
                              message: "Text Copied",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          },
                        ),
                        SizedBox(width: 30.0),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 220.0),
                    height: 400,
                    color: Colors.blueGrey,
                    child: Row(
                      children: <Widget>[
                        Text(data.toString().substring(0, 20),
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  textRecognition() {
    Navigator.pop(context);
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Choose the option"),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Camera"),
                  onPressed: () async {
                    File image, cropped;
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.getImage(source: ImageSource.camera);
                    if (pickedFile.path != null) {
                      cropped = await ImageCropper.cropImage(
                          sourcePath: pickedFile.path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          compressQuality: 100,
                          maxHeight: 700,
                          maxWidth: 700,
                          compressFormat: ImageCompressFormat.jpg,
                          androidUiSettings: AndroidUiSettings(
                              toolbarColor: Colors.green,
                              toolbarTitle: "Image Cropper",
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false,
                              statusBarColor: Colors.blue,
                              backgroundColor: Colors.white));
                    }
                    Navigator.pop(context);
                    setState(() {
                      image = File(cropped.path);
                    });
                    picked(image);
                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"),
                  onPressed: () async {
                    File image, cropped;
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile.path != null) {
                      cropped = await ImageCropper.cropImage(
                          sourcePath: pickedFile.path,
                          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                          compressQuality: 100,
                          maxHeight: 700,
                          maxWidth: 700,
                          compressFormat: ImageCompressFormat.jpg,
                          androidUiSettings: AndroidUiSettings(
                              toolbarColor: Colors.green,
                              toolbarTitle: "Image Cropper",
                              statusBarColor: Colors.blue,
                              backgroundColor: Colors.white));
                    }
                    Navigator.pop(context);
                    setState(() {
                      image = File(cropped.path);
                    });
                    picked(image);
                  },
                )
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var scaffold = new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text('Add your Subjects',
            maxLines: 1,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            onDetailsPressed: () {
              getImage();
            },
            decoration: BoxDecoration(color: Colors.green),
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: a == null
                  ? Image.network(
                      'https://www.woolha.com/media/2020/03/eevee.png')
                  : new CircleAvatar(
                      backgroundImage: new FileImage(File(a)),
                      radius: 200.0,
                    ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.scanner),
            elevation: 0,
            color: Colors.green[400],
            label: Text('Text Recognition'),
            onPressed: () {
              textRecognition();
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(80.0, 400.0, 0.0, 0.0),
            leading: Icon(Icons.all_out),
            title: Text(
              'Sign out',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.blue),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('loginStatus');
                prefs.remove('username');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new MainScreen()),
                );
              }).catchError((e) {
                print(e.toString().trim());
              });
            },
          ),
        ],
      )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            TextField(
              maxLength: 30,
              controller: addController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.note_add),
                border: OutlineInputBorder(),
                labelText: 'Add Subject',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            RaisedButton(
              onPressed: () {
                getData();
              },
              elevation: 7,
              child: Text('Upload'),
              textColor: Colors.black,
              color: Colors.white,
            ),
            SizedBox(height: 30.0),
            Text("Your Uploaded Subject"),
            SizedBox(height: 10.0),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.grey[300],
              ),

              //
              child: FutureBuilder(
                future: getSubject(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Loading'));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[400],
                            shadowColor: Colors.amber,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Tooltip(
                                  message: "Click Here to get and upload notes",
                                  child: ListTile(
                                    hoverColor: Colors.amber,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new Subject(
                                                snapshot.data[index]
                                                    .data['Subject'],
                                                userEmail)),
                                      );
                                    },
                                    onLongPress: () {
                                      deleteSubject(
                                        snapshot.data[index].data['Subject'],
                                      );
                                    },
                                    leading: InkWell(
                                      splashColor: Colors.amber,
                                      // onTap: deleteSubject("MAths"),
                                      child: Icon(Icons.delete, size: 50),
                                    ),
                                    trailing: new PopupMenuButton(
                                      itemBuilder: (BuildContext context) =>
                                          snapshot.data,
                                      icon: Icon(Icons.arrow_forward_ios),
                                      tooltip: "Tap me to See notes",
                                    ),
                                    title: Text(snapshot
                                        .data[index].data['Subject']
                                        .toString()),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
    return scaffold;
  }

  // Widget enableTextRecognition() {
  //   return AlertDialog(
  //     title: Text("Choose the option"),
  //     actions: <Widget>[
  //       FlatButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text("Camera")),
  //       FlatButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: Text("Gallery"))
  //     ],
  //   );
  // }
}
