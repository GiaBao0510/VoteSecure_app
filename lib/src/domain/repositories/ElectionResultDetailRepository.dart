import 'package:votesecure/src/data/models/ElectionResultsDetailsModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';

class ElectionResultDetailRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1.Lấy danh sách các kỳ bầu cử đã công bố dựa trên đổi tượng
  Future<List<ElectionResultsDetailModel>> GetCandidateListBasedOnElectionDate(BuildContext context, String uri, String ID_object) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      uri = uri+ID_object;
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
        List<ElectionResultsDetailModel> electionResultsDetailModel
        = data.map((e) => ElectionResultsDetailModel.fromMap(e)).toList();

        notifyListeners();
        return electionResultsDetailModel;
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