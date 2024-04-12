/*
import 'dart:io';

import 'package:catage/View_home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading;
  File _image;
  List _output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value){
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  chooseImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this._isLoading = true;
      this._image = imageTemporary;
    });

  }

  loadModel() async{
    await Tflite.loadModel(model: "assets/model_unquant.tflite",
    labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
*/