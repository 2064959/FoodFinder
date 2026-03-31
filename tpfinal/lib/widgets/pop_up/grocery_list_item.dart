// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/model/grocery.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/widgets/home/product_card.dart';
import 'package:tpfinal/widgets/common/shimmer_loading.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class GroceryItemsList extends StatelessWidget {
  const GroceryItemsList({
    super.key,
    required this.refresh,
    required this.item,
    required this.pop_up,
  });
  final VoidCallback refresh;
  final Grocery item;
  final bool pop_up;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("epiceries").doc(item.id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error loading items"));
        }

        final myItems = snapshot.data!["items"] as List<dynamic>;
        final List<ObjectItem> listItem = myItems
            .map((e) => ObjectItem(e["id"], e["quantity"], e["status"]))
            .toList();

        return SizedBox(
          height: 220, // Increased height to comfortably fit cards and labels
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
            itemCount: myItems.length,
            itemBuilder: (context, index) {
              final itemId = myItems[index]["id"];
              final status = myItems[index]["status"];
              final isChecked = status == "done";

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("globalListItem")
                    .doc(itemId)
                    .get(),
                builder: (context, itemSnapshot) {
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: ProductCardShimmer(),
                    );
                  }

                  final onCheck = () {
                    final newStatus = isChecked ? "notDone" : "done";
                    listItem[index].done(newStatus);
                    FirebaseFirestore.instance
                        .collection("epiceries")
                        .doc(item.id)
                        .update({"items": convertItemsToMap(listItem)});
                    refresh();
                  };

                  final onDelete = () {
                    listItem.removeAt(index);
                    FirebaseFirestore.instance
                        .collection("epiceries")
                        .doc(item.id)
                        .update({"items": convertItemsToMap(listItem)});
                    refresh();
                  };

                  if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                    return _buildOpenFoodCard(context, itemId, isChecked, onCheck, onDelete);
                  }

                  final productData = itemSnapshot.data!.data() as Map<String, dynamic>;
                  final product = Product(
                    barcode: itemId,
                    productName: productData['name'] ?? 'Unknown',
                    brands: productData['brands'] ?? productData['category'] ?? 'Unknown',
                    imageFrontUrl: productData['image'],
                  );

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ProductCard(
                      product: product,
                      onPress: () {}, // Detail page if needed?
                      isChecked: isChecked,
                      onCheck: onCheck,
                      onDelete: onDelete,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOpenFoodCard(BuildContext context, String itemId, bool isChecked, VoidCallback onCheck, VoidCallback onDelete) {
    return FutureBuilder(
      future: load(itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProductCardShimmer(),
          );
        }
        final article = snapshot.data!;
        final product = Product(
          barcode: itemId,
          productName: article.nom,
          brands: article.categorie,
        );

        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ProductCard(
            product: product,
            onPress: () {},
            isChecked: isChecked,
            onCheck: onCheck,
            onDelete: onDelete,
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(right: 16),
          child: ProductCardShimmer(),
        ),
      ),
    );
  }
}
