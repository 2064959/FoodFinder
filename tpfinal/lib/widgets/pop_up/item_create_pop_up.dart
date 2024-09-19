// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/widgets/items/item_picker_image.dart';

class ItemCreatePopUp extends StatefulWidget {
  const ItemCreatePopUp({
    super.key,
  });

  @override
  State<ItemCreatePopUp> createState() => _ItemCreatePopUpState();
}

class _ItemCreatePopUpState extends State<ItemCreatePopUp> {
  ArticleShared item = ArticleShared(
      "",
      "",
      "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4",
      "",
      Timestamp.now());

  var _myUserImageFile;

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: width,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/post-it-modified.png',
                  width: double.infinity,
                  height: 400,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.topRight,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Name',
                      label: Text('Name'),
                    ),
                    onChanged: (text) {
                      setState(() {
                        item.setNom(text);
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextField(
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Add by',
                            label: Text('Add by'),
                          ),
                          onChanged: (text) {
                            setState(() {
                              item.setAddBy(text);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextField(
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Category',
                            label: Text('Category'),
                          ),
                          onChanged: (text) {
                            setState(() {
                              item.setCategorie(text);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.addBy == "" ||
                              item.categorie == "" ||
                              item.nom == ""
                          ? const Color.fromARGB(255, 55, 48, 26)
                          : const Color.fromARGB(255, 255, 205, 41),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      if (item.addBy != "" &&
                          item.categorie != "" &&
                          item.nom != "") {
                        setState(() {
                          item.setDate(Timestamp.now());
                        });
                        saveImage();

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/photo.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    scale: 1.5,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15, top: 165),
                    alignment: Alignment.topLeft,
                    child: UserImagePicker(_myPickImage)),
              ],
            ),
          );
        },
      ),
    );
  }

  void saveImage() async {
    if (_myUserImageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('${_myUserImageFile.hashCode}.jpg');

      await ref.putFile(File(_myUserImageFile.path)).whenComplete((() => true));

      final url = await FirebaseStorage.instance
          .ref()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('${_myUserImageFile.hashCode}.jpg')
          .getDownloadURL();

      saveItem(
          ArticleShared(item.addBy, item.categorie, url, item.nom, item.date));
    } else {
      saveItem(item);
    }
  }

  void saveItem(ArticleShared item) async {
    await FirebaseFirestore.instance
        .collection('globalListItem')
        .add(item.toMap());
  }
}
