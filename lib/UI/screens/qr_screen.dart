import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:url_launcher/url_launcher.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await controller?.pauseCamera();
      await launch(url);
      await controller?.resumeCamera();
      //await controller?.resumeCamera();
      // Navigator.of(context).pop();
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => QRViewExample(),
      // ));
      setState(() {
        result = null;

        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QRViewExample(),
        ));
        //controller?.resumeCamera();
      });
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  bool _isURL(String text) {
    return text.startsWith("http://") ||
        text.startsWith("https://") ||
        text.startsWith("www.");
  }

  Widget buildResult() {
    if (result != null) {
      if (_isURL('${result!.code}')) {
        controller?.pauseCamera();
        _launchURL('${result!.code}');
        controller?.resumeCamera();
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Redirigiendo...'),
        );
      } else {
        //return Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}');
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No es una url valida'),
        );
      }
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Escanea un código QR'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              var isFlashOn1 = '${snapshot.data}';
                              bool isFlashOn;
                              if (isFlashOn1 == 'false') {
                                isFlashOn = false;
                              } else {
                                isFlashOn = true;
                              }
                              return IconButton(
                                icon: Icon(
                                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                                  color: isFlashOn
                                      ? const Color(0xFFFE412A)
                                      : Colors.black,
                                ),
                                onPressed: () async {
                                  await controller?.toggleFlash();
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              bool isFrontFacing =
                                  '${describeEnum(snapshot.data!)}' == "front";

                              return IconButton(
                                icon: Icon(
                                  Icons.switch_camera,
                                  color: isFrontFacing
                                      ? const Color(0xFFFE412A)
                                      : Colors.black,
                                ),
                                onPressed: () async {
                                  await controller?.flipCamera();
                                  setState(() {});
                                },
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.home, color: Colors.black),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //         },
                  //         child: const Text('pause',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //         child: const Text('resume',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  ////////////////////////////////
                  // if (result != null)
                  //   Text(
                  //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // else
                  //   const Text('Scan a code'),
                  //buildResult(),
                ],
              ),
            ),
          ),
          Expanded(flex: 6, child: _buildQrView(context)),
          Expanded(
              flex: 0,
              child: FittedBox(
                fit: BoxFit.contain,
                child: buildResult(),
              )),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color(0xFFFE412A),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
