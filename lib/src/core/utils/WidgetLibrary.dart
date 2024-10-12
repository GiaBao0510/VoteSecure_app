import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';


class Widgetlibrary extends StatefulWidget {
  const Widgetlibrary({super.key});

  @override
  State<Widgetlibrary> createState() => WidgetlibraryState();
}

class WidgetlibraryState extends State<Widgetlibrary> {

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
    return const Placeholder();
  }

  //Hoạt hình
  Widget buildAnimation(BuildContext context, String path){
    return Lottie.asset(
      path, repeat: true, fit: BoxFit.contain
    );
  }

  //Trang nền. trên hình ảnh
  Widget buildPageBackground(BuildContext context, String pathImage){
    return //Maàu nền
      Positioned(
        child: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(pathImage),
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

  //Trang nền. màu đã được đổ
  Widget buildPageBackgroundGradient2Color(BuildContext context, String color1, String color2){
    int hexValue1 = int.parse(color1)
        ,hexValue2 = int.parse(color2);
    return //Maàu nền
      Positioned(
          child: Container(
              width: double.infinity,
              height: double.infinity,

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(hexValue1), Color(hexValue2)],
                    stops: [0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
          )
      );
  }

  //Trang nền. màu đã được đổ
  Widget buildPageBackgroundGradient3Color(BuildContext context, String color1, String color2, String color3){
    int hexValue1 = int.parse(color1.substring(2), radix: 16)
    ,hexValue2 = int.parse(color2.substring(2), radix: 16),
    hexValue3 = int.parse(color3.substring(2), radix: 16);

    return //Maàu nền
      Positioned(
          child: Container(
              width: double.infinity,
              height: double.infinity,

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(hexValue1), Color(hexValue2), Color(hexValue3)],
                    stops: [0, 0.5, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
          )
      );
  }

  Future<Widget> buildingAwaitingFeedback(BuildContext context) async {
    // Chờ đợi
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: LoadingPage()
        );
      },
    );
  }

  Future<Widget> buildingAwaitingFeedback_2(BuildContext context) async {
    // Chờ đợi
    return await showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép đóng dialog khi người dùng nhấn ra ngoài
      builder: (BuildContext context) {
        return Center(
          child: LoadingPage(),
        );
      },
    );
  }

  //Xây dựng nút chức năng
  Widget buildMenuItem(BuildContext context ,String title, IconData icon, String path) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, path);
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff44a4fd), Color(0xff3f5efb)],
                    stops: [0.25, 0.75],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 50,
              width: 50,
              child: Icon(icon, size: 40,color: Colors.white,)
          ),
          SizedBox(height: 8),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                title, style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              )
          ),
        ],
      ),
    );
  }

  String DateTimeFormat(String thoidiem){
    DateTime dateTime = DateTime.parse(thoidiem);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  String DateFormat2(String thoidiem){
    DateTime dateTime = DateTime.parse(thoidiem);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

}
