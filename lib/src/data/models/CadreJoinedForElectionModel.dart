class CadreJoinedForElectionModel{
  final String?
  tenKyBauCu,
      moTa,
      tenCapUngCu,
      tenDonViBauCu,
      ngayBD,
      ngayKT,
      CongBo;
  int? SoLuongToiDaCuTri,
      SoLuongToiDaUngCuVien,
      SoLuotBinhChonToiDa;


  //Ham nhập
  CadreJoinedForElectionModel({
    required this.tenKyBauCu,
    required this.moTa,
    required this.tenCapUngCu,
    required this.tenDonViBauCu,
    required this.ngayBD,
    required this.ngayKT,
    required this.CongBo,
    required this.SoLuongToiDaCuTri,
    required this.SoLuongToiDaUngCuVien,
    required this.SoLuotBinhChonToiDa,
  });

  CadreJoinedForElectionModel copywith({
    String? tenKyBauCu,
    String? moTa,
    String? tenCapUngCu,
    String? tenDonViBauCu,
    String? ngayBD,
    String? ngayKT,
    String? CongBo,
    int? SoLuongToiDaCuTri,
    int? SoLuongToiDaUngCuVien,
    int? SoLuotBinhChonToiDa,
  }){
    return CadreJoinedForElectionModel(
        tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
        moTa:  moTa?? this.moTa,
        tenCapUngCu: tenCapUngCu ?? this.tenCapUngCu,
        tenDonViBauCu: tenDonViBauCu ?? this.tenDonViBauCu,
        ngayBD: ngayBD ?? this.ngayBD,
        ngayKT: ngayKT ?? this.ngayKT,
        CongBo: CongBo ?? this.CongBo,
        SoLuongToiDaCuTri: SoLuongToiDaCuTri ?? this.SoLuongToiDaCuTri,
        SoLuongToiDaUngCuVien: SoLuongToiDaUngCuVien ?? this.SoLuongToiDaUngCuVien,
        SoLuotBinhChonToiDa: SoLuotBinhChonToiDa ?? this.SoLuotBinhChonToiDa,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'tenKyBauCu':tenKyBauCu,
      'moTa':moTa,
      'tenCapUngCu':tenCapUngCu,
      'tenDonViBauCu':tenDonViBauCu,
      'ngayBD':ngayBD,
      'ngayKT':ngayKT,
      'CongBo':CongBo,
      'SoLuongToiDaCuTri':SoLuongToiDaCuTri,
      'SoLuongToiDaUngCuVien':SoLuongToiDaUngCuVien,
      'SoLuotBinhChonToiDa':SoLuotBinhChonToiDa,
    };
  }

  factory CadreJoinedForElectionModel.fromMap(Map<String, dynamic> map){
    return CadreJoinedForElectionModel(
      tenKyBauCu: map['tenKyBauCu'] ?? 'null',
      moTa: map['moTa'] ?? 'null',
      tenCapUngCu: map['tenCapUngCu'] ?? 'null',
      tenDonViBauCu: map['tenDonViBauCu'] ?? 'null',
      ngayBD: map['ngayBD'] ?? 'null',
      ngayKT: map['ngayKT'] ?? 'null',
      CongBo: map['congBo'] ?? 'null',
      SoLuongToiDaCuTri: map['soLuongToiDaCuTri'] ?? 0,
      SoLuongToiDaUngCuVien: map['soLuongToiDaUngCuVien'] ?? 0,
      SoLuotBinhChonToiDa: map['soLuotBinhChonToiDa'] ?? 0,
    );
  }
}