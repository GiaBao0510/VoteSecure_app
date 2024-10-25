import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'package:votesecure/src/presentation/pages/common/Policy/Policy_private.dart';
import 'package:votesecure/src/presentation/pages/common/SupportInformationSubmission/SupportInformationSubmission_page.dart';
import 'package:votesecure/src/presentation/pages/common/profile/Profile.dart';

class UserAccount extends StatelessWidget {
  static const routeName = 'user-account';
  final ProfileModel user;
  final String uri;
  final UserRepository userRepository = UserRepository();

  UserAccount({
    super.key,
    required this.user,
    required this.uri
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox(height: 20),
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff1321e7), Color(0xff3f5efb)],
                      stops: [0.25, 0.75],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                 child:Row(
                   children: [
                     Expanded(
                       flex:1,
                       child: CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage('${user.HinhAnh}'),
                          //backgroundImage: , // Hình ảnh avatar
                        ),
                     ),
                     const SizedBox(width: 15,),
                     Expanded(
                       flex: 2,
                         child: Column(children: [
                           SizedBox(height: 20),
                           Text(
                             '${user.HoTen}',
                             style: const TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold,
                               color: Colors.white
                             ),
                           ),
                           const SizedBox(height: 10),
                           Text(
                             '${user.Email}',
                             style:const TextStyle(
                               fontSize: 16,
                               color: Colors.white,
                             ),
                             textAlign: TextAlign.center,
                           ),
                           const SizedBox(height: 5),
                           TextButton(
                               onPressed: (){
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => EditProfilePage(user: user,))
                                 );
                               },
                               child: RichText(
                                 textAlign: TextAlign.center,
                                   text: const TextSpan(
                                     style: TextStyle(decoration: TextDecoration.underline,),
                                     children: [
                                       WidgetSpan(
                                           child: Icon(Icons.info_outline, color: Colors.white,),
                                       ),
                                       TextSpan(text: ' Chi tiết.', style: TextStyle(fontSize: 18)),
                                     ]
                                   )
                               ),
                           ),
                         ],)
                     ),
                   ],
                 ),
                ),

                SizedBox(height: 30),
                _buildProfileOption(
                  icon: Icons.settings,
                  title: 'Quyền truy cập',
                  onTap: () async{
                    await openAppSettings();
                  },
                ),
                _buildProfileOption(
                  icon: Icons.policy_outlined,
                  title: 'Chính sách',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrivacyPolicyPage())
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.send_sharp,
                  title: 'Gửi liên hệ hỗ trợ',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage(IDSender: user.ID_Object ?? '' ,uri:  uri,))
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.info,
                  title: 'Xem hướng dẫn bỏ phiếu',
                  onTap: () {},
                ),
                Divider(),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () async{
                    // Xử lý khi nhấn vào nút "Edit Profile"
                    await userRepository.LogOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: ' Đăng xuất ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          WidgetSpan(child: Icon(Icons.logout, color: Colors.white,),),
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
        required String title,
        required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
