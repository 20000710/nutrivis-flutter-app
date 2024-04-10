import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:nutri_vis/Modal/modal.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? imageFile = null;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "HomeScreen",
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: imageFile == null
                        ? const AssetImage('images/default-picture.png') as ImageProvider
                        : FileImage(imageFile!),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedBu  tton(onPressed: () {
                _settingModalBottomSheet(context);
              },
                child: const Text("Take Photo")
              ),
            ],
          ),
        ),
      ),
    );
  }

  //****** IMAGE PICKER

  Future imageSelector(BuildContext context, String pickerType) async {

    switch (pickerType) {
      case "gallery":

        // GALLERY IMAGE PICKER
        var storeFile = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 90);

        setState(() {
          imageFile = File(storeFile!.path);

          debugPrint("SELECTED IMAGE PICK   $imageFile");
        });
        break;

      case "camera":

        // CAMERA CAPTURE CODE
        var storeFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);

        setState(() {
          imageFile = File(storeFile!.path);
        });
        break;
    }

    if(imageFile != null) {
      print("you selected image : ${imageFile!.path}");
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");

      });
    } else {
      print("You have not taken image");
    }
  }

  // Image Picker
  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: new Text('Gallery'),
                  onTap: () => {
                    imageSelector(context, "gallery"),
                    Navigator.pop(context),
                  }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                )
              ],
            ),
          );
        }
    );
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance.collection("Goods");

    ref.doc(uniqueIdName).set({
      "goodsID": uniqueIdName,
      "name": "barang test",
      "description": "lorem ipsum",
      "createdAt": DateTime.now(),
      "imageUrl": downloadUrl,
    });
  }

  uploadImage(imageUpload) async{
    storageRef.Reference reference = storageRef.FirebaseStorage.instance
      .ref()
      .child("goods");
    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(imageUpload);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
