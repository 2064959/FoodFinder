// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';
import 'package:tpfinal/util/app_constants.dart';

class GroceryShow extends StatelessWidget {
  const GroceryShow({
    super.key,
    required this.grocery,
    required this.refresh,
    required this.pop_up,
    this.item,
  });

  final Grocery grocery;
  final VoidCallback refresh;
  final bool pop_up;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    var pourcentage =
        (grocery.items?.where((item) => item.stat == 'done').length ?? 0) *
            100 /
            (grocery.items?.length ?? 0);
    return InkWell(
      onTap: () {
        if (pop_up) {
          showDataAlert(context, grocery, "showGrocery", refresh, null);
        } else {
          if (grocery.items!.where((element) => element.id == item).isNotEmpty) {
            grocery.items!.where((element) => element.id == item).first.quantity++;
          } else {
            grocery.items!.add(ObjectItem(item, 1, "noDone"));
          }
          FirebaseFirestore.instance
              .collection("epiceries")
              .doc(grocery.id)
              .update({"items": convertItemsToMap(grocery.items!)});
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.secondaryGreen,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Image.asset(
                'assets/images/icons/${grocery.icon}',
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_basket, color: AppConstants.primaryGreen),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grocery.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (grocery.store != null && grocery.store!.isNotEmpty)
                    Text(
                      "Store: ${grocery.store}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (grocery.description != null && grocery.description!.isNotEmpty)
                    Text(
                      grocery.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.mediumGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.list, size: 14, color: AppConstants.mediumGrey),
                      const SizedBox(width: 4),
                      Text(
                        "${grocery.items?.length ?? 0} items",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppConstants.darkGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () => showDataAlert(context, grocery, "shareGrocery", refresh, null),
                        child: const Row(
                          children: [
                            Icon(Icons.person_add_alt_1, size: 14, color: AppConstants.primaryGreen),
                            SizedBox(width: 4),
                            Text(
                              "Share",
                              style: TextStyle(
                                fontSize: 11,
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.bold,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  pourcentage == 100 ? "Done" : "${pourcentage.toInt()}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: pourcentage == 100 ? AppConstants.primaryGreen : AppConstants.primaryOrange,
                  ),
                ),
                const SizedBox(height: 4),
                Image.asset(
                  pourcentage == 100 ? 'assets/images/done.png' : 'assets/images/notDone.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
