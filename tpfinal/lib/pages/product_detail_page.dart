import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.onExitCallback, required this.id});
  final VoidCallback onExitCallback;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            onExitCallback(); // Correctly call the callback to resume scanning
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Text(id),
      ),
    );
  }
}
