import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'pdf_viewer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class Subject extends StatefulWidget {
  final String indexSubject;
  final String emailofUser;
  Subject(this.indexSubject, this.emailofUser);
  @override
  _SubjectData createState() => _SubjectData(indexSubject, emailofUser);
}

class _SubjectData extends State<Subject> {
  String indexSubject;
  String emailofUser;
  bool visible = false;
  File sampleFile;
  int checker = 0;
  String textHolder = 'Upload';
  _SubjectData(this.indexSubject, this.emailofUser);
  TextEditingController nameFileController = TextEditingController();
  Future getImage() async {
    File file = await FilePicker.getFile();
    RegExp re = new RegExp(r'(.+\.pdf)');
    print(file.toString());
    print('Has match: ${re.hasMatch(file.toString())}');
    bool value = re.hasMatch(file.toString());
    if (value == false) {
      Alert(
        context: context,
        title: "OOPS",
        desc: "Only PDFs are allowed",
        type: AlertType.warning,
      ).show();
    } else {
      setState(() {
        sampleFile = file;
      });
    }
  }

  Future<String> uploadImage() async {
    var url;
    if (checker == 0) {
      if (visible == false) {
        setState(() {
          visible = true;
          textHolder = "Uploading...";
        });
      } else {
        setState(() {
          visible = false;
          textHolder = "Upload";
        });
      }

      try {
        if (nameFileController.text.isNotEmpty) {
          StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child("pdf/" +
                  emailofUser +
                  "/" +
                  indexSubject +
                  "/" +
                  sampleFile.toString().trim().substring(52));
          final StorageUploadTask task = firebaseStorageRef.putFile(sampleFile);
          url = await (await task.onComplete).ref.getDownloadURL();
          Firestore.instance
              .collection(emailofUser)
              .document(indexSubject)
              .collection('pdfs')
              .add({'Url': url.toString(), 'FileName': nameFileController.text})
              .then((value) {})
              .catchError((e) {
                print(e);
              });
          nameFileController.text = "";

          Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            reverseAnimationCurve: Curves.easeOut,
            title: "Success",
            backgroundColor: Colors.black26,
            message: "upload successfull",
            duration: Duration(seconds: 3),
          )..show(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Subject(indexSubject, emailofUser)),
          // );
        } else {
          Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            reverseAnimationCurve: Curves.easeOut,
            title: "Error",
            backgroundColor: Colors.black26,
            message: "File Name is must",
            duration: Duration(seconds: 3),
          )..show(context);
        }
        setState(() {
          visible = false;
          textHolder = "Uplaod";
        });
      } catch (e) {}
    }
    return url;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do u really Want to close the uploading process?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"))
              ],
            ));
  }

  Future getNotesofSubject() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection(emailofUser.toString())
        .document(indexSubject.toString())
        .collection('pdfs')
        .getDocuments();
    return qn.documents;
  }

  deleteFirebasePdf(documentPdf) async {
    print(documentPdf);
    Firestore.instance
        .collection(emailofUser)
        .document(indexSubject)
        .collection('pdfs')
        .document(documentPdf)
        .delete()
        .then((value) {
      Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeIn,
        title: "Success",
        backgroundColor: Colors.black26,
        message: "File deleted successfully",
        duration: Duration(seconds: 3),
      )..show(context);
      setState(() {
        getNotesofSubject();
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(indexSubject.toUpperCase() + " Notes"),
      ),
      body: FutureBuilder(
        future: getNotesofSubject(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading'),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: sampleFile == null
                  ? Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                      width: 310.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.grey[300],
                      ),
                      child: Text(
                        "  Here You can upload your subject related PDF Notes!By Cilcking on the floating Button",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.red, fontSize: 15.0),
                      ))
                  : enableUpload(),
            );
          } else {
            if (sampleFile == null) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new PdfView(
                                        snapshot.data[index].data['Url'])),
                              );
                            },
                            onLongPress: () {
                              final String path =
                                  snapshot.data[index].data['Url'];

                              Share.text('File Sharing', path, 'text');
                            },
                            leading: Icon(Icons.note, size: 50),
                            title: Text(snapshot.data[index].data['FileName']
                                .toString()),
                            subtitle: Text(indexSubject),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 25.0,
                                    color: Colors.brown[900],
                                  ),
                                  onPressed: () {
                                    deleteFirebasePdf(
                                        snapshot.data[index].documentID);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return enableUpload();
            }
          }
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          getImage();
        },
        tooltip: 'Add Image',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget enableUpload() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            TextField(
              controller: nameFileController,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                prefixIcon: Icon(Icons.picture_as_pdf),
                labelText: 'Provide name for file',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              elevation: 10,
              child: Text('$textHolder'),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {
                uploadImage();
              },
            ),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visible,
                child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
