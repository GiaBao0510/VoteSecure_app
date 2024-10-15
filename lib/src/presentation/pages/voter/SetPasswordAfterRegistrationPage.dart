import 'package:flutter/material.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';

class PasswordSetupPage extends StatefulWidget {
  @override
  _PasswordSetupPageState createState() => _PasswordSetupPageState();
}

class _PasswordSetupPageState extends State<PasswordSetupPage> {
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left_sharp,
                color: Colors.indigo,
                size: 30,
                weight: 15,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ),
          body: Stack(children: [
            widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xff259dd0', '0xff4179fb'),
            _BuildFormPasswordSetup(context),
          ],),
        )
    );
  }

  Widget _BuildFormPasswordSetup(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 80),
              const Text(
                'Đặt mật khẩu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextFormField(
                'Mật khẩu',
                    (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
                    (value) => _password = value!,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                'Xác nhận mật khẩu',
                    (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _password) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
                    (value) => _confirmPassword = value!,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Xử lý khi form hợp lệ
                    print('Form hợp lệ');
                  }
                },
                child: Text('Xác nhận'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, String? Function(String?) validator, void Function(String?) onSaved, {bool isPassword = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      obscureText: isPassword,
      validator: validator,
      onSaved: onSaved,
    );
  }
}