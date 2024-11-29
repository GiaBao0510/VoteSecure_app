class CadreJoinedForElectionModel{
  final String
  tenKyBauCu,
      moTa,
      tenCapUngCu,
      tenDonViBauCu,
      ngayBD,
      ngayKT,
      CongBo,
      ghiNhan;
  int SoLuongToiDaCuTri,
      SoLuongToiDaUngCuVien,
      SoLuotBinhChonToiDa,
      iD_Cap, iD_DonViBauCu;


  //Ham nhập
  CadreJoinedForElectionModel({
    required this.tenKyBauCu,
    required this.moTa,
    required this.tenCapUngCu,
    required this.tenDonViBauCu,
    required this.ghiNhan,
    required this.ngayBD,
    required this.ngayKT,
    required this.CongBo,
    required this.SoLuongToiDaCuTri,
    required this.SoLuongToiDaUngCuVien,
    required this.SoLuotBinhChonToiDa,
    required this.iD_Cap,
    required this.iD_DonViBauCu,
  });

  CadreJoinedForElectionModel copywith({
    String? tenKyBauCu,
    String? moTa,
    String? ghiNhan,
    String? tenCapUngCu,
    String? tenDonViBauCu,
    String? ngayBD,
    String? ngayKT,
    String? CongBo,
    int? SoLuongToiDaCuTri,
    int? SoLuongToiDaUngCuVien,
    int? SoLuotBinhChonToiDa,
    int? iD_Cap,
    int? iD_DonViBauCu,
  }){
    return CadreJoinedForElectionModel(
        tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
        moTa:  moTa?? this.moTa,
        ghiNhan:  ghiNhan?? this.ghiNhan,
        tenCapUngCu: tenCapUngCu ?? this.tenCapUngCu,
        tenDonViBauCu: tenDonViBauCu ?? this.tenDonViBauCu,
        ngayBD: ngayBD ?? this.ngayBD,
        ngayKT: ngayKT ?? this.ngayKT,
        CongBo: CongBo ?? this.CongBo,
        SoLuongToiDaCuTri: SoLuongToiDaCuTri ?? this.SoLuongToiDaCuTri,
        SoLuongToiDaUngCuVien: SoLuongToiDaUngCuVien ?? this.SoLuongToiDaUngCuVien,
        SoLuotBinhChonToiDa: SoLuotBinhChonToiDa ?? this.SoLuotBinhChonToiDa,
        iD_Cap:  iD_Cap?? this.iD_Cap,
        iD_DonViBauCu: iD_DonViBauCu ?? this.iD_DonViBauCu,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'tenKyBauCu':tenKyBauCu,
      'moTa':moTa,
      'ghiNhan':ghiNhan,
      'tenCapUngCu':tenCapUngCu,
      'tenDonViBauCu':tenDonViBauCu,
      'ngayBD':ngayBD,
      'ngayKT':ngayKT,
      'CongBo':CongBo,
      'SoLuongToiDaCuTri':SoLuongToiDaCuTri,
      'SoLuongToiDaUngCuVien':SoLuongToiDaUngCuVien,
      'SoLuotBinhChonToiDa':SoLuotBinhChonToiDa,
      'iD_Cap':iD_Cap,
      'iD_DonViBauCu':iD_DonViBauCu,
    };
  }

  factory CadreJoinedForElectionModel.fromMap(Map<String, dynamic> map){
    return CadreJoinedForElectionModel(
      tenKyBauCu: map['tenKyBauCu'] ?? 'null',
      moTa: map['moTa'] ?? 'null',
      ghiNhan: map['ghiNhan'] ?? 'null',
      tenCapUngCu: map['tenCapUngCu'] ?? 'null',
      tenDonViBauCu: map['tenDonViBauCu'] ?? 'null',
      ngayBD: map['ngayBD'] ?? 'null',
      ngayKT: map['ngayKT'] ?? 'null',
      CongBo: map['congBo'] ?? 'null',
      iD_Cap: map['iD_Cap'] ?? -1,
      iD_DonViBauCu: map['iD_DonViBauCu'] ?? -1,
      SoLuongToiDaCuTri: map['soLuongToiDaCuTri'] is double ? map['soLuongToiDaCuTri'].toInt() : map['soLuongToiDaCuTri'] ?? 0,
      SoLuongToiDaUngCuVien: map['soLuongToiDaUngCuVien'] is double ? map['soLuongToiDaUngCuVien'].toInt() : map['soLuongToiDaUngCuVien'] ?? 0,
      SoLuotBinhChonToiDa: map['soLuotBinhChonToiDa'] is double ? map['soLuotBinhChonToiDa'].toInt() : map['soLuotBinhChonToiDa'] ?? 0,
    );
  }
}