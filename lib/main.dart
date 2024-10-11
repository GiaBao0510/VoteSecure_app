import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/config/AppConfig.dart';
import 'package:votesecure/src/core/network/CheckNetwork.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/domain/repositories/EnterEmailToVerify_repository.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/domain/repositories/Token_Repositories.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/domain/repositories/WorkWithOtp.dart';
import 'package:votesecure/src/domain/repositories/login_repository.dart';
import 'package:votesecure/src/presentation/pages/cadre/HomCadre.dart';
import 'package:votesecure/src/presentation/pages/candidate/HomeCadidate.dart';
import 'package:votesecure/src/presentation/pages/shared/ErorrServer.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/pages/routes.dart';
import 'package:votesecure/src/presentation/pages/shared/NoNetwork.dart';
import 'package:votesecure/src/presentation/pages/voter/HomeVoter.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  ConnectionStatusSingleton connectionStatusSingleton =
      ConnectionStatusSingleton.getInstance();
  connectionStatusSingleton.initialize();

  final appConfig = AppconfigState();
  await appConfig.loadApi_json();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppconfigState()),
      ChangeNotifierProvider(create: (_) => LoginRepository() ),
      ChangeNotifierProvider(create: (_) => EnterEmailToVerifyRepository()),
      ChangeNotifierProvider(create: (_) => WorkWithOtpRepository()),
      ChangeNotifierProvider(create: (_) => TokenRepository()),
      ChangeNotifierProvider(create: (_) => VoterRepository()),
      ChangeNotifierProvider(create: (_) => UserRepository()),
      ChangeNotifierProvider(create: (_) => CandidateRepository()),
    ],
      child:  MyApp()
    )
  );
}

//Chỉ hoạt động trên đây
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> ApplicationInitialization(BuildContext context) async{
    //Kiểm tra kết nối mạng
    bool hasConection =
      await ConnectionStatusSingleton.getInstance().checkConnection();

    if (hasConection) {
      print("có kết nôi dên wifi");

      //Kiểm tra đăng nhập
      LoginRepository loginRepository = Provider.of<LoginRepository>(context, listen: false);
      int Logined = await loginRepository.CheckLogined(context);

      switch(Logined){
        case -1: return loginPages();
        case 2: return Homecadidate();
        case 5: return homeVoter(user:
          ProfileModel
            (SDT: 'null',HoTen: 'null',GioiTinh: 'null',
            Email:'null', DiaChi: 'null',HinhAnh: 'null',
            NgaySinh: DateTime.now(),TenDanToc: 'null', ID_Object: 'null')
          ,);
        case 8: return HomeCadre();
        default: return loginPages();
      }
    }else{
      return Nonetwork();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bầu cử trực tuyến',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<Widget>(
        future: ApplicationInitialization(context),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return RefreshIndicator(
                child: snapshot.data!,
                onRefresh: () => ApplicationInitialization(context)
            );
          }else if(snapshot.hasError){
            String Loi =  snapshot.error?.toString() ?? "Đã xảy ra lỗi không xác định";
            print('Lỗi server: ${Loi}');
            return ServerErrorPage(ErrorRecordedInText: Loi);
          }else{
            return LoadingPage();
          }
        },
      ),
      routes: routes,
    );
  }
}