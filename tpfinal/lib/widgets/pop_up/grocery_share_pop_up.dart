import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/util/app_constants.dart';

class GrocerySharePopUp extends StatefulWidget {
  final Grocery grocery;

  const GrocerySharePopUp({
    super.key,
    required this.grocery,
  });

  @override
  State<GrocerySharePopUp> createState() => _GrocerySharePopUpState();
}

class _GrocerySharePopUpState extends State<GrocerySharePopUp> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);
    final results = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    setState(() {
      _searchResults = results.docs;
      _isSearching = false;
    });
  }

  Future<void> _addUserToList(String uid) async {
    await FirebaseFirestore.instance
        .collection('familles')
        .doc(widget.grocery.id)
        .collection('membres')
        .doc(uid)
        .set({'id': uid});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Share List",
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
              const Text(
                "Invite others to collaborate",
                style: TextStyle(color: AppConstants.darkGrey, fontSize: 14),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              TextField(
                controller: _searchController,
                onChanged: _searchUsers,
                decoration: InputDecoration(
                  hintText: "Search user by email...",
                  prefixIcon: const Icon(Icons.search, color: AppConstants.primaryGreen),
                  filled: true,
                  fillColor: AppConstants.secondaryGreen.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Expanded(
                child: _isSearching
                  ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryGreen))
                  : _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text("No users found", style: TextStyle(color: AppConstants.mediumGrey)))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index].data() as Map<String, dynamic>;
                          final uid = _searchResults[index].id;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppConstants.secondaryGreen,
                              child: Text((user['username']?[0] ?? "U").toUpperCase(), style: const TextStyle(color: AppConstants.primaryGreen)),
                            ),
                            title: Text(user['username'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(user['email'] ?? "", style: const TextStyle(fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppConstants.primaryGreen),
                              onPressed: () => _addUserToList(uid),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
