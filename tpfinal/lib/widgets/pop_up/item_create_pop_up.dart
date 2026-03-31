import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/widgets/items/item_picker_image.dart';

class ItemCreatePopUp extends StatefulWidget {
  const ItemCreatePopUp({
    super.key,
  });

  @override
  State<ItemCreatePopUp> createState() => _ItemCreatePopUpState();
}

class _ItemCreatePopUpState extends State<ItemCreatePopUp> {
  final ArticleShared _item = ArticleShared(
    "",
    "",
    "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4",
    "",
    Timestamp.now(),
  );

  XFile? _myUserImageFile;
  bool _isSaving = false;

  void _myPickImage(XFile pickedImage) {
    setState(() {
      _myUserImageFile = pickedImage;
    });
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppConstants.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppConstants.secondaryGreen.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create New Item",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppConstants.mediumGrey),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppConstants.spacingMedium),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppConstants.secondaryGreen,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        child: _myUserImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                child: Image.file(File(_myUserImageFile!.path), fit: BoxFit.cover),
                              )
                            : const Icon(Icons.image, size: 40, color: AppConstants.primaryGreen),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppConstants.primaryGreen,
                          radius: 18,
                          child: UserImagePicker(_myPickImage),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                _buildTextField(
                  label: "Item Name",
                  hint: "e.g. Organic Milk",
                  onChanged: (text) => setState(() => _item.setNom(text)),
                ),
                const SizedBox(height: AppConstants.spacingMedium),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Author",
                        hint: "Your Name",
                        onChanged: (text) => setState(() => _item.setAddBy(text)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: "Category",
                        hint: "Dairy, Fruit, etc.",
                        onChanged: (text) => setState(() => _item.setCategorie(text)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen,
                      disabledBackgroundColor: AppConstants.mediumGrey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                    ),
                    onPressed: _isSaving || _item.nom.isEmpty || _item.addBy.isEmpty || _item.categorie.isEmpty
                        ? null
                        : () async {
                            setState(() => _isSaving = true);
                            _item.setDate(Timestamp.now());
                            await _saveImage();
                            Navigator.pop(context);
                          },
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            "Save Product",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage() async {
    if (_myUserImageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('${_myUserImageFile.hashCode}.jpg');

      await ref.putFile(File(_myUserImageFile!.path));

      final url = await ref.getDownloadURL();
      await _saveItem(ArticleShared(_item.addBy, _item.categorie, url, _item.nom, _item.date));
    } else {
      await _saveItem(_item);
    }
  }

  Future<void> _saveItem(ArticleShared item) async {
    await FirebaseFirestore.instance.collection('globalListItem').add(item.toMap());
  }
}
