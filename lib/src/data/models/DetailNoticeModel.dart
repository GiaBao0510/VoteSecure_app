class DetailNoticeModel{
  final String?
    thoiDiem,
    noiDungThongBao;

  //Ham nhập
  DetailNoticeModel({
    required this.thoiDiem,
    required this.noiDungThongBao,
  });

  DetailNoticeModel copywith({
    String? thoiDiem,
    String? noiDungThongBao,
  }){
    return DetailNoticeModel(
        thoiDiem: thoiDiem ?? this.thoiDiem,
        noiDungThongBao:  noiDungThongBao?? this.noiDungThongBao,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'thoiDiem':thoiDiem,
      'noiDungThongBao':noiDungThongBao
    };
  }

  factory DetailNoticeModel.fromMap(Map<String, dynamic> map){
    return DetailNoticeModel(
        thoiDiem: map['thoiDiem'] ?? 'null',
        noiDungThongBao: map['noiDungThongBao'] ?? 'null'
    );
  }
}