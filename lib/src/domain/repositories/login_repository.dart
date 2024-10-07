import 'dart:convert';
import 'dart:io';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/data/models/loginModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOtpAfterLogin.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class LoginRepository with ChangeNotifier {
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //Hàm Thuc hien dang nhap
  Future Login(BuildContext context, LoginModel user, verifyOtpModel verify ) async{
    try{
      String path =  login;
      print('Call path: ${path}');

      //Chờ đợi
      widgetlibraryState.buildingAwaitingFeedback(context);

      var res = await http.post(
          Uri.parse(path),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "account": user.account,
            "password": user.password
          })
      );

      //Đóng chờ đợi
      Navigator.of(context, rootNavigator: true).pop();

      final thongTinPhanHoi = jsonDecode(res.body);
      String message = thongTinPhanHoi['message'] ?? "null";
      //Đăng nập thành công -> Chuyên qua trang để xác minh sau khi đăng nhập
      if(res.statusCode == 200){
        verify.Email = thongTinPhanHoi['email'];
        verify.Phone = user.account;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> VerificationCodeScreen(verifyOtp: verify) ));

      }else if(res.statusCode == 400 ){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi đăng nhập",
            text: message
        );
      }else {
        throw Exception(
            'Failed to load data. Status code: ${res.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('No internet connection: ${e.message}');
      } else if (e is HttpException) {
        throw Exception('HTTP error: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('Bad response format: ${e.message}');
      } else {
        throw Exception('Error occurred while fetching data: $e');
      }
    }

  }

  //2.Kiểm tra xem thiết bị này đã đăng nhập hay chưa
  Future<int> CheckLogined(BuildContext context) async{

    //Lấy AccessToken từ thiết bị người dùng
    final accessToken = await _tokenRepository.getAccessToken();
    final refreshToken = await _tokenRepository.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      if (!JwtDecoder.isExpired(accessToken)) {
        return _getUserRole(accessToken);
      } else if (!JwtDecoder.isExpired(refreshToken)) {
        return await _renewAccessToken(context, refreshToken);
      } else {
        await _tokenRepository.deleteRefreshToken();
        await _tokenRepository.deleteAccessToken();
        return -1;
      }
    } else {
      return -1;
    }
  }

  //3.Làm mới AccessToken
  Future<int> _renewAccessToken(BuildContext context, String refreshToken) async{
    try{
      String uri = renewtoken;
      Map<String,dynamic> decodedToken = JwtDecoder.decode(refreshToken);

      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "account": decodedToken['SDT'],
          "Email": decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          "Role": decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'],
          "BiKhoa": decodedToken['BiKhoa'],
          "SuDung": decodedToken['SuDung'],
        }),
      );
      if (res.statusCode == 200) {
        await _saveNewAccessToken(res);

        final accessToken = await _tokenRepository.getAccessToken();
        if(accessToken != null){
          return _getUserRole(accessToken);
        }else{
          await _tokenRepository.deleteAccessToken();
          await _tokenRepository.deleteRefreshToken();
          return -1;
        }
      } else {
        await _tokenRepository.deleteAccessToken();
        await _tokenRepository.deleteRefreshToken();
        return -1;
      }
    }catch(e){
      if (e is SocketException) {
        throw Exception('No internet connection: ${e.message}');
      } else if (e is HttpException) {
        throw Exception('HTTP error: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('Bad response format: ${e.message}');
      } else {
        throw Exception('Error occurred while fetching data: $e');
      }
    }
  }

  //Lưu lại Token mới
  Future<void> _saveNewAccessToken(http.Response res) async{
    final cookies = res.headers['set-cookie'];    //Lấy danh sách các toke từ cookie
    if(cookies != null){
      final cookieList = cookies.split('; ');       //Phân tách ra
      for(var cookie in cookieList){
        if(cookie.startsWith('accessToken=')){
          final accessToken = cookie;
          await _tokenRepository.storedAccessToken(accessToken); //Lưu token
        }
      }
    }
  }

  //Trả về vai trò người dùng
  int _getUserRole(String accessToken){
    final decodedToken = JwtDecoder.decode(accessToken);
    final role = decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
    return int.parse(role);
  }

  //Đăng xuất
  Future<bool> logout() async{
    await _tokenRepository.deleteAccessToken();
    await _tokenRepository.deleteRefreshToken();
    return true;
  }

  //Kiểm tra email
  Future<bool> CheckUserEmail(BuildContext context, String Email) async{
    try{
      String uri = checkUserEmail+Email;
      print("Path: ${uri}");

      var res = await http.get(
          Uri.parse(uri),
          headers: {'content-type': 'application/json'}
      );
      print("Status: ${res.statusCode}");
      if(res.statusCode == 200){
        return true;
      }else if(res.statusCode == 400){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi",
            text: "Email không tồn tại."
        );
        return false;
      }else{
        throw Exception(
            'Failed to load data. Status code: ${res.statusCode}');
      }
    }catch(e){
      if (e is SocketException) {
        throw Exception('No internet connection: ${e.message}');
      } else if (e is HttpException) {
        throw Exception('HTTP error: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('Bad response format: ${e.message}');
      } else {
        throw Exception('Error occurred while fetching data: $e');
      }
    }
  }

  //Thay đổi mật khẩu dựa trên email người dùng
  Future<bool> SetPwdBasedOnUserEmail(BuildContext context, String Email, String newPwd) async{
    try{
      String uri = SetPwdBasedOnEmail+Email;
      print("Path: ${uri}");

      var res = await http.put(
        Uri.parse(uri),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          "newPwd":newPwd
        }),
      );
      print("Status: ${res.statusCode}");
      if(res.statusCode == 200){
        return true;
      }else if(res.statusCode >= 400 && res.statusCode < 500){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi",
            text: "Email không tồn tại."
        );
        return false;
      }else{
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
}
