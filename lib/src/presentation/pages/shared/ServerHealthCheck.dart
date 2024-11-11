import 'package:http/http.dart' as http;
import 'package:votesecure/src/config/AppConfig_api.dart';

class ServerHealthCheck {
  static final ServerHealthCheck _instance = ServerHealthCheck._internal();
  factory ServerHealthCheck() => _instance;
  ServerHealthCheck._internal();

  //Cache kết quả
  bool _lastCheckResult = false;
  DateTime? _lastCheckTime;
  static const Duration CACHE_DURATION = Duration(seconds: 30);

  //Kiêm tra Cache hợp lệ không
  bool _isCacheValid(){
    if(_lastCheckResult != false && _lastCheckTime != null)
      return DateTime.now().difference(_lastCheckTime!) < CACHE_DURATION;
    return false;
  }

  //Kiểm tra kết nối đến server
  Future<bool> checkServerConnection() async{
    //Kiểm tra cache
    if(_isCacheValid())
      return _lastCheckResult;

    try{
      final res = await http.get(
        Uri.parse(CheckConnectServer),
        headers:  {'X-Health-Check': 'true'}
      ).timeout(const Duration(seconds: 5));

      print('>> path: $CheckConnectServer');

      _lastCheckResult = res.statusCode == 200;
      _lastCheckTime = DateTime.now();
      return _lastCheckResult;
    }catch (e) {
      _lastCheckResult = false;
      _lastCheckTime = DateTime.now();
      return false;
    }
  }
}
