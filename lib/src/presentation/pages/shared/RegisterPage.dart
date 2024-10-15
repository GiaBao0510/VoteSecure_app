import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppbarLight.dart';

class RegisterAndSetPwdScreen extends StatefulWidget {
  static const routeName = 'register-and-set-pwd';
  final String SDT;
  RegisterAndSetPwdScreen({
    required this.SDT,
  });

  @override
  _RegisterAndSetPwdScreenState createState() => _RegisterAndSetPwdScreenState(SDT: SDT);
}

class _RegisterAndSetPwdScreenState extends State<RegisterAndSetPwdScreen> {
  final _formKey = GlobalKey<FormState>();
  final WidgetlibraryState widgetlibraryState = WidgetlibraryState();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final VoterRepository voterRepository = VoterRepository();
  final String SDT;
  String newPWD = 'null';
  _RegisterAndSetPwdScreenState({
    required this.SDT,
  });

  bool _isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppTitleLight(textTitle: 'Đặt mật khẩu',),
        body: Stack(children: [
          widgetlibraryState.buildPageBackgroundGradient2Color(context, '0xff1488cc', '0xff2b32b2'),
          _buildFormSetPWD(context),
        ],)
      ),
    );
  }

  //Xây dụng form đặt mật kẩu
  Widget _buildFormSetPWD(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  child: FractionallySizedBox(
                    child: Lottie.asset(
                        'assets/animations/setPWD.json',
                        repeat: true,
                        fit: BoxFit.contain
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Đặt mật khẩu để hoàn thành bước đăng ký',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Đặt mật khẩu mới',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nập mật khẩu mới';
                    }
                    if (!_isValidPassword(value)) {
                      return 'Password must be at least 8 characters, contain at least one uppercase letter, one lowercase letter, one number and one special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu để xác nhận';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu không khớp với nhau';
                    }
                    setState(() {
                      newPWD = value;
                    });
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async{
                        //Kiểm tra trước khi đăng nhập
                        if(_formKey.currentState != null && _formKey.currentState!.validate()){

                          await voterRepository.RegistrationProccessing(context, SDT, newPWD);

                        }else{
                          print("Chưa điền ủ thông tin");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                      child: const Text('Đăng ký', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,))
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}