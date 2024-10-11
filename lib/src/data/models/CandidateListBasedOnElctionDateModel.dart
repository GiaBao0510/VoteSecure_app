class CandidateListBasedonElEctionDateModel{
  final String?
  HoTen,
  GioiTinh,
  Email,
  HinhAnh,
  TenDanToc,
  TrangThai,
  NgaySinh;
  int soLuotBinhChon, tyLeBinhChon;

  //Ham nhập
  CandidateListBasedonElEctionDateModel({
    required this.HoTen,
    required this.GioiTinh,
    required this.Email,
    required this.TrangThai,
    required this.HinhAnh,
    required this.TenDanToc,
    required this.NgaySinh,
    required this.soLuotBinhChon,
    required this.tyLeBinhChon,
  });

  CandidateListBasedonElEctionDateModel copywith({
    String? HoTen,
    String? GioiTinh,
    String? TrangThai,
    String? Email,
    int? soLuotBinhChon,
    String? HinhAnh,
    String? TenDanToc,
    int? tyLeBinhChon,
    String? NgaySinh
  }){
    return CandidateListBasedonElEctionDateModel(
        TrangThai: TrangThai ?? this.TrangThai,
        Email:  Email?? this.Email,
        GioiTinh: GioiTinh ?? this.GioiTinh,
        HinhAnh: HinhAnh ?? this.HinhAnh,
        TenDanToc: TenDanToc ?? this.TenDanToc,
        HoTen: HoTen ?? this.HoTen,
        NgaySinh: NgaySinh ?? this.NgaySinh,
        tyLeBinhChon: tyLeBinhChon ?? this.tyLeBinhChon,
        soLuotBinhChon: soLuotBinhChon ?? this.soLuotBinhChon
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'HoTen':HoTen,
      'GioiTinh':GioiTinh,
      'TrangThai':TrangThai,
      'Email':Email,
      'tyLeBinhChon':tyLeBinhChon,
      'HinhAnh':HinhAnh,
      'TenDanToc':TenDanToc,
      'NgaySinh':NgaySinh,
      'soLuotBinhChon':soLuotBinhChon
    };
  }

  factory CandidateListBasedonElEctionDateModel.fromMap(Map<String, dynamic> map){
    return CandidateListBasedonElEctionDateModel(
        HoTen: map['hoTen'] ?? 'null',
        GioiTinh: map['gioiTinh'] ?? 'null',
        TrangThai: map['trangThai'] ?? 'null',
        Email: map['email'] ?? 'null',
        soLuotBinhChon: map['soLuotBinhChon'] ?? 'null',
        HinhAnh: map['HinhAnh'] ?? 'null',
        TenDanToc: map['tenDanToc'] ?? 'null',
        NgaySinh: map['ngaySinh'],
        tyLeBinhChon: map['tyLeBinhChon'] ?? 'null'
    );
  }
}