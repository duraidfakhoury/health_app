import 'package:flutter/material.dart';
import 'package:flutter_health_app/constants/colors.dart';
import 'package:flutter_health_app/view/auth/auth_cubit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:dio/dio.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class _QRViewState extends State<QRViewPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrData;
  String? displayMessage; // To display the result message on the screen

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Your Code'),
        backgroundColor: AppColors.purplelight,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.purple,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.purplelight,
              child: Center(
                // Display the appropriate message (You can consume it or You are allergic to this food)
                child: Text(
                  displayMessage != null
                      ? displayMessage!
                      : 'Scan the code to get the result',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      backgroundColor: AppColors.purplelight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData.code;
        controller.pauseCamera();
        sendFoodIdToApi(qrData);
      });
    });
  }

  Future<void> sendFoodIdToApi(var foodURL) async {
    Dio dio = Dio();
    int? userId = AuthDartCubit.x;
    try {
      final url = "$foodURL/confirm/";
      final data = {
        'user_id': userId,
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = response.data;
        // Check the result field in the response
        if (responseData['data']['result'] == true) {
          // Show confirmation message in AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Scan Result"),
                content: const Text("You can consume this food."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Show warning message in AlertDialog
          List sensitiveContents = responseData['data']['sensitive_contents'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Scan Result"),
                content: Text("You are allergic to this food.${sensitiveContents.join(', ')}"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Show error message in AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("An error occurred while scanning the food."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show error message in AlertDialog when an error occurs during the request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
