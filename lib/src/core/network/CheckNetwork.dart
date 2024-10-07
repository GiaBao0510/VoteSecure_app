import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusSingleton {
  //1.Tạo một instance của ConnectionStatusSingleton
  static final ConnectionStatusSingleton _singleton =
  new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //3.Điều này theo dõi trạng thái kết nối gần đây
  bool hasConnection = false;

  //4. Đây là cách để chúng tôi cho phép đăng ký sự thay đổi kết nối
  StreamController<bool> connectionChangeController =
  new StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  //6. Cho "_connectivity" tham gia vào để lắng nghe cho sự thay đổi và kiểm tra trạng thái  mạng ra khỏi cổng
  void initialize() {
    _connectivity.onConnectivityChanged.listen((results) {
      _connectionChange(results.first);
    });
    checkConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  /*
    7.Phương thức làm sạch dùng để đóng StreamController .Bởi vì điều này tồn tại
    trong suốt vòng đời ứng dụng, điều này không gây ra vấn đề gì
  */
  void dispose() {
    connectionChangeController.close();
  }

  //8. _connectivity lắng nghe
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //9.Kiểm tra kết nối internet
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //Có mạng
        hasConnection = true;
      } else {
        hasConnection = false; //                               //không có mạng
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //Nếu trạng thái kết nối thay đỏi thì gửi bản cập nhật đến tất cả người nghe
    if (previousConnection != hasConnection) {
      connectionChangeController.sink.add(hasConnection);
    }

    return hasConnection; // Trả về trạng thái kết nối hiện tại
  }
}