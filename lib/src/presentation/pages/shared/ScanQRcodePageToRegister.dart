import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/presentation/pages/voter/UserInformationAfterScanningTheCode_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
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
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _scannedData = 'Đang chờ xử lý';
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    if (!_isScanning) return; // Ngăn việc quét tiếp nếu đang xử lý

                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      setState(() {
                        _scannedData = barcode.rawValue;
                        _isScanning = false; // Dừng việc quét trong khi đợi phản hồi từ server
                      });

                      //Nếu đúng mã qr thì chuyển qua luôn
                      Voterinformationafterscaningmodel? voter = await voterRepository.DisplayUserInformationAfterScanning(context, _scannedData ?? '');
                      if(voter != null){
                        print("Xác nhận có hồ sơ");
                        CheckID_user = true;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => UserProfilePage(voter: voter))
                        ).then((_) {
                          setState(() {
                            _isScanning = true; // Cho phép quét lại khi quay về màn hình
                          });
                        });
                      }else{
                        print("Xác nhận không có hồ sơ");
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Lỗi 400",
                          text: 'Không tìm thấy mã cử tri hoặc cử tri đã có tài khoản rồi',
                          onConfirmBtnTap: () async {
                            print("-----> Không tiìm thaays đó rõ chưa");
                            setState(() {
                              _isScanning = true; // Cho phép quét lại nếu không tìm thấy thông tin
                            });
                            Navigator.pop(context);
                          },
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