import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:retail_project/Core/Db/database.dart';
import 'package:retail_project/Core/Theme/color_pallets.dart';
import 'package:retail_project/Feature/Auth/Provider/qr_result_provider.dart';
import 'package:retail_project/Feature/Home/Navbar.dart';
import '../Auth/Screen/BottamNavigation_screen.dart';

class QRcode extends StatefulWidget {
  const QRcode({super.key});

  @override
  State<QRcode> createState() => _QRState();
}

class _QRState extends State<QRcode> {
  Barcode? result;
  QRViewController? _qrViewController;
  final GlobalKey globalKey = GlobalKey(debugLabel: "QR");
  SecureStorageService secureStorageService = SecureStorageService();

  late QrResultProvider qrResultProvider;

  @override
  void initState() {
    qrResultProvider = QrResultProvider();

    super.initState();
  }

  // qrData() async {
  //   if (result != null) {
  //     qrResultProvider.Qrresult(context, result.toString());
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (_) => Navbar()));
  //   }
  // }
  String? response;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController!.pauseCamera;
    }
    _qrViewController!.resumeCamera();
  }

  showAlertBox() {
    return Container(
        child: Center(
            child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("QRScan Result"),
            content: Text(response.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const BottamNavigationbar()));
                },
                child: Container(
                  color: ColorPallets.primaryColor,
                  padding: const EdgeInsets.all(14),
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
      },
      child: const Text("Show alert Dialog box"),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallets.secondaryColor,
      body: Consumer<QrResultProvider>(
        builder: (_, ref, __) {
          return Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              // Expanded(
              //   flex: 1,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                 onPressed: () async {
              //                   ref.Qrresult(context, result.toString());
              //                 },
              //                 style: ElevatedButton.styleFrom(
              //                     backgroundColor: ColorPallets.primaryColor),
              //                 child: Text('Next',
              //                     style: GoogleFonts.poppins(
              //                         color: ColorPallets.secondaryColor,
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.w500)),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          );
        },
      ),
    );

// RaidedButton is deprecated and should not be used
  }

  Widget _buildQrView(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    var scanArea = (size.width < 600 || size.height < 600) ? 250.0 : 300.0;

    return QRView(
      key: globalKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (controller, p) =>
          _onPermissionSet(context, controller, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      qrResultProvider.Qrresult(context, result.toString());
      controller.stopCamera();
    });
    // if (result != null) {
    //   qrResultProvider.Qrresult(context, result.toString()).then((route) =>
    //       Navigator.push(context, MaterialPageRoute(builder: (_) => Navbar())));
    // }
  }

  void _onPermissionSet(
      BuildContext context, QRViewController controller, bool isAllowed) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $isAllowed');
    if (!isAllowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }
}
