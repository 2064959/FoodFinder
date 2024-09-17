import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class ItemNew extends StatelessWidget {
  const ItemNew({
    super.key,
    required this.item,
    required this.action,
  });

  final dynamic item;
  final Enum action;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductResultV3>(
      future: _fetchProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          ProductResultV3 product = snapshot.data!;
          Product? result = product.product;
          if (kDebugMode) {
            print(result);
          }
           
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result!.productName ?? 'No name',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: Color(0xFF00AD48),
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Text('No data');
        }
      },
    );
  }

  Future<ProductResultV3> _fetchProduct() async {
    ProductQueryConfiguration config = ProductQueryConfiguration(
      '5449000131805',
      version: ProductQueryVersion.v3,
      language: OpenFoodFactsLanguage.GERMAN
    );
    return await OpenFoodAPIClient.getProductV3(config);
  }
}
