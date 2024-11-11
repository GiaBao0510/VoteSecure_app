import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/core/network/CheckNetwork.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/CadreRepository.dart';
import 'package:votesecure/src/domain/repositories/CandidateRepository.dart';
import 'package:votesecure/src/domain/repositories/DetailNoticeRepository.dart';
import 'package:votesecure/src/domain/repositories/ElectionResultDetailRepository.dart';
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
import 'package:votesecure/src/presentation/pages/shared/ServerHealthCheck.dart';
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginRepository() ),
      ChangeNotifierProvider(create: (_) => EnterEmailToVerifyRepository()),
      ChangeNotifierProvider(create: (_) => WorkWithOtpRepository()),
      ChangeNotifierProvider(create: (_) => TokenRepository()),
      ChangeNotifierProvider(create: (_) => VoterRepository()),
      ChangeNotifierProvider(create: (_) => UserRepository()),
      ChangeNotifierProvider(create: (_) => CandidateRepository()),
      ChangeNotifierProvider(create: (_) => CadreRepository()),
      ChangeNotifierProvider(create: (_) => DetailNoticeRepository()),
      ChangeNotifierProvider(create: (_) => ElectionResultDetailRepository()),
    ],
      child:  MyApp()
    )
  );
}

//Chỉ hoạt động trên đây
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final HoSoNguoiDung = new ProfileModel
    (SDT: 'null',HoTen: 'null',GioiTinh: 'null',
      Email:'null', DiaChi: 'null',HinhAnh: 'null',
      NgaySinh: DateTime.now(),TenDanToc: 'null', ID_Object: 'null', ID_User: 'null');

  Future<Widget> ApplicationInitialization(BuildContext context) async{
    //Kiểm tra kết nối mạng
    bool hasConection =
      await ConnectionStatusSingleton.getInstance().checkConnection();

    //Kiem tra kết nối mạng
    if(!hasConection)
      return Nonetwork();

    //Kiem tra kết nối đến server
    bool serverConnected = await ServerHealthCheck().checkServerConnection();
    if(!serverConnected){
      return ServerErrorPage(
          ErrorRecordedInText: "Không thể kết nối đến máy chủ. Vui lòng thử lại sau."
      );
    }

    //Kiểm tra đăng nhập
    LoginRepository loginRepository = Provider.of<LoginRepository>(context, listen: false);
    int Logined = await loginRepository.CheckLogined(context);

    switch(Logined){
      case -1: return loginPages();
      case 2: return Homecadidate(user: HoSoNguoiDung,);
      case 5: return HomeVoter(user:HoSoNguoiDung,);
      case 8: return HomeCadre(user:HoSoNguoiDung);
      default: return loginPages();
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