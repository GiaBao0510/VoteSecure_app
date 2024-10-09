import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:votesecure/src/presentation/pages/cadre/HomCadre.dart';
import 'package:votesecure/src/presentation/pages/candidate/HomeCadidate.dart';
import 'package:votesecure/src/presentation/pages/shared/ErorrServer.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/pages/voter/HomeVoter.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';

class WorkWithOtpRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //Hàm thực hiện xác nhân mã otp sau khi đăng nhập
  Future VerificationOtpAfter(BuildContext context,verifyOtpModel verifyOtp) async{
    try{
      String uri = verifyOtpAfterLogin;
      print('path: $uri');

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode({
            "Email": verifyOtp.Email,
            "Phone": verifyOtp.Phone,
            "Otp": verifyOtp.Otp
          })
      );

      // Đóng dialog sau khi có phản hồi từ server
      Navigator.of(context).pop();

      final thongTinPhanHoi = jsonDecode(res.body);
      print(res.body);
      String message = thongTinPhanHoi['message'];

      //Nếu xác thực thành công thì lưu accessToken và refresh token vào thiết bị
      if (res.statusCode == 200) {
        print(' - Xác thực mã otp thành công');
        await _saveTokens(res);
        await _navigateToPage(context, thongTinPhanHoi);

      }else if(res.statusCode == 400 ){
        String message =  thongTinPhanHoi['message'];
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi xác thực mã Otp",
            text: message
        );
      }else {
        throw Exception(
            'Failed to load data. Status code: ${res.statusCode}');
      }
    }catch(e){
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is HttpException) {
        throw Exception('HTTP error: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('Bad response format');
      } else {
        throw Exception('Error occurred while fetching data: $e');
      }
    }
  }

  //Lưu totken
  Future<void> _saveTokens(http.Response res) async{
    //Lấy accesstoken và refreshtoken từ cookie
    final cookies = res.headers['set-cookie'];    //Lấy danh sách các toke từ cookie
    if(cookies != null){
      final cookieList = cookies.split('; ');       //Phân tách ra
      for(var cookie in cookieList){
        if(cookie.startsWith('accessToken=')){
          final accessToken = cookie;
          await _tokenRepository.storedAccessToken(accessToken);
        }else if(cookie.startsWith('refreshToken=')){
          final refreshToken = cookie;
          await _tokenRepository.storedAccessToken(refreshToken);
        }
      }
    }
  }

  //Kiểm tra vai trò người dùng rồi chuyển sang page dựa trên vai trò
  Future<void> _navigateToPage(BuildContext context, Map<String, dynamic> responseData) async {
    final accessToken = await _tokenRepository.getAccessToken();
    ProfileModel user = ProfileModel(SDT: 'null',HoTen: 'null',GioiTinh: 'null',Email:'null', DiaChi: 'null',HinhAnh: 'null',NgaySinh: DateTime.now(),TenDanToc: 'null');
    if (accessToken != null) {
      final decodedToken = JwtDecoder.decode(accessToken);

      final role = decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
      final email = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
      final phone =  decodedToken['SDT'];

      //Lưu thoông tin nguoie dung vào máy cục bộ
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('UserRole', role);
      await pref.setString('UserPhone', phone);
      await pref.setString('UserEmail', email);

      //Lấy thông tin người dùng dựa trên email
      String uri = GetPersonalInformationBasedOnEmail+email;
      print("Path: ${uri}");
      var res = await http.get(
          Uri.parse(uri),
          headers: {
            "Content-Type":"application/json",
            "Authorization": "Bearer $accessToken",
          },
      );
      print(res.body);
      final thongTinPhanHoi = jsonDecode(res.body);

      if(res.statusCode == 200){
        print("Lấy thông tin người dùng thành công");

        user = ProfileModel(
            HoTen: thongTinPhanHoi['data']['hoTen'],
            TenDanToc: thongTinPhanHoi['data']['tenDanToc'],
            NgaySinh: DateTime.parse(thongTinPhanHoi['data']['ngaySinh']),
            HinhAnh: thongTinPhanHoi['data']['hinhAnh'],
            DiaChi: thongTinPhanHoi['data']['diaChiLienLac'],
            GioiTinh: thongTinPhanHoi['data']['gioiTinh'],
            SDT: thongTinPhanHoi['data']['sdt'],
            Email: thongTinPhanHoi['data']['email']
        );

        // print("----- Thông tin người dùng ----------");
        // print('hoTen: ${user.HoTen}');
        // print('TenDanToc: ${user.TenDanToc}');
        // print('NgaySinh: ${user.NgaySinh}');
        // print('HinhAnh: ${user.HinhAnh}');
        // print('GioiTinh: ${user.GioiTinh}');
        // print('SDT: ${user.SDT}');
        // print('Email: ${user.Email}');
        // print('----------------------------------------');

        switch (role) {
          case "2":
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homecadidate()));
            break;
          case "5":
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  homeVoter(user: user,)));
            break;
          case "8":
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeCadre()));
            break;
          default:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const loginPages()));
            break;
        }
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginPages()));
    }
  }

  //Hàm thực hiện xác nhận mã otp trước khi đạt mật mã
  //Hàm thực hiện xác nhân mã otp sau khi đặt lai mật khẩu
  Future <bool> VerificationOtpWhenForgotPwd(BuildContext context,verifyOtpModel verifyOtpModel) async{
    try{
      String uri = verifyOtp;

      var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode({
            "Email": verifyOtpModel.Email,
            "Otp": verifyOtpModel.Otp
          })
      );

      final thongTinPhanHoi = jsonDecode(res.body);
      String message = thongTinPhanHoi['message'];
      //Nếu xác thực thành công thì lưu accessToken và refresh token vào thiết bị
      if(res.statusCode == 200){
        return true;
      }else if(res.statusCode == 400){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi xác thực mã Otp",
            text: message
        );
        return false;
      }
      else{
        throw Exception(
            'Failed to load data. Status code: ${res.statusCode}');
      }
    }catch(e){
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is HttpException) {
        throw Exception('HTTP error: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('Bad response format');
      } else {
        throw Exception('Error occurred while fetching data: $e');
      }
    }

  }

  //Hàm thực hiện yêu cầu gửi lại mã
  Future<bool> ResendOtp(BuildContext context, String Email) async{
    String uri = Resend_Otp;
    print("Path: ${uri}");

    var res = await http.post(
      Uri.parse(uri),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        "Email": Email
      })
    );
    print("Status: ${res.statusCode}");
    switch(res.statusCode){
      case 400:
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi",
            text: "Email không tồn tại."
        );
        return false;
      case 500:
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi",
            text: "Lôi bên server. Vui lòng thử lại"
        );
        return false;
      default: return true;
    }
  }



  //Hàm thực hiện xác nhận mã otp trước khi đổi mật mã
  //Hàm thực hiện xác nhận mã otp trước khi bỏ phiếu

}

