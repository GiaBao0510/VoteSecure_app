import 'package:flutter/material.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOpt_ForgotPwd.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/domain/repositories/login_repository.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        home: const Material(
          child: SafeArea(
              child:Scaffold(
                body: EnterEmailToVerify_page(),
              )
          ),
        ),
        debugShowCheckedModeBanner: false,
      )
  );
}

class EnterEmailToVerify_page extends StatefulWidget {
  static const routeName = '/EnterEmailToVerify';
  const EnterEmailToVerify_page({super.key});

  @override
  State<EnterEmailToVerify_page> createState() => _EnterEmailToVerify_pageState();
}

class _EnterEmailToVerify_pageState extends State<EnterEmailToVerify_page> {
  final _formKey = GlobalKey<FormState>();
  String Email = '';
  final LoginRepository loginRepository = LoginRepository();

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
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 250, 244),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Color.fromARGB(255, 12, 52, 187),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Text(
                " Xác thực Email",
                style:
                TextStyle(color: Color.fromARGB(255, 12, 52, 187), fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            _buildPageBackground(context),
            _buildFormBackground(context)
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
                      image: AssetImage('assets/images/BackGroundVerityEmail.jpg'),
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

  //From nhập email
  Widget _buildFormBackground(BuildContext context){

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: _buildFormVerifyEmail(context),
        ),
      ),
    );
  }

  //Biểu mẫu
  Widget _buildFormVerifyEmail(BuildContext context){
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white.withOpacity(0.5),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(children: [
          //Trang trí
          Container(
            child: FractionallySizedBox(
              child: Lottie.asset(
                  'assets/animations/email.json',
                  repeat: true,
                  fit: BoxFit.contain
              ),
            ),
          ),
    
          const SizedBox(height: 30,),
    
          //Trường nhập mật khẩu
          Form(
            key: _formKey,
            child: TextFormField(
              controller: TextEditingController(text: Email),
              decoration: const InputDecoration(
                labelText: 'Email',
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
                  return 'Vui lòng nhập email để xác thực';
                }
                return null;
              },
              onChanged: (value){
                Email = value;
              },
            ),
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
                    bool checkEmail = await loginRepository.CheckUserEmail(context, Email);

                    //Nếu email tồn tại thì xác thực ma otp thành công thì chuyển qua trang đặt lại mật khẩu dựa trên email
                    if(checkEmail == true){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> VerificationCode_ForgotPwdScreen(verifyOtp: new verifyOtpModel('','',''), Email: Email,) ));
                    }
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
                child: const Text('Gửi mail để xác thực', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,))
            ),
          ),
        ],),
      ),
    );
  }
}







