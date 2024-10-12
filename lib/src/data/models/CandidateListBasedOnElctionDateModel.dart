class CandidateListBasedonElEctionDateModel{
  final String?
  HoTen,
  GioiTinh,
  Email,
  HinhAnh,
  TenDanToc,
  TrangThai,
  NgaySinh,
  GioiThieu,
  tenTrinhDoHocVan;
  final int soLuotBinhChon, tyLeBinhChon;
  bool IsSelected;

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
    required this.IsSelected,
    required this.tenTrinhDoHocVan,
    required this.GioiThieu
  });

  CandidateListBasedonElEctionDateModel copywith({
    String? HoTen,
    String? GioiTinh,
    String? TrangThai,
    String? Email,
    int? soLuotBinhChon,
    String? HinhAnh,
    String? TenDanToc,
    String? GioiThieu,
    int? tyLeBinhChon,
    String? NgaySinh,
    String? tenTrinhDoHocVan,
    bool? IsSelected
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
        soLuotBinhChon: soLuotBinhChon ?? this.soLuotBinhChon,
        IsSelected: IsSelected ?? this.IsSelected,
        tenTrinhDoHocVan: tenTrinhDoHocVan ?? this.tenTrinhDoHocVan,
        GioiThieu: GioiThieu ?? this.GioiThieu
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
      'soLuotBinhChon':soLuotBinhChon,
      'IsSelected':IsSelected,
      'tenTrinhDoHocVan':tenTrinhDoHocVan,
      'GioiThieu':GioiThieu,
    };
  }

  factory CandidateListBasedonElEctionDateModel.fromMap(Map<String, dynamic> map){
    return CandidateListBasedonElEctionDateModel(
        HoTen: map['hoTen'] ?? 'null',
        GioiTinh: map['gioiTinh'] ?? 'null',
        TrangThai: map['trangThai'] ?? 'null',
        Email: map['email'] ?? 'null',
        soLuotBinhChon: map['soLuotBinhChon'] ?? 'null',
        HinhAnh: map['hinhAnh'] ?? 'null',
        TenDanToc: map['tenDanToc'] ?? 'null',
        NgaySinh: map['ngaySinh'],
        tyLeBinhChon: map['tyLeBinhChon'] ?? 'null',
        IsSelected: false,
        tenTrinhDoHocVan: map['tenTrinhDoHocVan'] ?? 'null',
        GioiThieu: map['gioiThieu'] ?? 'null',
    );
  }
}