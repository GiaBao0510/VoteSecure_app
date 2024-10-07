import 'package:flutter/material.dart';
import 'package:votesecure/main.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';


class ServerErrorPage extends StatefulWidget {
  static const routeName = "/errorserver";
  final String? ErrorRecordedInText;
  const ServerErrorPage({
    super.key,
    required this.ErrorRecordedInText
  });

  @override
  State<ServerErrorPage> createState() => _ServerErrorPageState(ErrorRecordedInText: ErrorRecordedInText);
}

class _ServerErrorPageState extends State<ServerErrorPage> {
  final String? ErrorRecordedInText;
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

  _ServerErrorPageState({required this.ErrorRecordedInText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          widgetLibraryState.buildPageBackground(context, 'assets/images/backgroundErrorServer.jpg'),
          BuildServerErrorFrame(context),
        ],),
      ),
    );
  }

  Widget BuildServerErrorFrame(BuildContext context){
    return Align(
        alignment: Alignment.center,
        child: Column(children: [
          const SizedBox(height: 70,),
          //Hoạt hình
          Flexible(
            flex: 3,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Lottie.asset(
                  'assets/animations/Error500.json',
                  repeat: true,
                  fit: BoxFit.contain
                ),
              ),
          ),

          //Nội dung
          Flexible(
            child:Text(
              "Lỗi máy chủ nội bộ. ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40,),
          Flexible(
            flex: 3,
              child: FractionallySizedBox(
                heightFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0
                      )]
                    ),
                    child: Scrollbar(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder:(BuildContext content, int index){
                            return Text("${ErrorRecordedInText}");
                          },
                        )
                    ),
                  ),
                ),
              )
          ),

          //Nút reset tro về main
          const SizedBox(height: 20,),
          Flexible(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp() ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Text(' Thử lại ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                ),
              )
          ),

        ],)
    );
  }
}