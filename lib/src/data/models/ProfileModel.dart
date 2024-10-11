class ProfileModel{
  final String?
    HoTen,
    GioiTinh,
    DiaChi,
    Email,
    SDT,
    HinhAnh,
    TenDanToc,
    ID_Object;
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
    required this.NgaySinh,
    required this.ID_Object
  });

  ProfileModel copywith({
    String? HoTen,
    String? GioiTinh,
    String? DiaChi,
    String? Email,
    String? SDT,
    String? HinhAnh,
    String? TenDanToc,
    String? ID_Object,
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
      SDT: SDT ?? this.SDT,
      ID_Object: ID_Object ?? this.ID_Object
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
      'ID_Object':ID_Object
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map){
    return ProfileModel(
        HoTen: map['HoTen'] ?? 'nuul',
        GioiTinh: map['GioiTinh'] ?? 'nuul',
        DiaChi: map['DiaChi'] ?? 'nuul',
        Email: map['Email'] ?? 'nuul',
        SDT: map['SDT'] ?? 'nuul',
        HinhAnh: map['HinhAnh'] ?? 'nuul',
        TenDanToc: map['TenDanToc'] ?? 'nuul',
        NgaySinh: map['NgaySinh'],
        ID_Object: map['ID_Object'] ?? 'nuul'
    );
  }
}