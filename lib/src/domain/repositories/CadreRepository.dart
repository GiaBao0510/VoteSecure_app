import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/BallotDetailModel.dart';
import 'package:votesecure/src/data/models/CadreJoinedForElectionModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';

class CadreRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1. lấy danh sách các kỳ  bầu cử mà cán bộ đang có mặt
  Future<List<CadreJoinedForElectionModel>>  GetListOfCadreJoinedForElection(BuildContext context, String ID_CanBo) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getListOfCadreJoinedForElection+ID_CanBo;
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

      if(res.statusCode == 200){
        Map<String,dynamic> json = jsonDecode(res.body);
        List<dynamic> data = json['data'];
        List<CadreJoinedForElectionModel> dataResponse
        = data.map((e) => CadreJoinedForElectionModel.fromMap(e)).toList();

        notifyListeners();
        return dataResponse;
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

  //2. Lấy danh sách thông tin các phiếu bầu theo kỳ bầu cử
  Future<List<BallotDetailModel>> GetDetailsAboutVotesBasedOnElectionDate(BuildContext context, String ngayBD) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getDetailsAboutVotesBasedOnElectionDate+ngayBD;
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
        List<BallotDetailModel> dataResponse
        = data.map((e) => BallotDetailModel.fromMap(e)).toList();

        notifyListeners();
        return dataResponse;
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

  //3. Giải mã các phiếu bầu dựa trên ngày bầu cử
  Future<List<BallotDetailModel>> GetListOfDecodedVotesBasedOnElectionDate(BuildContext context, String ngayBD) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      ngayBD = ngayBD.replaceAll('T', ' ');
      String uri = getListOfDecodedVotesBasedOnElectionDate+ngayBD;
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
        List<BallotDetailModel> dataResponse
        = data.map((e) => BallotDetailModel.fromMap(e)).toList();

        notifyListeners();
        return dataResponse;
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

  //4.công bố kết quả
  Future<void> AnnounceElectionResults(BuildContext context, String ngayBD, String ID_CanBo) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      ngayBD = ngayBD.replaceAll('T', ' ');
      String uri = announceElectionResults;
      print('Path: ${uri}');
      print('Can bộ công bố: $ID_CanBo');
      print('Ky bau cu: $ngayBD');

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      var res = await http.put(
          Uri.parse(uri),
          headers: {
            "Content-Type":"application/json",
            "Authorization": "Bearer $accessToken",
          },
        body: jsonEncode({
          "ngayBD": ngayBD,
          "ID_CanBo": ID_CanBo
        })
      );

      // Đóng dialog sau khi có phản hồi từ server
      Navigator.of(context).pop();

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
            title: "Lỗi khi công bố kết quả bầu cử",
            text: message
        );
      }
      else{
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