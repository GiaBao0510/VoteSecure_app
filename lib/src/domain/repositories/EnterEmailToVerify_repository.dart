import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/data/models/EnterEmailToVerify_Model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class EnterEmailToVerifyRepository with ChangeNotifier{
  Future<bool> CheckEmail(BuildContext context,EnteremailtoverifyModel Email )async{
    try{
      String path = SendOTP_fotgotPwd;
      print('Gui den url: ${path}');
      var res = await http.post(
          Uri.parse(path),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode({
            "Email": Email.email
          })
      );

      final thongTinPhanHoi = jsonDecode(res.body);
      //Nếu không thành công thì báo lỗi
      if(res.statusCode == 200){
        return true;
      }if(res.statusCode == 400){
        String message =  thongTinPhanHoi['message'];
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi xác thực email",
            text: message
        );
        return false;
      } else {
        //Nhảy qua bên đây vì lỗi server
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