import 'package:flutter/material.dart';
import 'package:votesecure/src/data/models/VoterInformationAfterScaningModel.dart';

class UserProfilePage extends StatelessWidget {
  static const routeName = 'voter-information-after-scanning-theCode';
  final Voterinformationafterscaningmodel voter;

  UserProfilePage({required this.voter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left_sharp,
              color: Colors.indigo,
              size: 30,
              weight: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
                'Thông tin người dùng',
                style: TextStyle(
                    color: Colors.indigo, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                _buildAvatar(context),
                const SizedBox(height: 16),
                Text(
                  '${voter.hoten == null ? 'null': voter.hoten }',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildInfoRow('Giới tính', '${voter.gioiTinh }'),
                _buildInfoRow('Ngày sinh', '${voter.ngaySinh}'),
                _buildInfoRow('Email', '${voter.Email}'),
                _buildInfoRow('Số điện thoại', '${voter.sdt}'),
                _buildInfoRow('Dân tộc', '${voter.tenDanToc}'),
                _buildInfoRow('Địa chỉ', '${voter.diaChiLienLac}'),
                const SizedBox(height: 24),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Xử lý khi nút được nhấn
                },
                label: Text('Đi đến đặt mật khẩu'),
                icon: Icon(Icons.lock),
                backgroundColor: Color.fromRGBO(18, 77, 218, 1.0),
                foregroundColor: Color.fromRGBO(253, 253, 253, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4b99ec), Color(0xff14356c)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      height: 200,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          '${voter.hinhAnh}',
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}