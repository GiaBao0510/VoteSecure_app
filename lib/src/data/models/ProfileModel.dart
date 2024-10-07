class ProfileModel{
  final String?
    HoTen,
    GioiTinh,
    DiaChi,
    Email,
    SDT,
    HinhAnh,
    TenDanToc;
  final DateTime? NgaySinh;

  //Ham nhập
  ProfileModel({
    required this.HoTen,
    required this.GioiTinh,
    required this.DiaChi,
    required this.Email,
    required this.SDT,
    required this.HinhAnh,
    required this.TenDanToc,
    required this.NgaySinh
  });

  ProfileModel copywith({
    String? HoTen,
    String? GioiTinh,
    String? DiaChi,
    String? Email,
    String? SDT,
    String? HinhAnh,
    String? TenDanToc,
    DateTime? NgaySinh
  }){
    return ProfileModel(
      DiaChi: DiaChi ?? this.DiaChi,
      Email:  Email?? this.Email,
      GioiTinh: GioiTinh ?? this.GioiTinh,
      HinhAnh: HinhAnh ?? this.HinhAnh,
      TenDanToc: TenDanToc ?? this.TenDanToc,
      HoTen: HoTen ?? this.HoTen,
      NgaySinh: NgaySinh ?? this.NgaySinh,
      SDT: SDT ?? this.SDT
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'HoTen':HoTen,
      'GioiTinh':GioiTinh,
      'DiaChi':DiaChi,
      'Email':Email,
      'SDT':SDT,
      'HinhAnh':HinhAnh,
      'TenDanToc':TenDanToc,
      'NgaySinh':NgaySinh,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map){
    return ProfileModel(
        HoTen: map['HoTen'],
        GioiTinh: map['GioiTinh'],
        DiaChi: map['DiaChi'],
        Email: map['Email'],
        SDT: map['SDT'],
        HinhAnh: map['HinhAnh'],
        TenDanToc: map['TenDanToc'],
        NgaySinh: map['NgaySinh'],
    );
  }
}