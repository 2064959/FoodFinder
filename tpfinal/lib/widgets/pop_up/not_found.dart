import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tpfinal/util/app_constants.dart';

class NotFoundPopUp extends StatelessWidget {
  const NotFoundPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          width: MediaQuery.of(context).size.width * 0.8,
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
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppConstants.secondaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off,
                  size: 60,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              const Text(
                "Product Not Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.black87,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              const Text(
                "We couldn't find this item in our database.\nYou can try scanning again or add it manually.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppConstants.darkGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXLarge),
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Try Again",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
