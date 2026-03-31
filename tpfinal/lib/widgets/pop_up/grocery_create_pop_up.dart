import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/pages/add_items.dart';
import 'package:tpfinal/util/app_constants.dart';

class GroceryCreatePopUp extends StatefulWidget {
  const GroceryCreatePopUp({super.key});

  @override
  State<GroceryCreatePopUp> createState() => _GroceryCreatePopUpState();
}

class _GroceryCreatePopUpState extends State<GroceryCreatePopUp> {
  final Grocery _grocery = Grocery("", "", "icon_1.png", "User", []);
  int _selectedIconIndex = 1;
  bool _isSaving = false;
  bool _showIcons = false;

  void _addItem(String id) {
    setState(() {
      _grocery.addItem(ObjectItem(id, 1, "noDone"));
    });
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    int maxLines = 1,
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
          maxLines: maxLines,
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
            width: MediaQuery.of(context).size.width * 0.9,
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
                      "Create New List",
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
                const SizedBox(height: AppConstants.spacingSmall),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _showIcons = !_showIcons),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.secondaryGreen,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(color: AppConstants.primaryGreen, width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/icons/${_grocery.icon}',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Change Icon",
                            style: TextStyle(fontSize: 10, color: AppConstants.primaryGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showIcons) ...[
                  const SizedBox(height: AppConstants.spacingMedium),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 14,
                      itemBuilder: (context, index) {
                        final iconName = "icon_${index + 1}.png";
                        final isSelected = _selectedIconIndex == index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIconIndex = index + 1;
                              _grocery.icon = iconName;
                              _showIcons = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppConstants.primaryGreen : AppConstants.secondaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset('assets/images/icons/$iconName'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.spacingLarge),
                _buildTextField(
                  label: "List Name",
                  hint: "Weekly Grocery, Party, etc.",
                  onChanged: (text) => setState(() => _grocery.name = text),
                ),
                const SizedBox(height: AppConstants.spacingMedium),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Store",
                        hint: "Supermarket name",
                        onChanged: (text) => setState(() => _grocery.store = text),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: "Description",
                        hint: "Short note",
                        onChanged: (text) => setState(() => _grocery.description = text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Items",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, AddItems.routeName, arguments: _addItem),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add Item"),
                      style: TextButton.styleFrom(foregroundColor: AppConstants.primaryGreen),
                    ),
                  ],
                ),
                if (_grocery.items!.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _grocery.items!.length,
                      itemBuilder: (context, index) {
                        final itemId = _grocery.items![index].id;
                        return FutureBuilder(
                          future: FirebaseFirestore.instance.collection("globalListItem").doc(itemId).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox(width: 80);
                            final data = snapshot.data!.data();
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: AppConstants.secondaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  data?['image'] != null 
                                    ? Image.network(data!['image'], height: 40, width: 40, fit: BoxFit.contain)
                                    : const Icon(Icons.shopping_bag, color: AppConstants.primaryGreen),
                                  Text(
                                    data?['name'] ?? "Item",
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
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
                    onPressed: _isSaving || _grocery.name.isEmpty
                        ? null
                        : () async {
                            setState(() => _isSaving = true);
                            await _saveGrocery();
                            Navigator.pop(context);
                          },
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            "Create List",
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

  Future<void> _saveGrocery() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    // Fallback if username retrieval takes too long
    String username = "User";
    try {
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      username = userDoc.data()?["username"] ?? "User";
    } catch (_) {}

    final docRef = await FirebaseFirestore.instance.collection("epiceries").add({
      "name": _grocery.name,
      "createBy": username,
      "description": _grocery.description,
      "store": _grocery.store,
      "icon": _grocery.icon,
      "items": _grocery.items!.map((e) => {
        "id": e.id,
        "quantity": e.quantity,
        "status": e.status,
      }).toList(),
    });

    await FirebaseFirestore.instance
        .collection("familles")
        .doc(docRef.id)
        .collection("membres")
        .doc(uid)
        .set({"id": uid});

    await FirebaseFirestore.instance.collection("epicerieID").add({"id": docRef.id});
  }
}
