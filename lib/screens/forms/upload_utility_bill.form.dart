import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:zxplore_app/blocs/account_form_bloc.dart';
import 'package:zxplore_app/blocs/provider.dart';

import '../../colors.dart';

class UploadUtilityBillStep extends StatefulWidget {
  @override
  _UploadUtilityBillState createState() => _UploadUtilityBillState();
}

class _UploadUtilityBillState extends State<UploadUtilityBillStep>
    with AutomaticKeepAliveClientMixin<UploadUtilityBillStep> {
  File _imageFile;
  String _retrieveDataError;
  dynamic _pickImageError;
  AccountFormBloc accountFormBloc;
  ByteData _img = ByteData(0);



  @override
  void initState() {
    super.initState();
    accountFormBloc = BlocProvider.of<AccountFormBloc>(context);
    accountFormBloc.uploadUtilityBillController.listen((base64Signature){
      if(_img.lengthInBytes == 0){
        var imageData = base64Decode(base64Signature);

        setState(() {
          _img = imageData.buffer.asByteData();
        });

      }

    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Platform.isAndroid
                  ? FutureBuilder<void>(
                      future: retrieveLostData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Text(
                              'Click either the gallery or camera icon to upload a picture of your utility Bill',
                              textAlign: TextAlign.center,
                            );
                          case ConnectionState.done:
                            return  (_img.buffer.lengthInBytes == 0
                                ? const Text(
                              'Click either the gallery or camera icon to upload a picture of your utility Bill',
                              textAlign: TextAlign.center,
                            ) : LimitedBox(maxHeight: 600.0, child: Image.memory(_img.buffer.asUint8List())));
                          default:
                            if (snapshot.hasError) {
                              return Text(
                                'Pick image error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              const Text(
                                'Click either the gallery or camera icon to upload a picture of your utility Bill',
                                textAlign: TextAlign.center,
                              );
                            }
                        }
                      },
                    )
                  :  (_img.buffer.lengthInBytes == 0
                  ? const Text(
                'Click either the gallery or camera icon to upload a picture of your utility Bill',
                textAlign: TextAlign.center,
              ) : LimitedBox(maxHeight: 600.0, child: Image.memory(_img.buffer.asUint8List()))),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  heroTag: 'image0',
                  backgroundColor: ZxplorePrimaryColor,
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera);
                  },
                  backgroundColor: ZxplorePrimaryColor,
                  heroTag: 'image1',
                  tooltip: 'Take a Photo',
                  child: const Icon(Icons.camera_alt),
                ),

              ],
            ),
            SizedBox(height: 40.0),

          ],
        ),
      ),
    );
  }

//  Text _getRetrieveErrorWidget() {
//    if (_retrieveDataError != null) {
//      final Text result = Text(_retrieveDataError);
//      _retrieveDataError = null;
//      return result;
//    }
//    return null;
//  }

//  Widget _previewImage() {
//    final Text retrieveError = _getRetrieveErrorWidget();
//    if (retrieveError != null) {
//      return retrieveError;
//    }
//    if (_imageFile != null) {
//      _convertImagesToByte();
//      return Image.file(_imageFile);
//    } else if (_pickImageError != null) {
//      return Text(
//        'Pick image error: $_pickImageError',
//        textAlign: TextAlign.center,
//      );
//    } else {
//      return const Text(
//        'Click either the gallery or camera icon to upload a picture of your utility Bill',
//        textAlign: TextAlign.center,
//      );
//    }
//  }


  Future _convertImagesToByte() async {
    List<int> imageBytes = await _imageFile.readAsBytes();
    var imgBytes = new Uint8List.fromList(imageBytes);

    String base64Image = base64Encode(imageBytes);
    _img = imgBytes.buffer.asByteData();

    accountFormBloc.setUploadUtilityBillForm(base64Image);
//    print(base64Image);
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
        _convertImagesToByte();
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    try {
      _imageFile = await ImagePicker.pickImage(source: source, maxHeight: 350);
      _convertImagesToByte();
    } catch (e) {
      _pickImageError = e;
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
