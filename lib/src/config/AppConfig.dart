import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Appconfig extends StatefulWidget {

  const Appconfig({Key? key}) : super(key: key);

  @override
  State<Appconfig> createState() => AppconfigState();
}

class AppconfigState extends State<Appconfig> with ChangeNotifier{
  //Các thuộc tính nhận giá trị config ở đây
  String url = "";

  //Cử tri
  String changePwd = "", getInforBeforeRegister = "";
  //Ứng cử viên
  //Cán bộ

  // --- Tài khoản
   String login = "", logout = "",
      verifyOtp = "", SendOTP_fotgotPwd = "",
      verifyOtpAfterLogin = "", checkLogined = "",
       renewtoken ="", checkUserEmail ="",
       SetPwdBasedOnEmail="",ResendOtp ="";

  //Khởi tạo
  @override
  void initState() {
    super.initState();
    loadApi_json();

    print("Duong dan: ${url}");
  }

  AppconfigState() {
    loadApi_json();
  }
  //Đọc nội dung config từ file json
  Future<void> loadApi_json() async {
    try {
      String data = await rootBundle.loadString('assets/api.json');
      Map<String, dynamic> jsonData = jsonDecode(data);

      url = jsonData['url'] ?? "";
      changePwd = jsonData['Voter']['changePwd'] ?? "";
      getInforBeforeRegister = jsonData['Voter']['getInforBeforeRegister'] ?? "";
      logout = jsonData['Account']['logout'] ?? "";
      login = jsonData['Account']['login'] ?? "";
      verifyOtp = jsonData['Account']['verifyOtp'] ?? "";
      SendOTP_fotgotPwd = jsonData['Account']['SendOTP_fotgotPwd'] ?? "";
      verifyOtpAfterLogin = jsonData['Account']['verifyOtpAfterLogin'] ?? "";
      checkLogined = jsonData['Account']['checkLogined'] ?? "";
      renewtoken = jsonData['Account']['renewtoken'] ?? "";
      checkUserEmail = jsonData['Account']['checkUserEmail'] ?? "";
      ResendOtp = jsonData['Account']['ResendOtp'] ?? "";
      SetPwdBasedOnEmail = jsonData['User']['SetPwdBasedOnEmail'] ?? "";

      print("Loaded URL: $url");
      notifyListeners();
    } catch (e) {
      print("Error loading API JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;

  late AppconfigState _appconfig; // Sử dụng 'late' để khai báo trường _appconfig

  AppConfigService._internal();

  void setAppConfig(AppconfigState appconfig) {
    _appconfig = appconfig;
  }

  String get url => _appconfig.url;
  String get changePwd => _appconfig.changePwd;
  String get getInforBeforeRegister => _appconfig.getInforBeforeRegister;
  String get logout =>_appconfig.logout;
  String get login => _appconfig.login;
  String get verifyOtp => _appconfig.verifyOtp;
  String get SendOTP_fotgotPwd => _appconfig.SendOTP_fotgotPwd;
  String get verifyOtpAfterLogin => _appconfig.verifyOtpAfterLogin;
  String get checkLogined => _appconfig.checkLogined;
  String get renewtoken => _appconfig.renewtoken;
  String get checkUserEmail => _appconfig.checkUserEmail;
  String get ResendOtp => _appconfig.ResendOtp;
  String get SetPwdBasedOnEmail => _appconfig.SetPwdBasedOnEmail;
}
