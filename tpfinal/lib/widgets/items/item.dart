import 'package:flutter/material.dart';
import 'package:tpfinal/util/app_constants.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.item,
    required this.detail,
    required this.pop_up,
    this.additem,
    this.isCard = false,
    this.onCheck,
    this.onDelete,
    this.isChecked = false,
  });

  final dynamic item;
  final bool detail;
  final bool? pop_up;
  final dynamic additem;
  final bool isCard;
  final VoidCallback? onCheck;
  final VoidCallback? onDelete;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    if (isCard) {
      return _buildCard(context);
    }

    return InkWell(
      onTap: _handleTap(context),
      child: Container(
        margin: !detail
            ? const EdgeInsets.only(left: 20, top: 20, right: 100)
            : const EdgeInsets.only(),
        width: !detail
            ? MediaQuery.of(context).size.width * 0.55
            : MediaQuery.of(context).size.width * 0.8,
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
                    !detail ? "${item.data()["category"]}" : "${item["category"]}",
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
                    !detail ? "${item.data()["name"]}" : "${item["name"]}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Caveat',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    !detail
                        ? "Add by ${item.data()["addBy"]}"
                        : "Add by ${item["addBy"]}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback _handleTap(BuildContext context) {
    return () {
      if (pop_up != null) {
        if (pop_up!) {
          showDataAlert(context, item, "showItem", null, null);
        } else if (!pop_up!) {
          if (additem != null) additem(item.id);
        }
      }
    };
  }

  Widget _buildCard(BuildContext context) {
    final data = detail ? item : item.data();
    final imageUrl = data['image'] ?? "https://firebasestorage.googleapis.com/v0/b/tpfinal-mobil.appspot.com/o/no-photo.png?alt=media&token=bcec8e74-1b42-431d-a7a0-8002102b7fe4";
    final name = data['name'] ?? "Unknown Item";
    final category = data['category'] ?? "General";
    
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
                Expanded(
                  child: Center(
                    child: Opacity(
                      opacity: isChecked ? 0.6 : 1.0,
                      child: Image.network(imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category,
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
