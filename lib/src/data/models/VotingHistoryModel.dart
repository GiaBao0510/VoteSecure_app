class VotingHistoryModel{
  final String?  iD_Phieu, thoiDiemBoPhieu, tenCapUngCu, ngayBD;
  final int? xacThuc;

  //Ham nhập
  VotingHistoryModel({
    required this.iD_Phieu,
    required this.thoiDiemBoPhieu,
    required this.tenCapUngCu,
    required this.ngayBD,
    required this.xacThuc,
  });

  VotingHistoryModel copywith({
    String? iD_Phieu,
    String? thoiDiemBoPhieu,
    String? tenCapUngCu,
    String? ngayBD,
    int? xacThuc,
  }){
    return VotingHistoryModel(
        iD_Phieu: iD_Phieu ?? this.iD_Phieu,
        thoiDiemBoPhieu:  thoiDiemBoPhieu?? this.thoiDiemBoPhieu,
        tenCapUngCu: tenCapUngCu ?? this.tenCapUngCu,
        ngayBD: ngayBD ?? this.ngayBD,
        xacThuc: xacThuc ?? this.xacThuc,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'iD_Phieu':iD_Phieu,
      'thoiDiemBoPhieu':thoiDiemBoPhieu,
      'tenCapUngCu':tenCapUngCu,
      'ngayBD':ngayBD,
      'xacThuc':xacThuc
    };
  }

  factory VotingHistoryModel.fromMap(Map<String, dynamic> map){
    return VotingHistoryModel(
        iD_Phieu: map['iD_Phieu'] ?? 'null',
        thoiDiemBoPhieu: map['thoiDiemBoPhieu'] ?? 'null',
        ngayBD: map['ngayBD'] ?? 'null',
        tenCapUngCu: map['tenCapUngCu'] ?? 'null',
        xacThuc: map['xacThuc'] ?? -1
    );
  }
}