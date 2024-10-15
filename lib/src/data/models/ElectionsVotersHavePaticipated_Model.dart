import 'package:intl/intl.dart';

class ElectionVoterHavePaticipanted_Model{
  final String ngayBD, ngayKT;
  final String? tenKyBauCu, mota, ghiNhan, tenDonViBauCu;
  final int soLuongToiDaCuTri, soLuongToiDaUngCuVien, soLuotBinhChonToiDa,
      iD_Cap,iD_DonViBauCu;

  ElectionVoterHavePaticipanted_Model({
    required this.ngayBD,
    required this.ngayKT,
    required this.tenKyBauCu,
    required this.mota,
    required this.ghiNhan,
    required this.tenDonViBauCu,
    required this.soLuongToiDaCuTri,
    required this.soLuongToiDaUngCuVien,
    required this.soLuotBinhChonToiDa,
    required this.iD_Cap,
    required this.iD_DonViBauCu,
  });

  ElectionVoterHavePaticipanted_Model copywith({
    String? tenKyBauCu,
    String? mota,
    String? ngayBD,
    String? ngayKT,
    String? ghiNhan,
    String? tenDonViBauCu,
    int? soLuongToiDaCuTri,
    int? soLuongToiDaUngCuVien,
    int? soLuotBinhChonToiDa,
    int? iD_Cap,
    int? iD_DonViBauCu,
  }){
    return ElectionVoterHavePaticipanted_Model(
      tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
      mota:  mota?? this.mota,
      ngayBD: ngayBD ?? this.ngayBD,
      ngayKT: ngayKT ?? this.ngayKT,
      ghiNhan:  ghiNhan?? this.ghiNhan,
      tenDonViBauCu:  tenDonViBauCu?? this.tenDonViBauCu,
      soLuongToiDaCuTri: soLuongToiDaCuTri?? this.soLuongToiDaCuTri,
      soLuongToiDaUngCuVien: soLuongToiDaUngCuVien ?? this.soLuongToiDaUngCuVien,
      soLuotBinhChonToiDa: soLuotBinhChonToiDa ?? this.soLuotBinhChonToiDa,
      iD_Cap:  iD_Cap?? this.iD_Cap,
      iD_DonViBauCu: iD_DonViBauCu ?? this.iD_DonViBauCu,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'tenKyBauCu':tenKyBauCu,
      'mota':mota,
      'ngayBD':ngayBD,
      'ngayKT':ngayKT,
      'ghiNhan':ghiNhan,
      'tenDonViBauCu':tenDonViBauCu,
      'soLuongToiDaCuTri':soLuongToiDaCuTri,
      'soLuongToiDaUngCuVien':soLuongToiDaUngCuVien,
      'soLuotBinhChonToiDa':soLuotBinhChonToiDa,
      'iD_Cap':iD_Cap,
      'iD_DonViBauCu':iD_DonViBauCu,
    };
  }

  factory ElectionVoterHavePaticipanted_Model.fromMap(Map<String, dynamic> map){
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    return ElectionVoterHavePaticipanted_Model(
      tenKyBauCu: map['tenKyBauCu'] ?? 'null',
      mota: map['mota'] ?? 'null',
      ngayBD: map['ngayBD'] ?? 'null',
      ngayKT: map['ngayKT'] ?? 'null',
      ghiNhan: map['ghiNhan'] ?? 'null',
      tenDonViBauCu: map['tenDonViBauCu'] ?? 'null',
      soLuongToiDaCuTri: map['soLuongToiDaCuTri'],
      soLuongToiDaUngCuVien: map['soLuongToiDaUngCuVien'],
      soLuotBinhChonToiDa: map['soLuotBinhChonToiDa'],
      iD_Cap: map['iD_Cap'] ?? 'null',
      iD_DonViBauCu: map['iD_DonViBauCu'] ?? 'null',
    );
  }
}