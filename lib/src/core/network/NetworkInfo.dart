import 'package:connectivity_plus/connectivity_plus.dart';
import '../exceptions/NoInternetException.dart';

class NetworkInfo{
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  Future<void> checkInternetConnection() async{
    final connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult.contains(ConnectivityResult.none)){
      throw NoInternetException();
    }
  }
}