import 'package:flutter/material.dart';
import 'package:tpfinal/model/item.dart';
import 'package:tpfinal/util/app_constants.dart';

class OpenFoodItemSimple extends StatelessWidget {
  const OpenFoodItemSimple({
    super.key,
    required this.context,
    required this.snapshot,
    this.isCard = false,
    this.onCheck,
    this.onDelete,
    this.isChecked = false,
  });

  final BuildContext context;
  final AsyncSnapshot<Article> snapshot;
  final bool isCard;
  final VoidCallback? onCheck;
  final VoidCallback? onDelete;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData) return const SizedBox.shrink();
    final article = snapshot.data!;

    if (isCard) {
      return _buildCard(context, article);
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.085,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 179, 179, 179),
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.categorie,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width * 0.55,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.nom,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Caveat',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  "Code: ${article.id}",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Article article) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isChecked ? AppConstants.secondaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: isChecked ? AppConstants.primaryGreen : AppConstants.lightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Center(
                    child: Icon(Icons.shopping_bag_outlined, size: 40, color: AppConstants.primaryGreen),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.nom,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  article.categorie,
                  style: const TextStyle(fontSize: 10, color: AppConstants.mediumGrey),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close, size: 18, color: AppConstants.mediumGrey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          Positioned(
            bottom: 4,
            right: 4,
            child: IconButton(
              onPressed: onCheck,
              icon: Icon(
                isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isChecked ? AppConstants.primaryGreen : AppConstants.mediumGrey,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
