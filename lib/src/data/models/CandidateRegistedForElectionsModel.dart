class CandidateRegistedForElectionsModel{
  final String?
  tenKyBauCu,
      moTa,
      tenCapUngCu,
      tenDonViBauCu,
      ngayBD,
      ngayKT;

  //Ham nhập
  CandidateRegistedForElectionsModel({
    required this.tenKyBauCu,
    required this.moTa,
    required this.tenCapUngCu,
    required this.tenDonViBauCu,
    required this.ngayBD,
    required this.ngayKT
  });

  CandidateRegistedForElectionsModel copywith({
    String? tenKyBauCu,
    String? moTa,
    String? tenCapUngCu,
    String? tenDonViBauCu,
    String? ngayBD,
    String? ngayKT,
  }){
    return CandidateRegistedForElectionsModel(
        tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
        moTa:  moTa?? this.moTa,
        tenCapUngCu: tenCapUngCu ?? this.tenCapUngCu,
        tenDonViBauCu: tenDonViBauCu ?? this.tenDonViBauCu,
        ngayBD: ngayBD ?? this.ngayBD,
        ngayKT: ngayKT ?? this.ngayKT
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
    };
  }

  factory CandidateRegistedForElectionsModel.fromMap(Map<String, dynamic> map){
    return CandidateRegistedForElectionsModel(
      tenKyBauCu: map['tenKyBauCu'] ?? 'null',
      moTa: map['moTa'] ?? 'null',
      tenCapUngCu: map['tenCapUngCu'] ?? 'null',
      tenDonViBauCu: map['tenDonViBauCu'] ?? 'null',
      ngayBD: map['ngayBD'] ?? 'null',
      ngayKT: map['ngayKT'] ?? 'null',
    );
  }
}