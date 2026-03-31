import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/widgets/pop_up/grocery_list_item.dart';

class GroceryInfoPopUp extends StatelessWidget {
  const GroceryInfoPopUp({
    super.key,
    required this.item,
    required this.refresh,
  });

  final Grocery item;
  final dynamic refresh;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          // Reduced height for horizontal carousel
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
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                decoration: const BoxDecoration(
                  color: AppConstants.secondaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusLarge),
                    topRight: Radius.circular(AppConstants.radiusLarge),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "List Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppConstants.mediumGrey),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          ),
                          child: Image.asset(
                            'assets/images/icons/${item.icon}',
                            height: 50,
                            width: 50,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.black87,
                                ),
                              ),
                              if (item.store != null && item.store!.isNotEmpty)
                                Text(
                                  "Store: ${item.store}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.darkGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
                      child: Text(
                        "Items to buy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    GroceryItemsList(
                      item: item,
                      refresh: refresh,
                      pop_up: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                    ),
                    onPressed: () {
                      // Action to add item
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add Item",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
