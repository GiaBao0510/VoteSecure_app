import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/CandidateListBasedOnElctionDateModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';

class CandidateRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //Lấy danh sách ứng cu viên dựa trên thời điểm bắt đầu bỏ phiếu
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
}