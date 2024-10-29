import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ChangePwdModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';

class ChangePasswordPage extends StatefulWidget {
  static const routeName = 'change-pwd';
  final String ID_user;
  const ChangePasswordPage({
    Key? key,
    required this.ID_user
  }) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState(ID_user: ID_user);
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final ChangeUserPwdModel _changeUserPwdModel = ChangeUserPwdModel('','');
  final UserRepository _userRepository = UserRepository();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  final String ID_user;

  _ChangePasswordPageState({required this.ID_user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppTitle(textTitle: 'Đổi mật khẩu'),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F4F6), Colors.white],
            ),
          ),
          child: _buildPasswordChangeForm(context),
        ),
      ),
    );
  }

  Widget _buildPasswordChangeForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Lottie.asset(
                  'assets/animations/changepwd.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 32.0),
              _buildPasswordField(
                label: 'Mật khẩu hiện tại',
                obscureText: _obscureOldPassword,
                onChanged: (value) => _changeUserPwdModel.oldPwd = value,
                toggleObscure: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                icon: Icons.lock_outline,
              ),
              SizedBox(height: 16.0),
              _buildPasswordField(
                label: 'Mật khẩu mới',
                obscureText: _obscureNewPassword,
                onChanged: (value) => _changeUserPwdModel.newPwd = value,
                toggleObscure: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                icon: Icons.lock,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Đổi mật khẩu', style: TextStyle(color:Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A8A),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback toggleObscure,
    required IconData icon,
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF3B82F6)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFF3B82F6),
          ),
          onPressed: toggleObscure,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Color(0xFF3B82F6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2.0),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        return null;
      },
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      print("hahah");

       await _userRepository.ChangeUserPwd(context, _changeUserPwdModel, ID_user);
    }
  }
}