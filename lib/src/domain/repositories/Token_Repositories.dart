import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository with ChangeNotifier{

  //Lưu accessToken
  Future<void> storedAccessToken(String accessToken) async{
    String token = accessToken.split("accessToken=")[1].split(";")[0];  //Xử lý cắt bỏ phần thừa

    //Lưu
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("accessToken", token);
  }

  //Lưu RefreshToken
  Future<void> storedRefreshToken(String accessToken) async{
    String token = accessToken.split("refreshToken=")[1].split(";")[0];  //Xử lý cắt bỏ phần thừa

    //Lưu
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("refreshToken=", token);
  }

  //Lấy AccessToken
  Future<String?> getAccessToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString("accessToken");
  }

  //Lấy RefreshToken
  Future<String?> getRefreshToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString("refreshToken");
  }

  //Xóa AccessToken
  Future<void> deleteAccessToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('accessToken');
  }

  //Xóa RefreshToken
  Future<void> deleteRefreshToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('refreshToken');
  }
}