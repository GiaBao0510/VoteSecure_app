import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/data/models/VotingHistoryModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';


class VoterRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1.Hàm kiểm tra xem mã c tri tồn taại khong
  Future<Voterinformationafterscaningmodel?> DisplayUserInformationAfterScanning(BuildContext context, String ID_cuTri)async{
    try{
      Voterinformationafterscaningmodel user = new Voterinformationafterscaningmodel('','','','','','','','');
      String uri = displayVoterInformationAfterScanning+ID_cuTri;
      print('Path: $uri');
      var res = await http.get(
          Uri.parse(uri),
          headers:<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );
      print(res.body);
      final thongTinPhanHoi = jsonDecode(res.body);
      String message = thongTinPhanHoi['message'];
      if(res.statusCode == 200){
        final resData = jsonDecode(res.body);
        user.hoten = resData['data']['hoTen'];
        user.tenDanToc = resData['data']['tenDanToc'];
        user.sdt = resData['data']['sdt'];
        user.hinhAnh = resData['data']['hinhAnh'];
        user.diaChiLienLac = resData['data']['diaChiLienLac'];
        user.ngaySinh = resData['data']['ngaySinh'];
        user.Email = resData['data']['email'];
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
  Future <void> RegistrationProccessing(BuildContext context, String sdt, String pwd) async{
    try{
      String uri = userRegister;
      print('Call path: ${uri}');

      var res = await http.post(
          Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "SDT": sdt,
            "pwd": pwd
          })
      );

      print(res.body);
      if(res.statusCode == 200){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => loginPages())
        );
      }else if(res.statusCode == 400){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Oppps...",
            text: "Số điện thoại không tồn tại"
        );
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

  //Lấy thời điểm các kỳ bầu cử dựa trên SDT người dùng được tham dụ
  Future<List<ElectionUserHavePaticipanted_Model>> ElectionsInWhichVoterAreAlloweddToParticipate(BuildContext context) async{
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
        List<ElectionUserHavePaticipanted_Model> electionVoterHavePaticipanted
          = data.map((e) => ElectionUserHavePaticipanted_Model.fromMap(e)).toList();

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

  // Cu tri bo phiếu
  Future<bool> VoterVote(BuildContext context,ElectionUserHavePaticipanted_Model electionDetail, String ID_object, BigInt GiaTriPhieu) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = voterVote;
      print("path: $uri");

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      var requestBody = {
        "ID_CuTri": ID_object,
        "GiaTriPhieuBau": GiaTriPhieu.toString(),
        "ngayBD": electionDetail.ngayBD.replaceAll('T', ' '),
        "ID_Cap": electionDetail.iD_Cap,
        "ID_DonViBauCu": electionDetail.iD_DonViBauCu
      };

      var res = await http.post(
        Uri.parse(uri),
        headers: {
          'content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(requestBody),
      );

      // Đóng dialog sau khi có phản hồi từ server
      Navigator.of(context).pop();

      print(res.body);
      print("status: ${res.statusCode}");
      final thongTinPhanHoi = jsonDecode(res.body);
      String message = thongTinPhanHoi['message'];
      if(res.statusCode == 200){
        Navigator.pop(context);//Quay về
        return true;
      }else if(res.statusCode == 400){
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Lỗi khi thực hiện gửi phiếu",
            text: message
        );
        return false;
      }
      else{
        notifyListeners();
        throw Exception('Failed to load data');
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

  //Lấy danh sách lịch sử bỏ phiếu
  Future<List<VotingHistoryModel>> GetListOfVotingHistory(BuildContext context, String ID_CuTri) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getListOfVotingHistory+ID_CuTri;
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
        List<VotingHistoryModel> ListOfVotingHistory
          = data.map((e) => VotingHistoryModel.fromMap(e)).toList();

        notifyListeners();
        return ListOfVotingHistory;
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