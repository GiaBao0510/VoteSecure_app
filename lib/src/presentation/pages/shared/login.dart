import 'package:flutter/material.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/presentation/pages/shared/ScanQRcodePageToRegister.dart';
import 'package:votesecure/src/presentation/pages/shared/VerifyEmailWhenForgot.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/data/models/loginModel.dart';
import 'package:votesecure/src/domain/repositories/login_repository.dart';

class loginPages extends StatefulWidget {
  static const routeName = "/login";
  const loginPages({super.key});
  @override
  State<loginPages> createState() => _loginPagesState();
}

class _loginPagesState extends State<loginPages> {
  final _formKey = GlobalKey<FormState>();
  LoginModel user = LoginModel('','',false);
  verifyOtpModel verify = verifyOtpModel('','','');
  final LoginRepository loginRepository = LoginRepository(); //Tạo instance

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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildPageBackground(context),
            _buildFormBackground(context),
          ],
        ),
      ),
    );
  }

  //Nền trang
  Widget _buildPageBackground(BuildContext context){
    return //Maàu nền
      Positioned(
          child: Container(
              width: double.infinity,
              height: double.infinity,

              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/backgroundlogin.jpg'),
                      fit: BoxFit.cover
                  )
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
          )
      );
  }

  //From đăng nhập
  Widget _buildFormBackground(BuildContext context){

    return Align(
      alignment: Alignment.center,
      child: Scrollbar(
        child: ListView(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        
          children: <Widget>[
            const SizedBox(height: 40,),
            SingleChildScrollView(
              child: _buildFormLogin(context),
            ),
          ],
        ),
      ),
    );
  }

  //Biểu mẫu
  Widget _buildFormLogin(BuildContext context){
    return Material(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(15.0),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white.withOpacity(0.5),
          ),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(children: [
            //Trang trí
            Container(
              child: FractionallySizedBox(
                child: Lottie.asset(
                    'assets/animations/login.json',
                    repeat: true,
                    fit: BoxFit.contain
                ),
              ),
            ),
      
            //Trường nhập tài khoản
            const SizedBox(height: 10,),
            TextFormField(
              controller: TextEditingController(text: user.account),
              decoration: const InputDecoration(
                labelText: 'Tài khoản',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 15.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromARGB(255, 39, 141, 182), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập tài khoản';
                }
                return null;
              },
              onChanged: (value){
                user.account = value;
              },
            ),
      
            const SizedBox(height: 30,),
      
            //Trường nhập mật khẩu
            TextFormField(
              controller: TextEditingController(text: user.password),
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 15.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromARGB(255, 39, 141, 182), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofocus: false,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                return null;
              },
              onChanged: (value){
                user.password = value;
              },
            ),
      
            //nút gưi
            const SizedBox(height: 30,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async{
                    //Kiểm tra trước khi đăng nhập
                    if(_formKey.currentState != null && _formKey.currentState!.validate()){
                      print("Đã điền  đủ");

                      await loginRepository.Login(context, user, verify);
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
                  child: const Text('Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,))
              ),
            ),
      
            //Quên mật khẩu & đăng ky
            Container(
              child: TextButton(
                  onPressed: (){
                    print("Quen mật khẩu");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterEmailToVerify_page() ));
                  },
                  child: const Text(
                    style: TextStyle(decoration: TextDecoration.underline, color: Color.fromARGB(255, 89, 84, 250)),
                    'Quên mật khẩu?',
                  )
              ),
            ),
            Container(
              child: TextButton(
                  onPressed: (){
                    print("Quét mã");
                    Navigator.push(
                        context, 
                      MaterialPageRoute(builder: (context) => QRScannerPage() )
                    );
                  },
                  child:  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Chưa có tài khoản đăng ký?',
                        style: TextStyle(decoration: TextDecoration.underline, color: Color.fromARGB(255, 89, 84, 250))
                      ),

                      WidgetSpan(child: Icon(Icons.qr_code_2, color:Color.fromARGB(255, 89, 84, 250) ,))
                    ]),
                  )
              ),
            ),

          ],),
        ),
      ),
    );
  }

  //Quên maatk khẩu và đaăng ký
  Widget _buildRegisterOrForgotpasswod(BuildContext context){
    return Container(
      child: Row(children: [
        Expanded(
            child: Container(
              child: ElevatedButton(
                  onPressed: (){
                    print("Quen mật khẩu");
                  },
                  child: Text('Quên mật khẩu?')
              ),
            )
        ),
        Expanded(
            child: Container(
              child: ElevatedButton(
                onPressed: (){
                  print("Đăng ký thông qua quét mã");
                },
                child: Text(' Đăng ký thông qua quét mã'),
              ),
            )
        ),
      ],),
    );
  }
}