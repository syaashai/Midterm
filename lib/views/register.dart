import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/camera.png';
  var _image;
  final TextEditingController _premailEditingController =
      TextEditingController();
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prphonenoEditingController =
      TextEditingController();
  final TextEditingController _prhomeaddressEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    print("dispose was called");
    _premailEditingController.dispose();
    _prnameEditingController.dispose();
    _prphonenoEditingController.dispose();
    _prhomeaddressEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: SizedBox(
                width: ctrwidth,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Card(
                      child: GestureDetector(
                          onTap: () => {_takePictureDialog()},
                          child: SizedBox(
                              height: screenHeight / 3.9,
                              width: screenWidth,
                              child: _image == null
                                  ? Image.asset(pathAsset)
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ))),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _prnameEditingController,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _premailEditingController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _prphonenoEditingController,
                      decoration: InputDecoration(
                          labelText: 'Phone number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _prhomeaddressEditingController,
                      decoration: InputDecoration(
                          labelText: 'Home address',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text("Register"),
                        onPressed: () {
                          _insertDialog();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ]),
                ))),
      ),
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _insertDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Add this detail",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _insertProduct();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _insertProduct() {
    String _prname = _prnameEditingController.text;
    String _premail = _premailEditingController.text;
    String _prphoneno = _prphonenoEditingController.text;
    String _prhomeaddress = _prhomeaddressEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse("http://10.143.137.226/mytutor/php/register_user.php"),
        body: {
          "name": _prname,
          "email": _premail,
          "phoneno": _prphoneno,
          "homeaddress": _prhomeaddress,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
