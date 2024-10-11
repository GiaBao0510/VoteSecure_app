import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';
import 'package:votesecure/src/presentation/pages/common/Policy/Policy_private.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/NoNetwork.dart';
import 'package:votesecure/src/presentation/pages/shared/ScanQRcodePageToRegister.dart';
import 'package:votesecure/src/presentation/pages/shared/SetPwdBasedOnEmail.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/pages/shared/ErorrServer.dart';
import 'package:votesecure/src/presentation/pages/voter/HomeVoter.dart';
import 'package:votesecure/src/presentation/pages/cadre/HomCadre.dart';
import 'package:votesecure/src/presentation/pages/candidate/HomeCadidate.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOtpAfterLogin.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOpt_ForgotPwd.dart';
import 'package:votesecure/src/presentation/pages/voter/UserInformationAfterScanningTheCode_page.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/account/Account.dart';
import 'package:votesecure/src/presentation/pages/voter/ListElections.dart';

final Map<String, WidgetBuilder> routes = {
  Nonetwork.routerName: (ctx) => Nonetwork(),
  loginPages.routeName: (ctx) => loginPages(),
  UserAccount.routeName: (ctx) => UserAccount(user: new ProfileModel(HoTen: '', GioiTinh: '', DiaChi: '', Email: '', SDT: '', HinhAnh: '', TenDanToc: '', NgaySinh: DateTime.now(), ID_Object: 'null'),),
  ServerErrorPage.routeName:(ctx) => ServerErrorPage(ErrorRecordedInText: "",),
  LoadingPage.routeName:(ctx) => LoadingPage(),
  homeVoter.routeName:(ctx) => homeVoter(user: new ProfileModel(HoTen: '', GioiTinh: '', DiaChi: '', Email: '', SDT: '', HinhAnh: '', TenDanToc: '', NgaySinh: DateTime.now(), ID_Object: 'null'),),
  Homecadidate.routeName:(ctx) => Homecadidate(),
  HomeCadre.routeName:(ctx) => HomeCadre(),
  VerificationCodeScreen.routeName:(ctx) => VerificationCodeScreen(verifyOtp: new verifyOtpModel('','',''), Email: '',),
  VerificationCode_ForgotPwdScreen.routeName:(ctx) => VerificationCode_ForgotPwdScreen(verifyOtp: new verifyOtpModel('','',''),Email: '',),
  ChangePasswordScreen.routeName:(ctx) => ChangePasswordScreen(Email: '',),
  QRScannerPage.routeName:(ctx) => QRScannerPage(),
  UserProfilePage.routeName:(ctx) => UserProfilePage(voter: new Voterinformationafterscaningmodel('','','',DateTime.now(),'','','','') ,),
  ElectioncalenderScreen.routeName:(ctx) => ElectioncalenderScreen(),
  ListElectionsScreen.routeName:(ctx) => ListElectionsScreen(),
  PrivacyPolicyPage.routeName:(ctx) => ListElectionsScreen(),
  FeedbackPage.routeName:(ctx) => FeedbackPage(IDSender: '',),
};
