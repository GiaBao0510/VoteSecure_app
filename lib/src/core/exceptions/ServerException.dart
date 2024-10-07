class ServerException implements Exception{
  final String mgs;
  ServerException({this.mgs = 'Server not responding, please try again after sometime.'});
}