import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppBar.dart';

class VotingInstructionScreen extends StatelessWidget {
  static const routeName = '/voting-instruction';

  const VotingInstructionScreen({super.key});

  Widget _buildInstructionStep({
    required String stepNumber,
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      stepNumber,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Step description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Step image
          Container(
            height: 650,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Hướng dẫn bỏ phiếu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Introduction card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng bạn!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hãy làm theo các bước dưới đây để thực hiện bỏ phiếu của bạn.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            _buildInstructionStep(
              stepNumber: '1',
              title: 'Truy cập danh sách kỳ bầu cử',
              description: 'Sau khi đăng nhập và xác minh OTP thành công, tại trang chủ bạn hãy chọn mục "Xem danh sách kỳ bầu cử".',
              imagePath: 'assets/images/TrangChuCuTri.png',
            ),

            _buildInstructionStep(
              stepNumber: '2',
              title: 'Chọn kỳ bầu cử',
              description: 'Các kỳ bầu cử chưa bỏ phiếu sẽ có nền màu cam, đã bỏ phiếu sẽ có nền xanh dương.',
              imagePath: 'assets/images/DanhSachKyBauCuDaThamDu.png',
            ),

            _buildInstructionStep(
              stepNumber: '3',
              title: 'Thực hiện bỏ phiếu',
              description: 'Chọn ứng cử viên bạn muốn bình chọn. Lưu ý số lượt bình chọn có giới hạn.',
              imagePath: 'assets/images/PhieuBau.png',
            ),

            _buildInstructionStep(
              stepNumber: '4',
              title: 'Xem kết quả',
              description: 'Sau khi kết quả được công bố, bạn có thể xem tỷ lệ và số lượt bình chọn cho từng ứng cử viên.',
              imagePath: 'assets/images/TySoBinhChon.png',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}