import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/config/AppConfig.dart';
import 'package:votesecure/src/core/network/CheckNetwork.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/main.dart';
import 'package:quickalert/quickalert.dart';

class Nonetwork extends StatefulWidget {
  static const routerName = '/nonetwork';
  const Nonetwork({super.key});

  @override
  State<Nonetwork> createState() => _NonetworkState();
}

class _NonetworkState extends State<Nonetwork> {
  ConnectionStatusSingleton connectionStatusSingleton =
    ConnectionStatusSingleton.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Bao quát trang
            Positioned(
                child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Color(0xff334d50), Color(0xff0f0f0f)],
                stops: [0, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            )),

            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  Flexible(
                      child: Container(
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1.5,
                      child: Lottie.asset(
                        'assets/animations/InternetLost.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  const Flexible(
                    child: Text(
                      'Không có kết nối mạng',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: TextButton(
                        onPressed: () async {
                          bool hasConection =
                            await ConnectionStatusSingleton.getInstance().checkConnection();
                          if(!hasConection){
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              title: "Error",
                              text: " Không kết nối được mạng",
                            );
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp() ));
                          }
                        },
                        child: Text(' Thử lại ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
