import 'dart:io';
import 'package:flutter/material.dart';
import 'package:votesecure/src/presentation/pages/voter/UserInformationAfterScanningTheCode_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/domain/repositories/Register_repository.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';

class QRScannerPage extends StatefulWidget {
  static const routeName = 'scan-qrcode-to-register';
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? _scannedData;
  final VoterRepository voterRepository = VoterRepository();
  bool CheckID_user = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: FittedBox(
          fit:BoxFit.fitWidth,
          child: Text(
            'Quét mã QR để nhận diện \n thông tin cử tri đăng ký',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.lightBlue, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: MobileScanner(
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      setState(() {
                        _scannedData = barcode.rawValue;
                      });

                      //Nếu đúng mã qr thì chuyển qua luôn
                      Voterinformationafterscaningmodel? voter = await voterRepository.DisplayUserInformationAfterScanning(context, _scannedData ?? '');
                      if(voter != null){
                        print("Xác nhận có hồ sơ");
                        CheckID_user = true;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => UserProfilePage(voter: voter))
                        );
                      }else{
                        print("Xác nhận không có hồ sơ");
                        Scaffold.of(context).showBottomSheet(
                            (context)  =>  SnackBar(
                            content: Text('Không tìm thấy thông tin người đăng ký'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }

                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  _scannedData ?? 'Đang chờ quét mã QR...',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}