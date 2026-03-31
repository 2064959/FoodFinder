import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tpfinal/util/app_constants.dart';

class OpenFoodItemPopUp extends StatelessWidget {
  const OpenFoodItemPopUp({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final name = item.productName ?? "Unknown Product";
    final imageUrl = item.imageFrontUrl ?? "";
    final nutriments = item.nutriments;
    final brands = item.brands ?? "Unknown Brand";

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.mediumGrey),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (imageUrl.isNotEmpty)
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.black87,
                        ),
                      ),
                      Text(
                        brands,
                        style: const TextStyle(color: AppConstants.darkGrey, fontSize: 14),
                      ),
                      const SizedBox(height: AppConstants.spacingLarge),
                      const Divider(),
                      const SizedBox(height: AppConstants.spacingMedium),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nutritional Information (per 100g)",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildNutrientRow(
                        label: "Energy",
                        value: "${nutriments?.energyKcal100g?.toStringAsFixed(0) ?? 'N/A'} kcal",
                        icon: Icons.bolt,
                        color: Colors.orange,
                      ),
                      _buildNutrientRow(
                        label: "Proteins",
                        value: "${nutriments?.proteins100g?.toStringAsFixed(1) ?? 'N/A'} g",
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                      _buildNutrientRow(
                        label: "Fat",
                        value: "${nutriments?.fat100g?.toStringAsFixed(1) ?? 'N/A'} g",
                        icon: Icons.opacity,
                        color: Colors.redAccent,
                      ),
                      _buildNutrientRow(
                        label: "Sugars",
                        value: "${nutriments?.sugars100g?.toStringAsFixed(1) ?? 'N/A'} g",
                        icon: Icons.cake,
                        color: Colors.purple,
                      ),
                      _buildNutrientRow(
                        label: "Salt",
                        value: "${nutriments?.salt100g?.toStringAsFixed(2) ?? 'N/A'} g",
                        icon: Icons.waves,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
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
                    "Back to scanner",
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

  Widget _buildNutrientRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.black87)),
        ],
      ),
    );
  }
}
