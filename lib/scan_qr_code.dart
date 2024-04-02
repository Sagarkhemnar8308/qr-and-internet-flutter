import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key}) : super(key: key);

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> with WidgetsBindingObserver {
  String qrr = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        qrr = "";
      });
    }
  }

  Future<void> scanQr() async {
    try {
      final qrcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );

      if (!mounted || qrcode == '-1') {
        setState(() {
          qrr = "Failed to read QR code.";
        });
        return;
      }

      setState(() {
        qrr = qrcode;
      });

      _launchUrl();
    } on PlatformException {
      setState(() {
        qrr = "Failed to read QR code.";
      });
    }
  }

  Future<void> _launchUrl() async {
    setState(() {
      isLoading = true;
    });
    if (!await launch(qrr)) {
      setState(() {
        isLoading = false;
        throw 'Could not launch $qrr';
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 30),
            // InkWell(
            //   onTap: () {
                
            //   },
            //   child:isLoading?const CircularProgressIndicator():
            //    Text(
            //     qrr,
            //     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
           // ),
            const SizedBox(height: 30),
            if (!isLoading)
              ElevatedButton(
                onPressed: scanQr,
                child: const Text("Scan Code"),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
