import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionsVotersHavePaticipated_Model.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';


class VoterRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1.Hàm kiểm tra xem mã c tri tồn taại khong
  Future<Voterinformationafterscaningmodel?> DisplayUserInformationAfterScanning(BuildContext context, String ID_cuTri)async{
    try{
      Voterinformationafterscaningmodel user = new Voterinformationafterscaningmodel('','','',DateTime.now(),'','','','');
      String uri = displayVoterInformationAfterScanning+ID_cuTri;

      var res = await http.get(
          Uri.parse(uri),
          headers:<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );
      if(res.statusCode == 200){
        final resData = jsonDecode(res.body);
        user.hoten = resData['data']['hoTen'];
        user.tenDanToc = resData['data']['tenDanToc'];
        user.sdt = resData['data']['sdt'];
        user.hinhAnh = resData['data']['hinhAnh'];
        user.diaChiLienLac = resData['data']['diaChiLienLac'];
        user.ngaySinh = resData['data']['ngaySinh'];
        user.gioiTinh = resData['data']['gioiTinh'] == "1" ? "Nam":"Nữ" ;

        return user;
      }else if(res.statusCode == 400){
        return null;
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

  //Nhập thông tin đặt lại mật khẩu cho người dùng

  //Lấy thời điểm các kỳ bầu cử dựa trên SDT người dùng được tham dụ
  Future<List<ElectionVoterHavePaticipanted_Model>> ElectionsInWhichVoterAreAlloweddToParticipate(BuildContext context) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      SharedPreferences pref = await  SharedPreferences.getInstance();
      String sdt = await pref.getString('UserPhone') ?? 'null';
      String uri = listOfElectionsVotersHavePaticipated+sdt;
      print('Path: ${uri}');

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      var res = await http.get(
        Uri.parse(uri),
        headers: {
          "Content-Type":"application/json",
          "Authorization": "Bearer $accessToken",
        }
      );

      // Đóng dialog sau khi có phản hồi từ server
      Navigator.of(context).pop();

      print(res.body);
      if(res.statusCode == 200){
        Map<String,dynamic> json = jsonDecode(res.body);
        List<dynamic> data = json['data'];
        List<ElectionVoterHavePaticipanted_Model> electionVoterHavePaticipanted
          = data.map((e) => ElectionVoterHavePaticipanted_Model.fromMap(e)).toList();

        notifyListeners();
        return electionVoterHavePaticipanted;
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
}