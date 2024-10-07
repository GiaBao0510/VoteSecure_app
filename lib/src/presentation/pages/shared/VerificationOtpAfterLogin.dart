import 'dart:async';

import 'package:flutter/material.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/domain/repositories/WorkWithOtp.dart';
import 'package:provider/provider.dart';


class VerificationCodeScreen extends StatefulWidget {
  static const routeName = "/verification-after-login";
  final verifyOtpModel verifyOtp;
  const VerificationCodeScreen({
    super.key,
    required this.verifyOtp
  });

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState(verifyOtp: verifyOtp);
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();
  bool isButtonDisabled = false; // Biến kiểm soát trạng thái của nút
  int countdown = 30;
  Timer? _timer;
  final verifyOtpModel verifyOtp;

  _VerificationCodeScreenState({required this.verifyOtp});

  //hàm na dùng để bat đầu đếm ngược
  void startCountDown(){
    setState(() {
      isButtonDisabled = true;
      countdown = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          isButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
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
              "Xác thực mã OTP để hoàn thành bước đăng nhập",
              style:
              TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Stack(children: [
        widgetLibraryState.buildPageBackgroundGradient2Color(context, "0xff2522f7", "0xff4d91ff"),
        EmailVerificationForm(context)
      ],),
    );
  }

  //Biểu mẫu xác thực
  Widget EmailVerificationForm(BuildContext context){
    return Scrollbar(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext content,int index){
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [

                    //hoạt hình
                    const SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: BoxDecoration(
                          gradient:LinearGradient(
                            colors: [Color(0xffc6c7c6), Color(0xffffffff)],
                            stops: [0, 1],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ) ,
                      width: 250,
                      child: widgetLibraryState.buildAnimation(context, 'assets/animations/otpVerification2.json'),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Vui lòng nhập mã OTP để xác thực Email của bạn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    const SizedBox(height: 50.0),

                    _BuildNumberBoxes(context),

                    const SizedBox(height: 60),
                    _BuildSendButtom(context),

                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  //Xây dựng phần nút xác nhận
  Widget _BuildSendButtom(BuildContext context){
    final workWithOtpRepository = Provider.of<WorkWithOtpRepository>(context, listen: false);

    return  Row(
      children: [
        Flexible(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigoAccent,
              fixedSize: Size(130,50),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String verificationCode = '';
                for (var controller in _controllers) {
                  verificationCode += controller.text;
                }
                print('Verification Code: $verificationCode');
                verifyOtp.Otp = verificationCode;
                await workWithOtpRepository.VerificationOtpAfter(context, verifyOtp);
              }
            },
            child: const Text('Xác thực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
        ),
        const SizedBox(width: 20,),
        Flexible(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white30,
                foregroundColor: Colors.white,
                fixedSize: Size(200,50),
                shadowColor:  isButtonDisabled ? Colors.grey : Colors.transparent,  //Điều chỉnh độ mo nút
                elevation: isButtonDisabled ? 5:0
            ),
            onPressed: isButtonDisabled ? null : () {
              setState(() {
                startCountDown();
              });

              Future.delayed((Duration(seconds: 30)),(){
                setState(() {
                  isButtonDisabled = false;   //Kích hoọt nút gửi lại mã
                });
              });

              print("Đã gửi lai mã");

            },
            child: Text(
              isButtonDisabled ? 'Gửi lại: $countdown' : 'Gửi lại',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }

  //Xây dựng phần các ô nút điền số
  Widget _BuildNumberBoxes(BuildContext context){
    bool isSnackBarDisplay = false;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints ){
          double boxSize = (constraints.maxWidth - 50) / 6;  //Trừ i khoảng cách giữa các
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 6; i++)
                Container(
                  width: boxSize,
                  height: boxSize,
                  padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: TextFormField(

                    controller: _controllers[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLength: 1,
                    decoration: InputDecoration(
                      filled: true,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if(!isSnackBarDisplay){
                          isSnackBarDisplay = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Vui lòng điền đầy đủ ô tước khi gửi mã OTP.'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 1 && i < 6) {
                        FocusScope.of(context).nextFocus();
                      }
                      isSnackBarDisplay = false;
                    },
                  ),
                ),
            ],
          );
        }
    );
  }
}