class ElectionModel{
  final DateTime? ngayBD, ngayKT;
  final String? tenKyBauCu, mota;

  ElectionModel({
    required this.ngayBD,
    required this.ngayKT,
    required this.tenKyBauCu,
    required this.mota,
  });

  ElectionModel copywith({
    String? tenKyBauCu,
    String? mota,
    DateTime? ngayBD,
    DateTime? ngayKT
  }){
    return ElectionModel(
        tenKyBauCu: tenKyBauCu ?? this.tenKyBauCu,
        mota:  mota?? this.mota,
        ngayBD: ngayBD ?? this.ngayBD,
        ngayKT: ngayKT ?? this.ngayKT
    );
  }



}