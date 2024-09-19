import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(XFile pickImage) imagePickFn;
  const UserImagePicker(this.imagePickFn, {super.key});
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photoFile =
        await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = XFile(photoFile!.path);
      widget.imagePickFn(_pickedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: (_pickedImage == null)
              ? const NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4")
                  as ImageProvider
              : FileImage(File(_pickedImage!.path)),
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        TextButton.icon(
          onPressed: (() {
            _pickImage();
          }),
          icon: const Icon(Icons.image),
          label: const Text("Add Image"),
        ),
      ],
    );
  }
}
