import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  static const routeName = "/loading";

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  WidgetlibraryState widgetLibraryState = WidgetlibraryState();

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
        body: Stack(children: [
          widgetLibraryState.buildPageBackgroundGradient2Color(context, '0xffe0eafc','0xffcfdef3'),
          BuildServerErrorFrame(context),
        ],),
      ),
    );
  }

  Widget BuildServerErrorFrame(BuildContext context){
    return Align(
        alignment: Alignment.center,
        child: Column(children: [
          const SizedBox(height: 230,),
          //Hoạt hình
          FractionallySizedBox(
            widthFactor: 1,
            child: widgetLibraryState.buildAnimation(context, 'assets/animations/loading4.json')
          ),

        ],)
    );
  }
}
