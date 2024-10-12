import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/presentation/widgets/TitleAppbarLight.dart';
import 'package:votesecure/src/data/models/CandidateListBasedOnElctionDateModel.dart';

class CandidateInfoPage extends StatelessWidget {
  static const routeName = 'candidate-introduction';
  final CandidateListBasedonElEctionDateModel candidateInfo;
  CandidateInfoPage({super.key,required this.candidateInfo});
  WidgetlibraryState widgetlibraryState = WidgetlibraryState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppTitleLight(textTitle: 'Thông tin ứng cử viên',),
        body: Stack(
          children: [
            // Ảnh nền của ứng cử viên
            _buildWallpaper(context),

            // Nội dung phía trước
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${DateTime.now().day}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${DateTime.now().month}',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Thông tin về ứng cử viên
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${candidateInfo.HoTen}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widgetlibraryState.DateFormat2(candidateInfo.NgaySinh  ?? '')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${candidateInfo.GioiThieu}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'www.activote.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Xây dựng ảnh nền
  Widget _buildWallpaper(BuildContext context){
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
          NetworkImage("${candidateInfo.HinhAnh}"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
