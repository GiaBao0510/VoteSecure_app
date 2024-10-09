import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';

class AppTitleHomePage extends StatelessWidget implements PreferredSizeWidget {
  final ProfileModel user;
  const AppTitleHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfffafafa), Color(0xffdddddf)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
      title: FittedBox(
        fit:BoxFit.fitWidth,
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min, // Để giải quyết lỗi
            children: [
              Flexible(
                flex: 1,
                //fit: FlexFit.loose, // Thay thế Expanded bằng FlexFit.loose
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logoApp.jpg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    Text(
                      'VoteSecure',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [Colors.black87, Colors.indigo],
                            ).createShader(Rect.fromLTWH(0, 0, 100, 40)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20,),
              Flexible(
                flex: 2,
                //fit: FlexFit.loose, // Thay thế Expanded bằng FlexFit.loose
                child: Text(
                  'Xin Chào ${user.HoTen}',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


