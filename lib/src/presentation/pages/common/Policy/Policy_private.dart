import 'package:flutter/material.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const routeName = 'policy-private';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(textTitle: 'Chính Sách Quyền Riêng Tư',),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffeeee), Color(0xffd0dabe)],
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Thông Tin Chúng Tôi Thu Thập'),
              _buildSectionContent(
                  'Khi bạn sử dụng VoteSecure CTU, chúng tôi có thể thu thập một số thông tin cá nhân và thông tin phi cá nhân từ bạn.'),
              _buildSectionContent(
                  'Thông Tin Cá Nhân: Bao gồm tên, số điện thoại, địa chỉ email, và các thông tin cần thiết để xác thực bạn là cử tri hợp pháp.'),
              _buildSectionContent(
                  'Thông Tin Thiết Bị: Như loại thiết bị, hệ điều hành, phiên bản ứng dụng và thông tin mạng.'),
              _buildSectionContent(
                  'Thông Tin Về Bỏ Phiếu: Chúng tôi không lưu trữ thông tin cụ thể về phiếu bầu của bạn, nhưng có thể lưu trữ các dữ liệu liên quan đến quá trình bỏ phiếu như thời gian bỏ phiếu và mã hóa liên quan.'),

              _buildSectionTitle('2. Cách Chúng Tôi Sử Dụng Thông Tin'),
              _buildSectionContent(
                  'Xác Thực Cử Tri: Thông tin cá nhân của bạn sẽ được sử dụng để xác thực tư cách cử tri trước khi cho phép bạn tham gia bỏ phiếu.'),
              _buildSectionContent(
                  'Đảm Bảo Bảo Mật Phiếu Bầu: Chúng tôi sử dụng mã hóa để bảo vệ phiếu bầu của bạn và bảo mật thông tin trong suốt quá trình bầu cử.'),

              _buildSectionTitle('3. Bảo Mật Thông Tin'),
              _buildSectionContent(
                  'Mã Hóa Dữ Liệu: Chúng tôi sử dụng các giải thuật mã hóa hiện đại như Pailier và RSA để đảm bảo rằng thông tin cá nhân và dữ liệu phiếu bầu của bạn luôn được bảo vệ.'),

              _buildSectionTitle('4. Chia Sẻ Thông Tin'),
              _buildSectionContent(
                  'Với Bên Thứ Ba: Chúng tôi không chia sẻ thông tin cá nhân của bạn với bên thứ ba trừ khi có sự đồng ý của bạn hoặc theo yêu cầu pháp lý.'),

              _buildSectionTitle('5. Quyền Lợi Của Bạn'),
              _buildSectionContent(
                  'Quyền Xem Xét Thông Tin: Bạn có quyền yêu cầu xem xét, cập nhật, hoặc xóa thông tin cá nhân mà chúng tôi đã thu thập từ bạn.'),

              _buildSectionTitle('6. Thời Gian Lưu Trữ Thông Tin'),
              _buildSectionContent(
                  'Chúng tôi chỉ lưu trữ thông tin cá nhân của bạn trong khoảng thời gian cần thiết để thực hiện các mục đích đã nêu trong chính sách này.'),

              _buildSectionTitle('7. Thay Đổi Chính Sách Quyền Riêng Tư'),
              _buildSectionContent(
                  'Chính sách này có thể được thay đổi theo thời gian để phản ánh các cập nhật về hệ thống hoặc quy định pháp luật mới.'),

              _buildSectionTitle('8. Cam Kết Của Chúng Tôi'),
              _buildSectionContent(
                  'Chúng tôi cam kết duy trì các tiêu chuẩn bảo mật cao nhất để đảm bảo rằng thông tin cá nhân của bạn luôn được bảo vệ.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
