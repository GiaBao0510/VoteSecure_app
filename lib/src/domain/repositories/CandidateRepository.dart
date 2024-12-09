import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CandidateListBasedOnElctionDateModel.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/data/models/VotingHistoryModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';

class CandidateRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1.Lấy danh sách ứng cu viên dựa trên thời điểm bắt đầu bỏ phiếu
  Future<List<CandidateListBasedonElEctionDateModel>> GetCandidateListBasedOnElectionDate(BuildContext context, String ngayBD) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getCandidateListBasedOnElectionDate+ngayBD;
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
        List<CandidateListBasedonElEctionDateModel> electionVoterHavePaticipanted
         = data.map((e) => CandidateListBasedonElEctionDateModel.fromMap(e)).toList();

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

  //2.Lấy danh sách các kỳ bầu cử mà ứng cu viên đã ghi danh
  Future<List<ElectionUserHavePaticipanted_Model>> GetListOfRegisteredCandidate(BuildContext context, String ID_ucv) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getListOfRegisteredCandidate+ID_ucv;
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

  //5. Bỏ phiếu
  Future<bool> CandidateVote(
      BuildContext context, ElectionUserHavePaticipanted_Model candidateRegistedForElections,String ID_object, BigInt GiaTriPhieu
      ) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = candidateVote;
      print("path: $uri");

      // Hiển thị dialog chờ đợi
      widgetlibraryState.buildingAwaitingFeedback_2(context);

      var requestBody = {
        "ID_ucv": ID_object,
        "GiaTriPhieuBau": GiaTriPhieu.toString(),
        "ngayBD": candidateRegistedForElections.ngayBD.replaceAll('T', ' '),
        "ID_Cap": candidateRegistedForElections.iD_Cap,
        "ID_DonViBauCu": candidateRegistedForElections.iD_DonViBauCu
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

  //6.Lấy danh sách lịch sử bỏ phiếu
  Future<List<VotingHistoryModel>> GetListOfVotingHistory(BuildContext context, String ID_ucv) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getListOfVotingHistory_Candidate+ID_ucv;
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