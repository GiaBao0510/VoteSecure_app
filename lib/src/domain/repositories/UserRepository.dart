import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ContactUsModel.dart';
import 'package:votesecure/src/data/models/ElectionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';

class UserRepository with ChangeNotifier{
  final widgetlibraryState = WidgetlibraryState();
  final TokenRepository _tokenRepository = TokenRepository();

  //Hàm thực hiện lấy danh sach kỳ bầu cử sắp diễn ra
  Future<List<ElectionModel>> getListOfFuture_Elections(BuildContext context) async {
    try{
      //Lấy token
      var token = await _tokenRepository.getAccessToken();

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      //Chạy http
      String uri = GetListOfFutureElections;
      print('path: $uri');
      var res = await http.get(
          Uri.parse(uri),
          headers: {
            'Authorization': 'Bearer $token',
          }
      );

      // Đóng dialog sau khi có phản hồi từ server
      Navigator.of(context).pop();

      if(res.statusCode == 200){
        Map<String, dynamic> json = jsonDecode(res.body);
        List<dynamic> data = json['data'];
        List<ElectionModel> ElectionList =
          data.map((e) => ElectionModel.fromMap(e)).toList();

        notifyListeners();
        return ElectionList;
      }else{
        notifyListeners();
        throw Exception('Failed to load data');
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

  //Hàm lấy thôn tin người dùng dựa trên Email
  Future<void> GetProfileUserBasedOnUserEmail(BuildContext context,ProfileModel user ,String Email) async{
    try{
      //Lấy thông tin người dùng dựa trên email
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = GetPersonalInformationBasedOnEmail+Email;
      print("Path: ${uri}");

      if(accessToken != null){
        var res = await http.get(
          Uri.parse(uri),
          headers: {
            "Content-Type":"application/json",
            "Authorization": "Bearer $accessToken",
          },
        );
        print(res.body);
        final thongTinPhanHoi = jsonDecode(res.body);

        if(res.statusCode == 200) {
          print("Lấy thông tin người dùng thành công");

          user = ProfileModel(
              HoTen: thongTinPhanHoi['data']['hoTen'],
              TenDanToc: thongTinPhanHoi['data']['tenDanToc'],
              NgaySinh: DateTime.parse(thongTinPhanHoi['data']['ngaySinh']),
              HinhAnh: thongTinPhanHoi['data']['hinhAnh'],
              DiaChi: thongTinPhanHoi['data']['diaChiLienLac'],
              GioiTinh: thongTinPhanHoi['data']['gioiTinh'],
              SDT: thongTinPhanHoi['data']['sdt'],
              Email: thongTinPhanHoi['data']['email'],
            ID_Object: thongTinPhanHoi['data']['iD_Object'],
            ID_User: thongTinPhanHoi['data']['iD_Object'],
          );
        }else{
          throw Exception(
              'Failed to load data. Status code: ${res.statusCode}');
        }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const loginPages()));
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

  //Đăng xuất
  Future<void> LogOut(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await _tokenRepository.deleteAccessToken();
    await _tokenRepository.deleteRefreshToken();
    await pref.remove('UserRole');
    await pref.remove('UserPhone');
    await pref.remove('UserEmail');

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const loginPages()));
  }

  //Gửi thông tin liên he
  Future SendComments(BuildContext context, ContactUsModel sender) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = voterSendContactUs;
      print('path: $uri');

      var res = await http.post(
        Uri.parse(uri),
        headers: {
          'content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        },
          body: jsonEncode({
            "IDSender": sender.IDSender,
            "YKien": sender.YKien
          })
      );

      print('${res.body}');
      if(res.statusCode == 200){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Gửi ý kiến thành công",
            text: "Chúng tôi đã tiếp nhận ý kiến của bạn. Chúc bạn một ngày vui vẻ"
        );
      }else{
        throw Exception(
            'Failed to send comments. Status code: ${res.statusCode}');
      }
    }catch (e) {
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

  //Chỉnh sửa thông tin cá nhân
  Future UserUpdateInfo(BuildContext context,ProfileModel user, String Old_SDT, int ID_DanToc) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      final WidgetlibraryState widgetlibraryState = WidgetlibraryState();
      String uri = userUpdateInfor;
      String NgaySinh = DateFormat('yyyy-MM-dd').format(user.NgaySinh ?? DateTime.now());
      print('path: $uri');
      print("--- thông tin gửi đi -===");
      print('Ho ten: ${user.HoTen}');
      print('Email: ${user.Email}');
      print('SDT: ${user.SDT}');
      print('GioiTinh: ${user.GioiTinh}');
      print('DiaChi: ${user.DiaChi}');
      print('ID_DanToc: ${ID_DanToc}');
      print('NgaySinh: ${NgaySinh}');
      print('ID_User: ${user.ID_User}');
      print('Old_SDT: ${Old_SDT}');

      var res = await http.put(
          Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode({
            "ID_user": user.ID_User,
            "HoTen":user.HoTen,
            "GioiTinh":user.GioiTinh,
            "NgaySinh":NgaySinh,
            "DiaChiLienLac":user.DiaChi,
            "OLD_SDT":Old_SDT,
            "SDT":user.SDT,
            "ID_DanToc":ID_DanToc,
            "Email":user.Email
          })
      );

      print('${res.body}');
      final thongTinPhanHoi = jsonDecode(res.body);
      String message = thongTinPhanHoi['message'] ?? "null";
      if(res.statusCode == 200){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Cập nhật thành công",
            text: message
        );
      }else if(res.statusCode == 400){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Cập nhật thất bại",
            text: message
        );
      }
      else{
        throw Exception(
            'Failed to send comments. Status code: ${res.statusCode}');
      }
    }catch (e) {
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


}