import 'dart:async';

import 'package:flutter/material.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/domain/repositories/WorkWithOtp.dart';
import 'package:votesecure/src/domain/repositories/login_repository.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "set-pwd-based-on-email";
  final String Email;
  const ChangePasswordScreen({
    super.key,
    required this.Email
  });

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState(Email: Email);
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final String Email;
  late String pwd;

  _ChangePasswordScreenState({required this.Email});

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 225, 225, 225),
          leading: IconButton(
            icon: const Icon(
              color: Colors.black,
              Icons.chevron_left_outlined,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Text(
                "Đổi mật khẩu",
                style:
                TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        body: Stack(children: [
          widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xff006af5', '0xff006af5'),
          Padding(
              padding:EdgeInsets.fromLTRB(15, 50, 15, 0),
              child: _BuildFromChangePwd(context)
          ),

        ],)
    );
  }

  //From đỏi mật khẩu
  Widget _BuildFromChangePwd(BuildContext context){
    return Scrollbar(
      child:  ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext content,int index){
            return Material(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffe6e6e6), Color(0xffe8e8e8)],
                        stops: [0, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Image.asset(
                          'assets/images/ChangePassword.png',
                          height: 180,
                          width: 180,
                        ),

                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Mật khẩu mới',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2), // Viền đỏ khi ô bị lỗi được focus
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            counterText: '',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu mới';
                            }

                            // Kiểm tra độ dài của mật khẩu
                            if (value.length < 8) {
                              return 'Mật khẩu phải có ít nhất 8 ký tự';
                            }

                            // Kiểm tra chứa ít nhất 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 chữ số
                            bool hasUppercase = value.contains(new RegExp(r'[A-Z]'));
                            bool hasSpecialChar = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                            bool hasNumber = value.contains(new RegExp(r'[0-9]'));

                            if (!hasUppercase || !hasSpecialChar || !hasNumber) {
                              return 'Mật khẩu phải chứa ít nhất 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 chữ số';
                            }

                            return null; // Trả về null nếu mật khẩu đáp ứng yêu cầu
                          },
                        ),

                        const SizedBox(height: 50,),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Xác nhận khẩu mới',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 2), // Viền đỏ khi ô bị lỗi được focus
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            counterText: '',
                          ),obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu mới';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Mật khẩu xác nhận không khớp';
                            }
                            pwd = value;

                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        _BuildButtonSend(context),
                        SizedBox(height: 20),
                        _BuildLoginPagNavigationButton(context)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  //Nút bấm gửi
  Widget _BuildButtonSend(BuildContext context){
    final loginRepository = Provider.of<LoginRepository>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        print('\t\t --- Set pwd based on email');
        print('Email: ${Email}');
        print('pwd: ${pwd}');

        if (_formKey.currentState?.validate() ?? false) {

          bool checkChangePwd = await loginRepository.SetPwdBasedOnUserEmail(context, Email, pwd);
          if(checkChangePwd == true){
            // Mật khẩu hợp lệ, thực hiện hành động thay đổi mật khẩu
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đổi mật khẩu thành công')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context)=> loginPages())
            );
          }else{
            print('Thay đổi mật khẩu thất bại');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Màu nền của nút
        foregroundColor: Colors.white, // Màu chữ trên nút
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Khoảng cách giữa chữ và viền nút
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bo tròn viền nút
      ),
      child: Text('Đổi Mật Khẩu'),
    );
  }

  //Nút bấm quay về trang đăng nhập
  Widget _BuildLoginPagNavigationButton(BuildContext context){
    return Container(
      child: TextButton(
          onPressed: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => loginPages())
            );
          },
          child: const Text(
              style: TextStyle(decoration: TextDecoration.underline, color: Color.fromARGB(255, 89, 84, 250)),
              'Đăng nhập'
          )
      ),
    );
  }
}