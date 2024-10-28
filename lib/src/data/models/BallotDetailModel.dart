class BallotDetailModel{
  final String?
      iD_Phieu,
      iD_user,
      hoTen,
      thoiDiem;
  BigInt? giaTriPhieuBau;


  //Ham nhập
  BallotDetailModel({
    required this.iD_Phieu,
    required this.iD_user,
    required this.hoTen,
    required this.thoiDiem,
    required this.giaTriPhieuBau,
  });

  BallotDetailModel copywith({
    String? iD_Phieu,
    String? iD_user,
    String? hoTen,
    String? thoiDiem,
    BigInt? giaTriPhieuBau,
  }){
    return BallotDetailModel(
      iD_Phieu: iD_Phieu ?? this.iD_Phieu,
      iD_user:  iD_user?? this.iD_user,
      hoTen: hoTen ?? this.hoTen,
      thoiDiem: thoiDiem ?? this.thoiDiem,
      giaTriPhieuBau: giaTriPhieuBau ?? this.giaTriPhieuBau,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'iD_Phieu':iD_Phieu,
      'iD_user':iD_user,
      'hoTen':hoTen,
      'thoiDiem':thoiDiem,
      'giaTriPhieuBau':giaTriPhieuBau,
    };
  }

  factory BallotDetailModel.fromMap(Map<String, dynamic> map){
    return BallotDetailModel(
      iD_Phieu: map['iD_Phieu'] ?? 'null',
      iD_user: map['iD_user'] ?? 'null',
      hoTen: map['hoTen'] ?? 'null',
      thoiDiem: map['thoiDiem'] ?? 'null',
      giaTriPhieuBau: BigInt.from(map['giaTriPhieuBau'] ?? 0),
    );
  }
}