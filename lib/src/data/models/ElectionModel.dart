import 'package:intl/intl.dart';

class ElectionModel{
  final DateTime ngayBD, ngayKT;
  final String? tenKyBauCu, mota;

  ElectionModel({
    required this.ngayBD,
    required this.ngayKT,
    required this.tenKyBauCu,
    required this.mota,
  });

  ElectionModel copywith({
    String? tenKyBauCu,
    String? mota,
    DateTime? ngayBD,
    DateTime? ngayKT
  }){
    return ElectionModel(
        tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
        mota:  mota?? this.mota,
        ngayBD: ngayBD ?? this.ngayBD,
        ngayKT: ngayKT ?? this.ngayKT
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'tenKyBauCu':tenKyBauCu,
      'mota':mota,
      'ngayBD':ngayBD,
      'ngayKT':ngayKT
    };
  }

  factory ElectionModel.fromMap(Map<String, dynamic> map){
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    return ElectionModel(
      tenKyBauCu: map['tenKyBauCu'],
      mota: map['mota'],
      ngayBD: dateFormat.parse(map['ngayBD']),
      ngayKT: dateFormat.parse(map['ngayKT'])
    );
  }
}