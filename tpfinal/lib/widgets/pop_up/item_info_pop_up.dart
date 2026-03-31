import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tpfinal/pages/add_to_grocery.dart';
import 'package:tpfinal/util/app_constants.dart';

class ItemInfoPopUp extends StatelessWidget {
  const ItemInfoPopUp({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final data = item.data();
    final name = data["name"] ?? "Unknown Item";
    final addBy = data["addBy"] ?? "Unknown User";
    final category = data["category"] ?? "General";
    final imageUrl = data["image"] ?? "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4";

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.mediumGrey),
                ),
              ),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.black87,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: AppConstants.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 16, color: AppConstants.darkGrey),
                  const SizedBox(width: 4),
                  Text(
                    "Added by $addBy",
                    style: const TextStyle(color: AppConstants.darkGrey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AddToGrocery.routeName, arguments: item.id);
                  },
                  child: const Text(
                    "Add to List",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
