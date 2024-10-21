import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/data/models/ElectionsVotersHavePaticipated_Model.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/data/models/VerifyOtpModel.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';
import 'package:votesecure/src/presentation/pages/candidate/ListOfRegisteredCandidate.dart';
import 'package:votesecure/src/presentation/pages/common/Policy/Policy_private.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/common/profile/Profile.dart';
import 'package:votesecure/src/presentation/pages/shared/LoadingPage.dart';
import 'package:votesecure/src/presentation/pages/shared/NoNetwork.dart';
import 'package:votesecure/src/presentation/pages/shared/RegisterPage.dart';
import 'package:votesecure/src/presentation/pages/shared/ScanQRcodePageToRegister.dart';
import 'package:votesecure/src/presentation/pages/shared/SetPwdBasedOnEmail.dart';
import 'package:votesecure/src/presentation/pages/shared/login.dart';
import 'package:votesecure/src/presentation/pages/shared/ErorrServer.dart';
import 'package:votesecure/src/presentation/pages/voter/BallotForm.dart';
import 'package:votesecure/src/presentation/pages/voter/HomeVoter.dart';
import 'package:votesecure/src/presentation/pages/cadre/HomCadre.dart';
import 'package:votesecure/src/presentation/pages/candidate/HomeCadidate.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOtpAfterLogin.dart';
import 'package:votesecure/src/presentation/pages/shared/VerificationOpt_ForgotPwd.dart';
import 'package:votesecure/src/presentation/pages/voter/UserInformationAfterScanningTheCode_page.dart';
import 'package:votesecure/src/presentation/pages/common/ElectionCalender/ElectionCalender.dart';
import 'package:votesecure/src/presentation/pages/common/account/Account.dart';
import 'package:votesecure/src/presentation/pages/voter/ListElections.dart';

final HoSoNguoiDung = new ProfileModel(
    HoTen: '', GioiTinh: '', DiaChi: '', Email: '', SDT: '', HinhAnh: '',
    TenDanToc: '', NgaySinh: DateTime.now(), ID_Object: 'null', ID_User: 'null');

final CuTriDaDuocThamDuKyBauCu =  new ElectionVoterHavePaticipanted_Model(
    ngayBD: '', ngayKT: '', tenKyBauCu: '', mota: '', ghiNhan: '', tenDonViBauCu: '',
    soLuongToiDaCuTri: 0, soLuongToiDaUngCuVien: 0, soLuotBinhChonToiDa: 0,iD_Cap:0,iD_DonViBauCu:0);

final Map<String, WidgetBuilder> routes = {
  Nonetwork.routerName: (ctx) => Nonetwork(),
  loginPages.routeName: (ctx) => loginPages(),
  UserAccount.routeName: (ctx) => UserAccount(user: HoSoNguoiDung,),
  ServerErrorPage.routeName:(ctx) => ServerErrorPage(ErrorRecordedInText: "",),
  LoadingPage.routeName:(ctx) => LoadingPage(),
  homeVoter.routeName:(ctx) => homeVoter(user: HoSoNguoiDung,),
  Homecadidate.routeName:(ctx) => Homecadidate(user: HoSoNguoiDung,),
  HomeCadre.routeName:(ctx) => HomeCadre(),
  VerificationCodeScreen.routeName:(ctx) => VerificationCodeScreen(verifyOtp: new verifyOtpModel('','',''), Email: '',),
  VerificationCode_ForgotPwdScreen.routeName:(ctx) => VerificationCode_ForgotPwdScreen(verifyOtp: new verifyOtpModel('','',''),Email: '',),
  ChangePasswordScreen.routeName:(ctx) => ChangePasswordScreen(Email: '',),
  QRScannerPage.routeName:(ctx) => QRScannerPage(),
  UserProfilePage.routeName:(ctx) => UserProfilePage(voter: new Voterinformationafterscaningmodel('','','','','','','','') ,),
  ElectioncalenderScreen.routeName:(ctx) => ElectioncalenderScreen(),
  ListElectionsScreen.routeName:(ctx) => ListElectionsScreen(ID_object: '',),
  PrivacyPolicyPage.routeName:(ctx) => ListElectionsScreen(ID_object: '',),
  FeedbackPage.routeName:(ctx) => FeedbackPage(IDSender: '',),
  BallotForm.routeName:(ctx) => BallotForm(ngayBD: '',ID_object: '' ,
    electionDetails: CuTriDaDuocThamDuKyBauCu,),
  EditProfilePage.routeName:(ctx) => EditProfilePage(user:HoSoNguoiDung ,),
  RegisterAndSetPwdScreen.routeName:(ctx) => RegisterAndSetPwdScreen(SDT: '',),
  ListofRegisteredCandidateScreen.routeName:(ctx) => ListofRegisteredCandidateScreen(ID_ucv: '',),
};
