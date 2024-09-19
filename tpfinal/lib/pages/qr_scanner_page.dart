import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300, // Defines the visible scan zone
            ),
          ),
          Positioned(
            // Define the position of your custom scan zone overlay for visual reference
            left: MediaQuery.of(context).size.width / 2 - 150, // Center horizontally
            top: MediaQuery.of(context).size.height / 2 - 150, // Position vertically
            child: const SizedBox(
              width: 300,
              height: 300,
            ),
          ),
          if (result != null)
            Center(
              child: FutureBuilder<ProductResultV3>(
                future: OpenFoodAPIClient.getProductV3(
                  ProductQueryConfiguration(
                    result!.code!,
                    version: ProductQueryVersion.v3,
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    ProductResultV3 product = snapshot.data!;
                    Product? scannedProduct = product.product;
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        scannedProduct?.productName ?? 'No name',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          result = scanData;
          isScanning = false; // Temporarily stop scanning after a successful scan

          // Resume scanning after a delay (e.g., 2 seconds)
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isScanning = true;
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
