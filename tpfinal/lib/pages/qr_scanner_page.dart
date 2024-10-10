import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tpfinal/pages/product_detail_page.dart';
import 'package:tpfinal/util/create_route.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;
  bool isScanning = true;
  bool flash_on = false;
  double _linePosition = 0.0;


  @override
  void initState() {
    super.initState();
    _startLineAnimation();
  }

  void _startLineAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _linePosition = _linePosition == 0.0 ? 1.0 : 0.0;
        });
        _startLineAnimation();
      }
    });
  }

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
              borderColor: const Color(0xFF00AD48),
              borderLength: 30,
              borderWidth: 2.5,
              cutOutSize: 300,
            ),
            cameraFacing: CameraFacing.back,
          ),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 1000),
                    top: _linePosition == 0.0 ? 0 : 300,
                    child: Container(
                      width: 300,
                      height: 2,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    !flash_on ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.toggleFlash();
                    setState(() {
                      flash_on = !flash_on;
                    });
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.cameraswitch,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.flipCamera();
                  },
                ),
              ],
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
          isScanning = false;

          if (result != null) {
            // Navigate to the new page and pass the callback

            if (result?.code != null) {
              _getProduct(result!.code!).then((product) {
                Navigator.of(context).push(
                  createRouteToItemDetail(
                    ProductDetailPage(
                      onExitCallback: () {
                        setState(() {
                          isScanning = true;
                          controller.resumeCamera();
                        });
                      },
                      product: product,
                    ),
                  ),
                );
                controller.pauseCamera();
              }).catchError((error) {
                // Handle error
                print('Error fetching product: $error');
              });
            }
          }
        });
      }
    });
  }

  Future<Product> _getProduct(String barcode) async {
    ProductQueryConfiguration config = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
    );

    ProductResultV3 product = await OpenFoodAPIClient.getProductV3(config);
    if (product.status == 'success') {
      return product.product!;
    } else {
      throw Exception('Failed to fetch product data');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
