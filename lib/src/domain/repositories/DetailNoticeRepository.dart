import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:votesecure/src/config/AppConfig_api.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/DetailNoticeModel.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';

class DetailNoticeRepository with ChangeNotifier{
  final TokenRepository _tokenRepository = TokenRepository();
  final widgetlibraryState = WidgetlibraryState();

  //1.Lấy danh sách thông báo cán bộ
  Future<List<DetailNoticeModel>> GetCadreNotificationList(BuildContext context, String ID_CanBo) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getCadreNotificationList+ID_CanBo;
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
        List<DetailNoticeModel> dataResponse
        = data.map((e) => DetailNoticeModel.fromMap(e)).toList();

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

  //2.lấy danh sách thông báo ứng cử viên
  Future<List<DetailNoticeModel>> GetCandidateNotificationList(BuildContext context, String ID_ucv) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getCandidateNotificationList+ID_ucv;
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
        List<DetailNoticeModel> dataResponse
        = data.map((e) => DetailNoticeModel.fromMap(e)).toList();

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

  //3.lấy danh sách thông báo cử tri
  Future<List<DetailNoticeModel>> GetVoterNotificationList(BuildContext context, String ID_CuTri) async{
    try{
      final accessToken = await _tokenRepository.getAccessToken();
      String uri = getVoterNotificationList+ID_CuTri;
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
        List<DetailNoticeModel> dataResponse
        = data.map((e) => DetailNoticeModel.fromMap(e)).toList();

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


}
