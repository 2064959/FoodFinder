import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/util/back_up_database.dart';
import 'package:tpfinal/widgets/grocery/grocery_list.dart';
import 'package:tpfinal/widgets/grocery/your_groceries_logo.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class YourGoceries extends StatefulWidget {
  const YourGoceries({
    super.key,
  });

  @override
  State<YourGoceries> createState() => _YourGoceriesState();
}

class _YourGoceriesState extends State<YourGoceries> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MyGroceries>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: AppConstants.spacingMedium),
            const YourGroceriesLogo(),
            const SizedBox(height: AppConstants.spacingMedium),
            _buildCreateListCard(),
            const SizedBox(height: AppConstants.spacingLarge),
            const Text(
              "Your Lists",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppConstants.black87,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            GroceryList(null, true),
            const SizedBox(height: AppConstants.spacingXLarge),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDataAlert(context, null, "createGrocery", _refresh, null),
        backgroundColor: AppConstants.primaryGreen,
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label: const Text("New List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCreateListCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryGreen, Color(0xFF00D45B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Organize your shopping",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Create a list and never forget an item again.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => showDataAlert(context, null, "createGrocery", _refresh, null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppConstants.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
            child: const Text("Start"),
          ),
        ],
      ),
    );
  }
}
