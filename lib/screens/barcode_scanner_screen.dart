import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:phytosvit/widgets/document_widget.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiBarcodeScanner(
        hideGalleryButton: true,
        appBarBuilder: null,
        bottomSheetBuilder: null,
        hideSheetTitle: true,
        hideSheetDragHandler: true,
        fit: BoxFit.fill,
        onDetect: (BarcodeCapture barcodeCapture) {
          if (barcodeCapture.barcodes.isNotEmpty) {
            final String? scannedValue = barcodeCapture.barcodes.first.rawValue;
            final BarcodeFormat barcodeType =
                barcodeCapture.barcodes.first.format;

            if (scannedValue != null &&
                (barcodeType == BarcodeFormat.ean13 ||
                    barcodeType == BarcodeFormat.qrCode)) {
              final ModalRoute? currentRoute = ModalRoute.of(context);

              if (currentRoute != null &&
                  currentRoute.settings.arguments == 'fromDocumentWidget') {
                Navigator.pop(context, scannedValue);
              } else {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DocumentWidget(
                    barcodes: [
                      {scannedValue: 1}
                    ],
                  ),
                ));
              }
            }
          }
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
      ),
    );
  }
}
