class ElectionResultsDetailModel{
  final String?
    ngayBD,
    ngayKT,
    tenKyBauCu,
    tenCapUngCu,
    tenDonViBauCu,
    moTa,
    congBo;

  //Ham nhập
  ElectionResultsDetailModel({
    required this.ngayBD,
    required this.ngayKT,
    required this.tenKyBauCu,
    required this.tenCapUngCu,
    required this.tenDonViBauCu,
    required this.moTa,
    required this.congBo,
  });

  ElectionResultsDetailModel copywith({
    String? ngayBD,
    String? ngayKT,
    String? tenKyBauCu,
    String? tenCapUngCu,
    String? tenDonViBauCu,
    String? moTa,
    String? congBo,
  }){
    return ElectionResultsDetailModel(
      ngayBD: ngayBD ?? this.ngayBD,
      ngayKT:  ngayKT?? this.ngayKT,
      tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
      tenCapUngCu: tenCapUngCu ?? this.tenCapUngCu,
      tenDonViBauCu: tenDonViBauCu ?? this.tenDonViBauCu,
      moTa: moTa ?? this.moTa,
      congBo: congBo ?? this.congBo,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'ngayBD':ngayBD,
      'ngayKT':ngayKT,
      'tenKyBauCu':tenKyBauCu,
      'tenCapUngCu':tenCapUngCu,
      'tenDonViBauCu':tenDonViBauCu,
      'moTa':moTa,
      'congBo':congBo,
    };
  }

  factory ElectionResultsDetailModel.fromMap(Map<String, dynamic> map){
    return ElectionResultsDetailModel(
      ngayBD: map['ngayBD'] ?? 'null',
      ngayKT: map['ngayKT'] ?? 'null',
      tenKyBauCu: map['tenKyBauCu'] ?? 'null',
      tenCapUngCu: map['tenCapUngCu'] ?? 'null',
      tenDonViBauCu: map['tenDonViBauCu'] ?? 'null',
      moTa: map['moTa'] ?? 'null',
      congBo: map['congBo'] ?? 'null',
    );
  }

}