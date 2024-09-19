// ignore_for_file: file_names

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_background/remove_background.dart';

class ImgRemoveBg {
  ui.Image? image;
  ByteData? pngBytes;

//function for removing background
  Future<Uint8List> removeBg(context, Uint8List file) async {
    image = await decodeImageFromList(file);
    pngBytes = await cutImage(context: context, image: image!);
    return Uint8List.view(pngBytes!.buffer);
  }
}